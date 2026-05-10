import 'dart:async';

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/data_sharing/data_sharing_service.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';

class _CapturedSend {
  _CapturedSend(this.matrixId, this.eventType, this.message);
  final String matrixId;
  final String eventType;
  final Map<String, dynamic> message;
}

void main() {
  const ownId = '@alice:example.invalid';
  const callerId = '@bob:example.invalid';

  late StreamController<ToDeviceEvent> incoming;
  late List<_CapturedSend> sends;

  setUp(() {
    incoming = StreamController<ToDeviceEvent>.broadcast();
    sends = <_CapturedSend>[];
  });

  tearDown(() async {
    await incoming.close();
  });

  DataSharingService buildService({FetchSharedDataFn? fetch}) {
    return DataSharingService.forTesting(
      toDeviceEvents: incoming.stream,
      ownUserId: ownId,
      sendOverride: (matrixId, type, msg) async {
        sends.add(_CapturedSend(matrixId, type, msg));
      },
      fetchOverride: fetch,
    );
  }

  ToDeviceEvent buildEvent({
    required String type,
    required String sender,
    required Map<String, dynamic> content,
  }) =>
      ToDeviceEvent(sender: sender, type: type, content: content);

  test('happy path: response → fetch → DataSharingApproved', () async {
    final fetched = SharedData(
      (b) => b
        ..country = 'CZ'
        ..isAdult = true,
    );
    final service = buildService(fetch: (_) async => fetched);

    final outcomeFuture = service.request(
      callerMatrixId: callerId,
      fields: {ShareableField.country, ShareableField.isAdult},
      timeout: const Duration(seconds: 30),
    );

    // Allow microtasks (sendOverride) to flush.
    await Future<void>.delayed(Duration.zero);
    expect(sends, hasLength(1));
    expect(sends.single.matrixId, callerId);
    expect(sends.single.eventType, DataSharingService.eventTypeRequest);

    final requestId = sends.single.message['request_id'] as String;
    expect(requestId, isNotEmpty);
    expect(
      sends.single.message['fields'],
      containsAll(<String>['country', 'is_adult']),
    );

    incoming.add(
      buildEvent(
        type: DataSharingService.eventTypeResponse,
        sender: callerId,
        content: {'request_id': requestId, 'token': 't0k3n'},
      ),
    );

    final outcome = await outcomeFuture;
    expect(outcome, isA<DataSharingApproved>());
    final approved = outcome as DataSharingApproved;
    expect(approved.data.country, 'CZ');
    expect(approved.data.isAdult, true);

    service.dispose();
  });

  test('decline event resolves with DataSharingDeclined', () async {
    final service = buildService();

    final outcomeFuture = service.request(
      callerMatrixId: callerId,
      fields: {ShareableField.country},
    );
    await Future<void>.delayed(Duration.zero);
    final requestId = sends.single.message['request_id'] as String;

    incoming.add(
      buildEvent(
        type: DataSharingService.eventTypeDecline,
        sender: callerId,
        content: {'request_id': requestId},
      ),
    );

    expect(await outcomeFuture, isA<DataSharingDeclined>());

    service.dispose();
  });

  test('timeout resolves with DataSharingTimedOut', () async {
    final service = buildService();

    final outcome = await service.request(
      callerMatrixId: callerId,
      fields: {ShareableField.country},
      timeout: const Duration(milliseconds: 50),
    );

    expect(outcome, isA<DataSharingTimedOut>());

    service.dispose();
  });

  test('response with unknown request_id is ignored (no resolution)',
      () async {
    final service = buildService(fetch: (_) async => SharedData((b) => b));

    final outcomeFuture = service.request(
      callerMatrixId: callerId,
      fields: {ShareableField.country},
      timeout: const Duration(milliseconds: 100),
    );
    await Future<void>.delayed(Duration.zero);

    incoming.add(
      buildEvent(
        type: DataSharingService.eventTypeResponse,
        sender: callerId,
        content: {'request_id': 'never-issued', 'token': 't'},
      ),
    );

    // The bogus event must NOT resolve our outstanding completer; it should
    // still time out as scheduled.
    expect(await outcomeFuture, isA<DataSharingTimedOut>());

    service.dispose();
  });

  test('response from a different sender is rejected', () async {
    final service = buildService(fetch: (_) async => SharedData((b) => b));

    final outcomeFuture = service.request(
      callerMatrixId: callerId,
      fields: {ShareableField.country},
      timeout: const Duration(milliseconds: 100),
    );
    await Future<void>.delayed(Duration.zero);
    final requestId = sends.single.message['request_id'] as String;

    incoming.add(
      buildEvent(
        type: DataSharingService.eventTypeResponse,
        sender: '@mallory:example.invalid',
        content: {'request_id': requestId, 'token': 'evil'},
      ),
    );

    expect(await outcomeFuture, isA<DataSharingTimedOut>());

    service.dispose();
  });

  test('fetch returning 410 Gone resolves with DataSharingErrored', () async {
    final service = buildService(
      fetch: (_) async {
        throw DioException(
          requestOptions: RequestOptions(path: '/data-sharing/fetch'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/data-sharing/fetch'),
            statusCode: 410,
          ),
          type: DioExceptionType.badResponse,
        );
      },
    );

    final outcomeFuture = service.request(
      callerMatrixId: callerId,
      fields: {ShareableField.country},
    );
    await Future<void>.delayed(Duration.zero);
    final requestId = sends.single.message['request_id'] as String;

    incoming.add(
      buildEvent(
        type: DataSharingService.eventTypeResponse,
        sender: callerId,
        content: {'request_id': requestId, 'token': 'expired'},
      ),
    );

    final outcome = await outcomeFuture;
    expect(outcome, isA<DataSharingErrored>());
    expect((outcome as DataSharingErrored).error, isA<DioException>());

    service.dispose();
  });

  test(
    'incoming m.data_request is published on the incomingRequests stream',
    () async {
      final service = buildService();
      final received = <IncomingDataRequest>[];
      final sub = service.incomingRequests.listen(received.add);

      incoming.add(
        buildEvent(
          type: DataSharingService.eventTypeRequest,
          sender: callerId,
          content: {
            'request_id': 'req-1',
            'fields': <String>['country', 'full_age'],
          },
        ),
      );

      await Future<void>.delayed(Duration.zero);
      expect(received, hasLength(1));
      expect(received.single.requestId, 'req-1');
      expect(received.single.fromMatrixId, callerId);
      expect(received.single.fields, {
        ShareableField.country,
        ShareableField.fullAge,
      });

      await sub.cancel();
      service.dispose();
    },
  );

  test('events from self are ignored', () async {
    final service = buildService();
    final received = <IncomingDataRequest>[];
    final sub = service.incomingRequests.listen(received.add);

    incoming.add(
      buildEvent(
        type: DataSharingService.eventTypeRequest,
        sender: ownId,
        content: {
          'request_id': 'req-self',
          'fields': <String>['country'],
        },
      ),
    );

    await Future<void>.delayed(Duration.zero);
    expect(received, isEmpty);

    await sub.cancel();
    service.dispose();
  });

  test('decline sends m.data_decline with the request id', () async {
    final service = buildService();

    await service.decline(
      const IncomingDataRequest(
        requestId: 'req-x',
        fromMatrixId: callerId,
        fields: {ShareableField.country},
      ),
    );

    expect(sends, hasLength(1));
    expect(sends.single.matrixId, callerId);
    expect(sends.single.eventType, DataSharingService.eventTypeDecline);
    expect(sends.single.message['request_id'], 'req-x');

    service.dispose();
  });
}
