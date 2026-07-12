import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/contact_requests/incoming_requests_tab.dart';
import 'package:fluffychat/pages/contact_requests/outgoing_requests_tab.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

class _MockAdapter implements HttpClientAdapter {
  _MockAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => _handler(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonBody(int status, Object body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

Map<String, dynamic> _incomingRequest({
  int id = 1,
  String status = 'pending',
  String? initialMessage,
}) => <String, dynamic>{
  'id': id,
  'status': status,
  'created_at': '2026-07-01T12:00:00Z',
  'requester': <String, dynamic>{
    'matrix_user_id': '@alice:server',
    'display_name': 'Alice',
  },
  'requester_sharing_preferences': <String, dynamic>{
    'share_country': true,
  },
  'initial_message': ?initialMessage,
};

Map<String, dynamic> _outgoingRequest({
  int id = 1,
  String status = 'pending',
}) => <String, dynamic>{
  'id': id,
  'status': status,
  'target_matrix_id': '@bob:server',
  'created_at': '2026-07-01T12:00:00Z',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // Mock the secure-storage method channel — flutter_secure_storage hits a
    // platform channel that doesn't exist in tests.
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const channel = MethodChannel(
      'plugins.it_nomads.com/flutter_secure_storage',
    );
    final fakeStore = <String, String>{
      'tw_access_token': 'fake-token',
      'tw_refresh_token': 'fake-refresh',
    };
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'read':
          return fakeStore[call.arguments['key']];
        case 'readAll':
          return Map<String, String>.from(fakeStore);
        case 'write':
          fakeStore[call.arguments['key']] = call.arguments['value'] as String;
          return null;
        case 'delete':
          fakeStore.remove(call.arguments['key']);
          return null;
        case 'deleteAll':
          fakeStore.clear();
          return null;
        case 'containsKey':
          return fakeStore.containsKey(call.arguments['key']);
      }
      return null;
    });
  });

  // A detached MatrixState is enough for the incoming tab: it only touches
  // in-memory fields (incomingContactRequestCount) during load/decline/block.
  Widget buildIncoming(MatrixState state) => MaterialApp(
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: Provider<MatrixState>.value(
      value: state,
      child: const Scaffold(body: IncomingRequestsTab()),
    ),
  );

  Widget buildOutgoing() => MaterialApp(
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: const Scaffold(body: OutgoingRequestsTab()),
  );

  group('IncomingRequestsTab', () {
    testWidgets('shows empty state when there are no pending requests', (
      tester,
    ) async {
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter(
        (options) async => _jsonBody(200, <Object>[]),
      );

      await tester.pumpWidget(buildIncoming(MatrixState()));
      await tester.pumpAndSettle();

      expect(find.text('No incoming contact requests'), findsOneWidget);
    });

    testWidgets('renders a pending request with name, mxid and greeting', (
      tester,
    ) async {
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter(
        (options) async =>
            _jsonBody(200, <Object>[_incomingRequest(initialMessage: 'Hi!')]),
      );

      final state = MatrixState();
      await tester.pumpWidget(buildIncoming(state));
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('@alice:server'), findsOneWidget);
      expect(find.text('Hi!'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Decline'), findsOneWidget);
      expect(find.text('Block'), findsOneWidget);
      // Pending badge count is published to the Matrix state.
      expect(state.incomingContactRequestCount.value, 1);
    });

    testWidgets('shows error with retry, and retry recovers', (tester) async {
      var failing = true;
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter((
        options,
      ) async {
        if (failing) {
          return _jsonBody(500, <String, dynamic>{'detail': 'server broke'});
        }
        return _jsonBody(200, <Object>[_incomingRequest()]);
      });

      await tester.pumpWidget(buildIncoming(MatrixState()));
      await tester.pumpAndSettle();

      expect(find.text('server broke'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      failing = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('decline posts to the decline endpoint and reloads', (
      tester,
    ) async {
      final posts = <String>[];
      var declined = false;
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter((
        options,
      ) async {
        if (options.method == 'POST') {
          posts.add(options.path);
          declined = true;
          return _jsonBody(200, <String, dynamic>{});
        }
        return _jsonBody(
          200,
          declined ? <Object>[] : <Object>[_incomingRequest()],
        );
      });

      await tester.pumpWidget(buildIncoming(MatrixState()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Decline'));
      await tester.pumpAndSettle();

      expect(posts, ['/contacts/requests/1/decline']);
      expect(find.text('No incoming contact requests'), findsOneWidget);
    });

    testWidgets('block posts to the block endpoint and reloads', (
      tester,
    ) async {
      final posts = <String>[];
      var blocked = false;
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter((
        options,
      ) async {
        if (options.method == 'POST') {
          posts.add(options.path);
          blocked = true;
          return _jsonBody(200, <String, dynamic>{});
        }
        return _jsonBody(
          200,
          blocked ? <Object>[] : <Object>[_incomingRequest()],
        );
      });

      await tester.pumpWidget(buildIncoming(MatrixState()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Block'));
      await tester.pumpAndSettle();

      expect(posts, ['/contacts/requests/1/block']);
      expect(find.text('No incoming contact requests'), findsOneWidget);
    });
  });

  group('OutgoingRequestsTab', () {
    testWidgets('shows empty state', (tester) async {
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter(
        (options) async => _jsonBody(200, <Object>[]),
      );

      await tester.pumpWidget(buildOutgoing());
      await tester.pumpAndSettle();

      expect(find.text('No outgoing contact requests'), findsOneWidget);
    });

    testWidgets('lists requests with their status', (tester) async {
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter(
        (options) async => _jsonBody(200, <Object>[
          _outgoingRequest(id: 1, status: 'pending'),
          _outgoingRequest(id: 2, status: 'accepted'),
        ]),
      );

      await tester.pumpWidget(buildOutgoing());
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Accepted'), findsOneWidget);
    });
  });
}
