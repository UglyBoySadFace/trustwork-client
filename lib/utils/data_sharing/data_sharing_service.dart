import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

typedef SendToDeviceFn = Future<void> Function(
  String matrixId,
  String eventType,
  Map<String, dynamic> message,
);

typedef FetchSharedDataFn = Future<SharedData?> Function(String token);

/// Owns both directions of the data-sharing to-device handshake. UI layers
/// call into this service; this service does not know about widgets.
///
/// Wire types (encrypted to-device events):
///  - `m.data_request`  — callee → caller. Lists the requested fields.
///  - `m.data_response` — caller → callee. Carries a short-lived fetch token.
///  - `m.data_decline`  — caller → callee. No payload beyond the request id.
class DataSharingService {
  DataSharingService(Client client)
      : _client = client,
        _ownUserId = client.userID,
        _toDeviceEvents = client.onToDeviceEvent.stream,
        _sendOverride = null,
        _fetchOverride = null {
    _toDeviceSub = _toDeviceEvents.listen(_handle);
  }

  /// Test-only constructor. Lets a test pump events through [toDeviceEvents]
  /// without building a real `Client`, and intercept network calls through
  /// [sendOverride] and [fetchOverride].
  @visibleForTesting
  DataSharingService.forTesting({
    required Stream<ToDeviceEvent> toDeviceEvents,
    required String ownUserId,
    SendToDeviceFn? sendOverride,
    FetchSharedDataFn? fetchOverride,
  })  : _client = null,
        _ownUserId = ownUserId,
        _toDeviceEvents = toDeviceEvents,
        _sendOverride = sendOverride,
        _fetchOverride = fetchOverride {
    _toDeviceSub = _toDeviceEvents.listen(_handle);
  }

  static const String _logTag = '[DATA-SHARING]';

  final Client? _client;
  final String? _ownUserId;
  final Stream<ToDeviceEvent> _toDeviceEvents;
  final SendToDeviceFn? _sendOverride;
  final FetchSharedDataFn? _fetchOverride;
  StreamSubscription<ToDeviceEvent>? _toDeviceSub;

  static const String eventTypeRequest = 'm.data_request';
  static const String eventTypeResponse = 'm.data_response';
  static const String eventTypeDecline = 'm.data_decline';

  static const _uuid = Uuid();

  final Map<String, _PendingRequest> _pending = {};

  // Insertion-ordered FIFO so we can drop the oldest id when capped. Dart's
  // default `Set` is a [LinkedHashSet], which preserves insertion order.
  final LinkedHashSet<String> _seenIds = LinkedHashSet<String>();
  static const int _maxSeenIds = 256;

  final StreamController<IncomingDataRequest> _incoming =
      StreamController<IncomingDataRequest>.broadcast();
  final StreamController<ProactiveShareData> _proactiveShares =
      StreamController<ProactiveShareData>.broadcast();

  // Cached so that late subscribers (e.g. the dialer widget, which opens after
  // the to-device event is already processed) can still get the data.
  ProactiveShareData? _lastProactiveShare;

  /// Caller-side stream of inbound requests during ringing.
  Stream<IncomingDataRequest> get incomingRequests => _incoming.stream;

  /// Callee-side stream of data the caller pushed without being asked.
  Stream<ProactiveShareData> get proactiveShares => _proactiveShares.stream;

  /// The most recent proactive share received in this session, or null if none.
  /// Use this to replay the share to a subscriber that registered late.
  ProactiveShareData? get lastProactiveShare => _lastProactiveShare;

