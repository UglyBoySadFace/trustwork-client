import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/group_invite/group_invite_page.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import '../utils/trustwork_test_helpers.dart';

Map<String, dynamic> previewJson({
  int id = 5,
  String name = 'Hikers',
  int totalMembers = 4,
  int knownCount = 2,
  int unknownCount = 2,
  Map<String, dynamic>? suggestedBy,
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'admin': <String, dynamic>{
    'matrix_user_id': '@admin:server',
    'display_name': 'Admin',
  },
  'total_members': totalMembers,
  'known_count': knownCount,
  'unknown_count': unknownCount,
  'suggested_by': suggestedBy,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockSecureStorage();
  });

  Widget buildApp() {
    final router = GoRouter(
      initialLocation: '/invite',
      routes: [
        GoRoute(
          path: '/invite',
          builder: (_, _) => const GroupInvitePage(groupId: 5),
        ),
        GoRoute(
          path: '/rooms',
          builder: (_, _) => const Scaffold(body: Text('rooms-list')),
        ),
        GoRoute(
          path: '/rooms/:roomid',
          builder: (_, state) =>
              Scaffold(body: Text('room:${state.pathParameters['roomid']}')),
        ),
      ],
    );
    return MaterialApp.router(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: router,
    );
  }

  testWidgets('renders the unknown-members invite body', (tester) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(200, previewJson());
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Hikers'), findsOneWidget);
    expect(
      find.textContaining(
        'Admin invites you to a group chat called Hikers',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining("you'll share your data with 2 people"),
      findsOneWidget,
    );
    expect(find.text('Join'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
  });

  testWidgets('renders the all-known body when unknown_count is 0', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(
          200,
          previewJson(knownCount: 4, unknownCount: 0),
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.textContaining('you know all of them'),
      findsOneWidget,
    );
  });

  testWidgets('renders the suggested-by body variant', (tester) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(
          200,
          previewJson(
            suggestedBy: <String, dynamic>{
              'matrix_user_id': '@sug:server',
              'display_name': 'Suggy',
            },
          ),
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Suggy thinks you might be interested in joining',
      ),
      findsOneWidget,
    );
  });

  testWidgets('join posts to the join endpoint and opens the room', (
    tester,
  ) async {
    final posts = <String>[];
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(200, previewJson());
      }
      if (options.method == 'POST') {
        posts.add(options.path);
        return jsonBody(200, <String, dynamic>{
          'id': 5,
          'name': 'Hikers',
          'admin': <String, dynamic>{
            'matrix_user_id': '@admin:server',
            'display_name': 'Admin',
          },
          'matrix_room_id': '!joined:server',
          'my_status': 'joined',
          'members': <Object>[],
        });
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    expect(posts, ['/groups/5/join']);
    expect(find.text('room:!joined:server'), findsOneWidget);
  });

  testWidgets('join 409 (already joined) resolves the room via refresh', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(200, previewJson());
      }
      if (options.method == 'POST') {
        return jsonBody(409, <String, dynamic>{'detail': 'already joined'});
      }
      // GET /groups during the recovery refresh.
      return jsonBody(200, <Object>[
        <String, dynamic>{
          'id': 5,
          'name': 'Hikers',
          'admin': <String, dynamic>{
            'matrix_user_id': '@admin:server',
            'display_name': 'Admin',
          },
          'matrix_room_id': '!existing:server',
          'my_status': 'joined',
          'member_count': 4,
        },
      ]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    expect(find.text('room:!existing:server'), findsOneWidget);
  });

  testWidgets('decline posts to the decline endpoint and leaves', (
    tester,
  ) async {
    final posts = <String>[];
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(200, previewJson());
      }
      if (options.method == 'POST') {
        posts.add(options.path);
        return jsonBody(200, <String, dynamic>{});
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();

    expect(posts, ['/groups/5/decline']);
    expect(find.text('rooms-list'), findsOneWidget);
  });

  testWidgets('a 404 preview (invite already handled) leaves silently', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(404, <String, dynamic>{'detail': 'gone'});
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('rooms-list'), findsOneWidget);
  });

  testWidgets('a failing preview shows the server error', (tester) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.path.endsWith('/invite-preview')) {
        return jsonBody(500, <String, dynamic>{'detail': 'server broke'});
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('server broke'), findsOneWidget);
  });
}
