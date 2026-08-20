import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/events/group_invite_bubble.dart';
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
    String myStatus = 'invited',
  }) => <String, dynamic>{
    'id': id,
    'name': name,
    'admin': <String, dynamic>{
      'matrix_user_id': '@admin:server',
      'display_name': 'Admin',
    },
    'matrix_room_id': '!grp:server',
    'my_status': myStatus,
    'member_count': 3,
  };

  Event buildEvent({
    required String senderId,
    int? groupId = 5,
    String groupName = 'Hikers',
    String adminDisplayName = 'Admin',
    String inviteeMatrixId = '@bob:server',
    String? suggestedByDisplayName,
  }) => Event(
    content: <String, dynamic>{
      if (groupId != null) 'group_id': groupId,
      'group_name': groupName,
      'admin_matrix_id': '@admin:server',
      'admin_display_name': adminDisplayName,
      'invitee_matrix_id': inviteeMatrixId,
      'status': 'invited',
      if (suggestedByDisplayName != null)
        'suggested_by_display_name': suggestedByDisplayName,
    },
    type: 'com.trustwork.group_invite',
    eventId: '\$invite5',
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
                child: GroupInviteBubble(event: event),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/rooms/group-invite/:groupId',
          builder: (_, state) => Scaffold(
            body: Text('invite-page:${state.pathParameters['groupId']}'),
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

  testWidgets('admin (sender) sees a passive invited-someone line', (
    tester,
  ) async {
    await seedGroups(tester, []);
    await tester.pumpWidget(buildApp(buildEvent(senderId: client.userID!)));
    await tester.pumpAndSettle();

    expect(find.text('Invited @bob:server to Hikers'), findsOneWidget);
    expect(find.text('View invite'), findsNothing);
  });

  testWidgets('invitee with no known group status sees the invite card', (
    tester,
  ) async {
    await seedGroups(tester, []);
    await tester.pumpWidget(buildApp(buildEvent(senderId: '@admin:server')));
    await tester.pumpAndSettle();

    expect(find.text('Admin invited you to Hikers'), findsOneWidget);
    expect(find.text('View invite'), findsOneWidget);
  });

  testWidgets('tapping View invite navigates to the invite page', (
    tester,
  ) async {
    await seedGroups(tester, []);
    await tester.pumpWidget(buildApp(buildEvent(senderId: '@admin:server')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('View invite'));
    await tester.pumpAndSettle();

    expect(find.text('invite-page:5'), findsOneWidget);
  });

  testWidgets(
    'joined status resolves the card instead of showing the button',
    (tester) async {
      await seedGroups(tester, [groupSummaryJson(myStatus: 'joined')]);
      await tester.pumpWidget(
        buildApp(buildEvent(senderId: '@admin:server')),
      );
      await tester.pumpAndSettle();

      expect(find.text('You joined this group.'), findsOneWidget);
      expect(find.text('View invite'), findsNothing);
    },
  );

  testWidgets('declined status shows the declined line', (tester) async {
    await seedGroups(tester, [groupSummaryJson(myStatus: 'declined')]);
    await tester.pumpWidget(buildApp(buildEvent(senderId: '@admin:server')));
    await tester.pumpAndSettle();

    expect(find.text('You declined this invite.'), findsOneWidget);
  });

  testWidgets('suggested-by line renders when present', (tester) async {
    await seedGroups(tester, []);
    await tester.pumpWidget(
      buildApp(
        buildEvent(senderId: '@admin:server', suggestedByDisplayName: 'Suggy'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Suggested by Suggy'), findsOneWidget);
  });

  testWidgets('a missing group_id renders as an unknown event', (
    tester,
  ) async {
    await seedGroups(tester, []);
    await tester.pumpWidget(
      buildApp(buildEvent(senderId: '@admin:server', groupId: null)),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('@admin:server sent a com.trustwork.group_invite event'),
      findsOneWidget,
    );
  });
}