  /// Callee-side: ask [callerMatrixId] for [fields]. Resolves when the caller
  /// responds, declines, or [timeout] elapses.
  Future<DataSharingOutcome> request({
    required String callerMatrixId,
    required Set<ShareableField> fields,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final requestId = _uuid.v4();
    final completer = Completer<DataSharingOutcome>();
    final timer = Timer(timeout, () {
      final pending = _pending.remove(requestId);
      if (pending != null && !pending.completer.isCompleted) {
        Logs().i(
          '$_logTag request timed out request_id=$requestId matrix_id=$callerMatrixId',
        );
        pending.completer.complete(DataSharingTimedOut());
      }
    });
    _pending[requestId] = _PendingRequest(callerMatrixId, completer, timer);

    Logs().i(
      '$_logTag sending request request_id=$requestId matrix_id=$callerMatrixId fields=${fields.map((f) => f.wireId).toList()}',
    );
    try {
      await _sendEncrypted(callerMatrixId, eventTypeRequest, {
        'request_id': requestId,
        'fields': fields.map((f) => f.wireId).toList(),
      });
    } catch (e, s) {
      Logs().w(
        '$_logTag failed to send request request_id=$requestId matrix_id=$callerMatrixId',
        e,
        s,
      );
      timer.cancel();
      _pending.remove(requestId);
      if (!completer.isCompleted) {
        completer.complete(DataSharingErrored(e));
      }
    }

    return completer.future;
  }

  /// Caller-side: approve [request], call the middleware to mint a token, and
  /// hand it to the callee. If the middleware call fails we send a decline so
  /// the callee isn't left waiting.
  Future<void> approve({
    required IncomingDataRequest request,
    required Set<ShareableField> approvedFields,
  }) async {
    Logs().i(
      '$_logTag approving request request_id=${request.requestId} matrix_id=${request.fromMatrixId} approved_fields=${approvedFields.map((f) => f.wireId).toList()}',
    );
    String? token;
    try {
      final response = await TrustworkApiService.instance.authedRequest(
        (auth) => TrustworkApiService.instance.sharing
            .approveDataRequestDataSharingApprovePost(
              dataSharingApproveRequest: DataSharingApproveRequest(
                (b) => b
                  ..calleeMatrixId = request.fromMatrixId
                  ..approvedFields = ListBuilder<SharableField>(
                    approvedFields.map((f) => f.toApiField()),
                  ),
              ),
              headers: <String, String>{'Authorization': 'Bearer $auth'},
            ),
      );
      token = response.data?.token;
    } catch (e, s) {
      Logs().w(
        '$_logTag approve API failed; sending decline request_id=${request.requestId} matrix_id=${request.fromMatrixId}',
        e,
        s,
      );
      await decline(request);
      rethrow;
    }

    if (token == null || token.isEmpty) {
      Logs().w(
        '$_logTag approve API returned no token; sending decline request_id=${request.requestId} matrix_id=${request.fromMatrixId}',
      );
      await decline(request);
      return;
    }

    await _sendEncrypted(request.fromMatrixId, eventTypeResponse, {
      'request_id': request.requestId,
      'token': token,
    });
    Logs().i(
      '$_logTag response sent request_id=${request.requestId} matrix_id=${request.fromMatrixId}',
    );
  }

  /// Caller-side: proactively push [fields] to [calleeMatrixId] without
  /// waiting for a data request. Used when the caller has pre-configured
  /// sharing preferences and wants to share immediately on call start.
  Future<void> proactiveShare({
    required String calleeMatrixId,
    required Set<ShareableField> fields,
  }) async {
    final syntheticRequest = IncomingDataRequest(
      requestId: _uuid.v4(),
      fromMatrixId: calleeMatrixId,
      fields: fields,
    );
    Logs().i(
      '$_logTag proactive share request_id=${syntheticRequest.requestId} callee_id=$calleeMatrixId fields=${fields.map((f) => f.wireId).toList()}',
    );
    await approve(request: syntheticRequest, approvedFields: fields);
  }

  /// Caller-side: decline [request]. No middleware call.
  Future<void> decline(IncomingDataRequest request) async {
    Logs().i(
      '$_logTag declining request request_id=${request.requestId} matrix_id=${request.fromMatrixId}',
    );
    await _sendEncrypted(request.fromMatrixId, eventTypeDecline, {
      'request_id': request.requestId,
    });
  }

  Future<void> _sendEncrypted(
    String matrixId,
    String eventType,
    Map<String, dynamic> message,
  ) async {
    final override = _sendOverride;
    if (override != null) {
      await override(matrixId, eventType, message);
      return;
    }
    final client = _client!;
    final deviceKeys =
        client.userDeviceKeys[matrixId]?.deviceKeys.values.toList() ??
        <DeviceKeys>[];
    if (deviceKeys.isEmpty) {
      throw StateError('No known devices for $matrixId');
    }
    await client.sendToDeviceEncrypted(deviceKeys, eventType, message);
  }

  Future<SharedData?> _fetchSharedData(String token) async {
    final override = _fetchOverride;
    if (override != null) {
      return override(token);
    }
    final response = await TrustworkApiService.instance.authedRequest(
      (auth) => TrustworkApiService.instance.sharing
          .fetchSharedDataDataSharingFetchGet(
            token: token,
            headers: <String, String>{'Authorization': 'Bearer $auth'},
          ),
    );
    return response.data;
  }

  Future<void> _handle(ToDeviceEvent event) async {
    // Decryption failures are surfaced as ToDeviceEventDecryptionError. The
    // request_id is inside the encrypted payload we never recovered, so we
    // can't correlate it back to a pending request — let the timeout do its
    // job. Treat as a silent decline outcome rather than leaking the error.
    if (event is ToDeviceEventDecryptionError) {
      Logs().w(
        '$_logTag dropping undecryptable to-device event matrix_id=${event.sender}',
        event.exception,
        event.stackTrace,
      );
      return;
    }

    final type = event.type;
    if (type != eventTypeRequest &&
        type != eventTypeResponse &&
        type != eventTypeDecline) {
      return;
    }
    if (event.sender == _ownUserId) return;

    final content = event.content;
    final requestId = content['request_id'];
    if (requestId is! String || requestId.isEmpty) return;

    if (!_seenIds.add(requestId)) {
      Logs().d(
        '$_logTag duplicate event ignored request_id=$requestId type=$type',
      );
      return;
    }
    if (_seenIds.length > _maxSeenIds) {
      _seenIds.remove(_seenIds.first);
    }

    switch (type) {
      case eventTypeRequest:
        final fieldsRaw = content['fields'];
        if (fieldsRaw is! List) return;
        final fields = fieldsRaw
            .whereType<String>()
            .map(ShareableField.fromWire)
            .whereType<ShareableField>()
            .toSet();
        if (fields.isEmpty) return;
        Logs().i(
          '$_logTag incoming request request_id=$requestId matrix_id=${event.sender} fields=${fields.map((f) => f.wireId).toList()}',
        );
        _incoming.add(
          IncomingDataRequest(
            requestId: requestId,
            fromMatrixId: event.sender,
            fields: fields,
          ),
        );
        break;
      case eventTypeResponse:
        final pending = _pending[requestId];
        if (pending == null) {
          // May be a proactive share from the caller — fetch and emit.
          final token = content['token'];
          if (token is String && token.isNotEmpty) {
            unawaited(_handleUnsolicitedResponse(event.sender, requestId, token));
          } else {
            Logs().d(
              '$_logTag response for unknown request_id=$requestId from matrix_id=${event.sender}',
            );
          }
          return;
        }
        // Server stamps `sender`, so we trust it — but reject mismatches
        // defensively. The response must come from the same matrix id we
        // sent the request to.
        if (event.sender != pending.callerMatrixId) {
          Logs().w(
            '$_logTag response sender mismatch request_id=$requestId expected=${pending.callerMatrixId} got=${event.sender}',
          );
          return;
        }
        _pending.remove(requestId);
        pending.timer.cancel();
        final token = content['token'];
        if (token is! String || token.isEmpty) {
          Logs().w(
            '$_logTag response missing token request_id=$requestId matrix_id=${event.sender}',
          );
          _completeIfNeeded(
            pending.completer,
            DataSharingErrored(StateError('Missing token in response')),
          );
          return;
        }
        try {
          final data = await _fetchSharedData(token);
          if (data == null) {
            Logs().w(
              '$_logTag fetch returned empty body request_id=$requestId matrix_id=${event.sender}',
            );
            _completeIfNeeded(
              pending.completer,
              DataSharingErrored(StateError('Empty fetch response')),
            );
            return;
          }
          Logs().i(
            '$_logTag fetch succeeded request_id=$requestId matrix_id=${event.sender}',
          );
          _completeIfNeeded(pending.completer, DataSharingApproved(data));
        } catch (e, s) {
          Logs().w(
            '$_logTag fetch failed request_id=$requestId matrix_id=${event.sender}',
            e,
            s,
          );
          _completeIfNeeded(pending.completer, DataSharingErrored(e));
        }
        break;
      case eventTypeDecline:
        final pending = _pending[requestId];
        if (pending == null) {
          Logs().d(
            '$_logTag decline for unknown request_id=$requestId from matrix_id=${event.sender}',
          );
          return;
        }
        if (event.sender != pending.callerMatrixId) {
          Logs().w(
            '$_logTag decline sender mismatch request_id=$requestId expected=${pending.callerMatrixId} got=${event.sender}',
          );
          return;
        }
        _pending.remove(requestId);
        pending.timer.cancel();
        Logs().i(
          '$_logTag declined request_id=$requestId matrix_id=${event.sender}',
        );
        _completeIfNeeded(pending.completer, DataSharingDeclined());
        break;
    }
  }

  Future<void> _handleUnsolicitedResponse(
    String senderMatrixId,
    String requestId,
    String token,
  ) async {
    Logs().i(
      '$_logTag unsolicited response request_id=$requestId from=$senderMatrixId',
    );
    try {
      final data = await _fetchSharedData(token);
      if (data == null) {
        Logs().w(
          '$_logTag empty fetch for unsolicited response request_id=$requestId',
        );
        return;
      }
      final share = ProactiveShareData(fromMatrixId: senderMatrixId, data: data);
      _lastProactiveShare = share;
      _proactiveShares.add(share);
    } catch (e, s) {
      Logs().w(
        '$_logTag fetch failed for unsolicited response request_id=$requestId',
        e,
        s,
      );
    }
  }

  void _completeIfNeeded(
    Completer<DataSharingOutcome> completer,
    DataSharingOutcome outcome,
  ) {
    if (!completer.isCompleted) completer.complete(outcome);
  }

  void dispose() {
    _toDeviceSub?.cancel();
    _toDeviceSub = null;
    for (final p in _pending.values) {
      p.timer.cancel();
      if (!p.completer.isCompleted) {
        p.completer.complete(DataSharingTimedOut());
      }
    }
    _pending.clear();
    _seenIds.clear();
    _lastProactiveShare = null;
    _incoming.close();
    _proactiveShares.close();
  }
}

class _PendingRequest {
  _PendingRequest(this.callerMatrixId, this.completer, this.timer);
  final String callerMatrixId;
  final Completer<DataSharingOutcome> completer;
  final Timer timer;
}

sealed class DataSharingOutcome {
  const DataSharingOutcome();
}

class DataSharingApproved extends DataSharingOutcome {
  const DataSharingApproved(this.data);
  final SharedData data;
}

class DataSharingDeclined extends DataSharingOutcome {
  const DataSharingDeclined();
}

class DataSharingTimedOut extends DataSharingOutcome {
  const DataSharingTimedOut();
}

class DataSharingErrored extends DataSharingOutcome {
  const DataSharingErrored(this.error);
  final Object error;
}

class IncomingDataRequest {
  const IncomingDataRequest({
    required this.requestId,
    required this.fromMatrixId,
    required this.fields,
  });
  final String requestId;
  final String fromMatrixId;
  final Set<ShareableField> fields;
}

class ProactiveShareData {
  const ProactiveShareData({
    required this.fromMatrixId,
    required this.data,
  });
  final String fromMatrixId;
  final SharedData data;
}
