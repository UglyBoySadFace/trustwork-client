import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/events/contact_request_bubble.dart';
import 'package:fluffychat/utils/contacts/contacts_cache.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/test_client.dart';
import '../utils/trustwork_test_helpers.dart';

// FakeMatrixApi accepts arbitrary send/state PUTs for this room ID, which the
// accept flow needs (addToDirectChat + com.trustwork.contact_accepted event).
const roomId = '!1234:fakeServer.notExisting';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Client client;
  late Room room;

  setUpAll(() async {
    client = await prepareTestClient(loggedIn: true);
    room = Room(id: roomId, client: client);
  });

  setUp(() async {
    mockSecureStorage();
  });

  Event buildEvent({
    required String senderId,
    int? requestId = 5,
    String? initialMessage,
    String? targetMatrixId,
  }) => Event(
    content: <String, dynamic>{
      'request_id': ?requestId,
      'requester_matrix_id': '@alice:server',
      'requester_display_name': 'Alice',
      'target_matrix_id': targetMatrixId ?? client.userID,
      'status': 'pending',
      'initial_message': ?initialMessage,
    },
    type: 'com.trustwork.contact_request',
    eventId: '\$request5',
    senderId: senderId,
    originServerTs: DateTime.now(),
    room: room,
  );

  Future<Widget> buildApp(
    Event event, {
    Map<String, String>? contacts,
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      if (contacts != null) ContactsCache.storageKey: jsonEncode(contacts),
    });
    final prefs = await SharedPreferences.getInstance();
    final state = TestMatrixState(client: client, store: prefs)
      ..contactsCache.loadFromStore(prefs);
    return MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: Provider<MatrixState>.value(
        value: state,
        child: Scaffold(
          body: SingleChildScrollView(
            child: ContactRequestBubble(event: event),
          ),
        ),
      ),
    );
  }

  testWidgets('recipient sees the request card with all actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(buildEvent(senderId: '@alice:server')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Alice wants to connect'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
    expect(find.text('Block'), findsOneWidget);
    expect(find.text('Request more info'), findsOneWidget);
  });

  testWidgets('recipient sees the initial message when present', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(
        buildEvent(senderId: '@alice:server', initialMessage: 'Hi, it is me'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hi, it is me'), findsOneWidget);
  });

  testWidgets('sender sees a waiting card without the initial message', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(
        buildEvent(
          senderId: client.userID!,
          targetMatrixId: '@bob:server',
          initialMessage: 'Hi, it is me',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Connection request sent'), findsOneWidget);
    expect(
      find.text('Waiting for @bob:server to respond.'),
      findsOneWidget,
    );
    // The greeting is only rendered on the recipient side.
    expect(find.text('Hi, it is me'), findsNothing);
    expect(find.text('Accept'), findsNothing);
  });

  testWidgets('sender sees accepted state once the target is a contact', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(
        buildEvent(senderId: client.userID!, targetMatrixId: '@bob:server'),
        contacts: <String, String>{'@bob:server': 'Bob'},
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Connection request accepted'), findsOneWidget);
  });

  testWidgets('an event without request_id renders as invalid', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(buildEvent(senderId: '@alice:server', requestId: null)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Invalid contact request event.'), findsOneWidget);
  });

  testWidgets('accept posts to the accept endpoint and resolves the card', (
    tester,
  ) async {
    final posts = <String>[];
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST') {
        posts.add(options.path);
        return jsonBody(200, <String, dynamic>{
          'matrix_user_id': '@alice:server',
          'display_name': 'Alice',
        });
      }
      // Incoming-request count refresh + contacts-cache refresh.
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(
      await buildApp(buildEvent(senderId: '@alice:server')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Accept'));
    await tester.pumpAndSettle();

    expect(posts, ['/contacts/requests/5/accept']);
    expect(find.text('You accepted this request.'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);
  });

  testWidgets('decline posts to the decline endpoint and resolves the card', (
    tester,
  ) async {
    final posts = <String>[];
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST') {
        posts.add(options.path);
        return jsonBody(200, <String, dynamic>{});
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(
      await buildApp(buildEvent(senderId: '@alice:server')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();

    expect(posts, ['/contacts/requests/5/decline']);
    expect(find.text('You declined this request.'), findsOneWidget);
  });

  testWidgets('a failing action shows a snackbar and keeps the card open', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST') {
        return jsonBody(500, <String, dynamic>{'detail': 'server broke'});
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(
      await buildApp(buildEvent(senderId: '@alice:server')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Block'));
    await tester.pumpAndSettle();

    expect(find.text('server broke'), findsOneWidget);
    expect(find.text('Accept'), findsOneWidget);
  });
}
