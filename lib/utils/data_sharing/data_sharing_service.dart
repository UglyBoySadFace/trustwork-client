import 'dart:async';
import 'dart:collection';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

/// Owns both directions of the data-sharing to-device handshake. UI layers
/// call into this service; this service does not know about widgets.
///
/// Wire types (encrypted to-device events):
///  - `m.data_request`  — callee → caller. Lists the requested fields.
///  - `m.data_response` — caller → callee. Carries a short-lived fetch token.
///  - `m.data_decline`  — caller → callee. No payload beyond the request id.
class DataSharingService {
  DataSharingService(this._client) {
    _toDeviceSub = _client.onToDeviceEvent.stream.listen(_handle);
  }

  final Client _client;
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

  /// Caller-side stream of inbound requests during ringing.
  Stream<IncomingDataRequest> get incomingRequests => _incoming.stream;

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
        pending.completer.complete(DataSharingTimedOut());
      }
    });
    _pending[requestId] = _PendingRequest(completer, timer);

    try {
      await _sendEncrypted(callerMatrixId, eventTypeRequest, {
        'request_id': requestId,
        'fields': fields.map((f) => f.wireId).toList(),
      });
    } catch (e, s) {
      Logs().w('[DataSharing] failed to send request', e, s);
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
      Logs().w('[DataSharing] approve API failed; sending decline', e, s);
      await decline(request);
      rethrow;
    }

    if (token == null || token.isEmpty) {
      Logs().w('[DataSharing] approve API returned no token; sending decline');
      await decline(request);
      return;
    }

    await _sendEncrypted(request.fromMatrixId, eventTypeResponse, {
      'request_id': request.requestId,
      'token': token,
    });
  }

  /// Caller-side: decline [request]. No middleware call.
  Future<void> decline(IncomingDataRequest request) async {
    await _sendEncrypted(request.fromMatrixId, eventTypeDecline, {
      'request_id': request.requestId,
    });
  }

  Future<void> _sendEncrypted(
    String matrixId,
    String eventType,
    Map<String, dynamic> message,
  ) async {
    final deviceKeys =
        _client.userDeviceKeys[matrixId]?.deviceKeys.values.toList() ??
        <DeviceKeys>[];
    if (deviceKeys.isEmpty) {
      throw StateError('No known devices for $matrixId');
    }
    await _client.sendToDeviceEncrypted(deviceKeys, eventType, message);
  }

  Future<void> _handle(ToDeviceEvent event) async {
    final type = event.type;
    if (type != eventTypeRequest &&
        type != eventTypeResponse &&
        type != eventTypeDecline) {
      return;
    }
    if (event.sender == _client.userID) return;

    final content = event.content;
    final requestId = content['request_id'];
    if (requestId is! String || requestId.isEmpty) return;

    if (!_seenIds.add(requestId)) return;
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
        _incoming.add(
          IncomingDataRequest(
            requestId: requestId,
            fromMatrixId: event.sender,
            fields: fields,
          ),
        );
        break;
      case eventTypeResponse:
        final pending = _pending.remove(requestId);
        if (pending == null) return;
        pending.timer.cancel();
        final token = content['token'];
        if (token is! String || token.isEmpty) {
          _completeIfNeeded(
            pending.completer,
            DataSharingErrored(StateError('Missing token in response')),
          );
          return;
        }
        try {
          final fetched = await TrustworkApiService.instance.authedRequest(
            (auth) => TrustworkApiService.instance.sharing
                .fetchSharedDataDataSharingFetchGet(
                  token: token,
                  headers: <String, String>{'Authorization': 'Bearer $auth'},
                ),
          );
          final data = fetched.data;
          if (data == null) {
            _completeIfNeeded(
              pending.completer,
              DataSharingErrored(StateError('Empty fetch response')),
            );
            return;
          }
          _completeIfNeeded(pending.completer, DataSharingApproved(data));
        } catch (e, s) {
          Logs().w('[DataSharing] fetch failed', e, s);
          _completeIfNeeded(pending.completer, DataSharingErrored(e));
        }
        break;
      case eventTypeDecline:
        final pending = _pending.remove(requestId);
        if (pending == null) return;
        pending.timer.cancel();
        _completeIfNeeded(pending.completer, DataSharingDeclined());
        break;
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
    _incoming.close();
  }
}

class _PendingRequest {
  _PendingRequest(this.completer, this.timer);
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
