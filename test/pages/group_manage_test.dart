import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/group_manage/group_manage_page.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/test_client.dart';
import '../utils/trustwork_test_helpers.dart';

Map<String, dynamic> memberJson(
  String mxid,
  String name, {
  String status = 'joined',
  bool isAdmin = false,
}) => <String, dynamic>{
  'matrix_user_id': mxid,
  'display_name': name,
  'status': status,
  'is_admin': isAdmin,
};

Map<String, dynamic> detailJson({
  required String adminMxid,
  required List<Map<String, dynamic>> members,
  String myStatus = 'joined',
}) => <String, dynamic>{
  'id': 7,
  'name': 'Hikers',
  'admin': <String, dynamic>{
    'matrix_user_id': adminMxid,
    'display_name': 'Admin',
  },
  'matrix_room_id': '!grp:server',
  'my_status': myStatus,
  'members': members,
};

Map<String, dynamic> suggestionJson() => <String, dynamic>{
  'id': 11,
  'status': 'pending',
  'created_at': '2026-07-01T12:00:00Z',
  'suggester': <String, dynamic>{
    'matrix_user_id': '@sug:server',
    'display_name': 'Suggy',
  },
  'suggested_matrix_id': '@cand:server',
  'admin_knows_suggested': false,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Client client;
  late String myMxid;

  setUpAll(() async {
    client = await prepareTestClient(loggedIn: true);
    myMxid = client.userID!;
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockSecureStorage();

    // Seed the GroupsService singleton so the page can resolve the room ID.
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter(
      (options) async => jsonBody(200, <Object>[
        <String, dynamic>{
          'id': 7,
          'name': 'Hikers',
          'admin': <String, dynamic>{
            'matrix_user_id': '@admin:server',
            'display_name': 'Admin',
          },
          'matrix_room_id': '!grp:server',
          'my_status': 'joined',
          'member_count': 3,
        },
      ]),
    );
    await GroupsService.instance.refresh();
  });

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/manage',
      routes: [
        GoRoute(
          path: '/manage',
          builder: (_, _) => Provider<MatrixState>.value(
            value: TestMatrixState(client: client),
            child: const GroupManagePage(roomId: '!grp:server'),
          ),
        ),
        GoRoute(
          path: '/rooms',
          builder: (_, _) => const Scaffold(body: Text('rooms-list')),
        ),
        GoRoute(
          path: '/rooms/:roomid/group-suggestions',
          builder: (_, _) => const Scaffold(body: Text('suggestions-page')),
        ),
      ],
    );
    return MaterialApp.router(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: router,
    );
  }

  testWidgets(
    'admin sees members, admin actions and the suggestions badge',
    (tester) async {
      TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
        options,
      ) async {
        if (options.path.endsWith('/suggestions')) {
          return jsonBody(200, <Object>[suggestionJson()]);
        }
        if (options.path.endsWith('/groups/7')) {
          return jsonBody(
            200,
            detailJson(
              adminMxid: myMxid,
              members: [
                memberJson(myMxid, 'Me', isAdmin: true),
                memberJson('@bob:server', 'Bob'),
                memberJson('@carl:server', 'Carl', status: 'invited'),
                memberJson('@dave:server', 'Dave', status: 'left'),
              ],
            ),
          );
        }
        return jsonBody(200, <Object>[]);
      });

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Left members are filtered out of the count and the list.
      expect(find.text('3 participants'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Carl'), findsOneWidget);
      expect(find.text('Dave'), findsNothing);
      // Admin affordances.
      expect(find.text('Add member'), findsOneWidget);
      expect(find.text('Member suggestions'), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // pending-suggestions badge
      expect(find.text('Suggest a member'), findsNothing);
      expect(find.text('Leave group'), findsOneWidget);
      // Only non-admin members get a remove button.
      expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));
    },
  );

  testWidgets('removing a member confirms and calls DELETE', (tester) async {
    final deletes = <String>[];
    var removed = false;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'DELETE') {
        deletes.add(options.path);
        removed = true;
        return jsonBody(200, <String, dynamic>{});
      }
      if (options.path.endsWith('/suggestions')) {
        return jsonBody(200, <Object>[]);
      }
      if (options.path.endsWith('/groups/7')) {
        return jsonBody(
          200,
          detailJson(
            adminMxid: myMxid,
            members: [
              memberJson(myMxid, 'Me', isAdmin: true),
              if (!removed) memberJson('@bob:server', 'Bob'),
            ],
          ),
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.remove_circle_outline));
    await tester.pumpAndSettle();

    expect(find.text('Remove Bob from this group?'), findsOneWidget);
    // Dialog title and confirm button both read "Remove" — tap the button.
    await tester.tap(find.text('Remove').last);
    await tester.pumpAndSettle();

    expect(deletes, ['/groups/7/members/@bob:server']);
    expect(find.text('Bob'), findsNothing);
  });

  testWidgets('non-admin member sees suggest instead of admin actions', (
    tester,
  ) async {
    var suggestionsCalled = false;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/suggestions')) {
        suggestionsCalled = true;
        return jsonBody(200, <Object>[]);
      }
      if (options.path.endsWith('/groups/7')) {
        return jsonBody(
          200,
          detailJson(
            adminMxid: '@admin:server',
            members: [
              memberJson('@admin:server', 'Admin', isAdmin: true),
              memberJson(myMxid, 'Me'),
            ],
          ),
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Suggest a member'), findsOneWidget);
    expect(find.text('Add member'), findsNothing);
    expect(find.text('Member suggestions'), findsNothing);
    expect(find.byIcon(Icons.remove_circle_outline), findsNothing);
    expect(suggestionsCalled, isFalse);
  });

  testWidgets('a 403 detail (no longer a member) leaves the page', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/groups/7')) {
        return jsonBody(403, <String, dynamic>{'detail': 'not a member'});
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('rooms-list'), findsOneWidget);
  });
}
