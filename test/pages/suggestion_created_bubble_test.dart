import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/events/suggestion_created_bubble.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/test_client.dart';
import '../utils/trustwork_test_helpers.dart';

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

  // Dio's request pipeline relies on real Timers, which don't fire inside
  // testWidgets' fake-async zone without a pump driving them — awaiting a
  // Dio call directly in a test body deadlocks. Route the seed through
  // tester.runAsync() to escape to the real zone for the HTTP round trip.
  Future<void> seedGroups(
    WidgetTester tester,
    List<Map<String, dynamic>> groups,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter(
      (options) async => jsonBody(200, groups),
    );
    await tester.runAsync(() => GroupsService.instance.refresh());
  }

  Map<String, dynamic> groupSummaryJson({
    int id = 5,
    String name = 'Hikers',
  }) => <String, dynamic>{
    'id': id,
    'name': name,
    'admin': <String, dynamic>{
      'matrix_user_id': '@admin:server',
      'display_name': 'Admin',
    },
    'matrix_room_id': '!grp:server',
    'my_status': 'joined',
    'member_count': 3,
  };

  Event buildEvent({
    required String senderId,
    int? groupId = 5,
    String groupName = 'Hikers',
    String suggesterDisplayName = 'Amy',
    String? suggestedDisplayName = 'Bob',
    String suggestedMatrixId = '@bob:server',
    String? message,
  }) => Event(
    content: <String, dynamic>{
      if (groupId != null) 'group_id': groupId,
      'group_name': groupName,
      'suggestion_id': 12,
      'suggester_matrix_id': '@amy:server',
      'suggester_display_name': suggesterDisplayName,
      'suggested_matrix_id': suggestedMatrixId,
      if (suggestedDisplayName != null)
        'suggested_display_name': suggestedDisplayName,
      'admin_matrix_id': '@admin:server',
      if (message != null) 'message': message,
      'status': 'pending',
    },
    type: 'com.trustwork.suggestion_created',
    eventId: '\$suggestion12',
    senderId: senderId,
    originServerTs: DateTime.now(),
    room: room,
  );

  Widget buildApp(Event event) {
    final router = GoRouter(
      initialLocation: '/room',
      routes: [
        GoRoute(
          path: '/room',
          builder: (_, _) => Provider<MatrixState>.value(
            value: TestMatrixState(client: client),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SuggestionCreatedBubble(event: event),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/rooms/:roomId/group-suggestions',
          builder: (_, state) => Scaffold(
            body: Text('suggestions-page:${state.pathParameters['roomId']}'),
          ),
        ),
      ],
    );
    return MaterialApp.router(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: router,
    );
  }

  testWidgets('suggester (sender) sees a passive sent-to line', (
    tester,
  ) async {
    await seedGroups(tester, [groupSummaryJson()]);
    await tester.pumpWidget(buildApp(buildEvent(senderId: client.userID!)));
    await tester.pumpAndSettle();

    expect(find.text('Suggested Bob for Hikers.'), findsOneWidget);
  });

  testWidgets('suggester sees the unknown fallback when the name is gated', (
    tester,
  ) async {
    await seedGroups(tester, [groupSummaryJson()]);
    await tester.pumpWidget(
      buildApp(
        buildEvent(senderId: client.userID!, suggestedDisplayName: null),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Suggested someone for Hikers.'), findsOneWidget);
  });

  testWidgets('admin (recipient) sees the known-suggestion body and a button', (
    tester,
  ) async {
    await seedGroups(tester, [groupSummaryJson()]);
    await tester.pumpWidget(buildApp(buildEvent(senderId: '@amy:server')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Amy wants to add Bob to a group chat called Hikers.',
      ),
      findsOneWidget,
    );
    expect(find.text('View suggestion'), findsOneWidget);
  });

  testWidgets('admin sees the unknown-person body when the name is gated', (
    tester,
  ) async {
    await seedGroups(tester, [groupSummaryJson()]);
    await tester.pumpWidget(
      buildApp(
        buildEvent(senderId: '@amy:server', suggestedDisplayName: null),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Amy wants to add this person to a group chat called Hikers. You haven't yet connected with them via Trustwork.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('admin sees the suggester message when present', (
    tester,
  ) async {
    await seedGroups(tester, [groupSummaryJson()]);
    await tester.pumpWidget(
      buildApp(
        buildEvent(senderId: '@amy:server', message: 'worth adding'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Amy writes: "worth adding".'), findsOneWidget);
  });

  testWidgets('tapping View suggestion navigates to the suggestions page', (
    tester,
  ) async {
    await seedGroups(tester, [groupSummaryJson()]);
    await tester.pumpWidget(buildApp(buildEvent(senderId: '@amy:server')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View suggestion'));
    await tester.pumpAndSettle();

    expect(find.text('suggestions-page:!grp:server'), findsOneWidget);
  });

  testWidgets('a missing group_id renders as an unknown event', (
    tester,
  ) async {
    await seedGroups(tester, []);
    await tester.pumpWidget(
      buildApp(buildEvent(senderId: '@amy:server', groupId: null)),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('@amy:server sent a com.trustwork.suggestion_created event'),
      findsOneWidget,
    );
  });
}
