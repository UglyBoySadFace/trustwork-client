import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/group_suggestions/group_suggestions_page.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import '../utils/trustwork_test_helpers.dart';

Map<String, dynamic> suggestionJson({
  int id = 11,
  String status = 'pending',
  Map<String, dynamic>? suggested,
  bool adminKnowsSuggested = false,
  String? message,
}) => <String, dynamic>{
  'id': id,
  'status': status,
  'created_at': '2026-07-01T12:00:00Z',
  'suggester': <String, dynamic>{
    'matrix_user_id': '@sug:server',
    'display_name': 'Suggy',
  },
  'suggested_matrix_id': '@cand:server',
  'suggested': suggested,
  'admin_knows_suggested': adminKnowsSuggested,
  'message': message,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    mockSecureStorage();

    // Seed the GroupsService singleton so the page can resolve the room ID
    // to a Trustwork group.
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

  Widget buildApp() => MaterialApp(
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: const GroupSuggestionsPage(roomId: '!grp:server'),
  );

  testWidgets('shows the empty state without pending suggestions', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter(
      (options) async => jsonBody(200, <Object>[
        // Non-pending suggestions must be filtered out.
        suggestionJson(id: 1, status: 'invited'),
        suggestionJson(id: 2, status: 'dismissed'),
      ]),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('No pending member suggestions.'), findsOneWidget);
  });

  testWidgets('renders a known suggested contact with the invite prompt', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter(
      (options) async => jsonBody(200, <Object>[
        suggestionJson(
          adminKnowsSuggested: true,
          suggested: <String, dynamic>{
            'matrix_user_id': '@cand:server',
            'display_name': 'Candice',
          },
          message: 'she is great',
        ),
      ]),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Suggy wants to add Candice to a group chat called Hikers.',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining('Suggy writes: "she is great".'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Do you want to invite Candice?'),
      findsOneWidget,
    );
    // Known contact: the raw Matrix ID line is not shown.
    expect(find.text('@cand:server'), findsNothing);
  });

  testWidgets('renders an unknown suggested person with their Matrix ID', (
    tester,
  ) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter(
      (options) async => jsonBody(200, <Object>[suggestionJson()]),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('@cand:server'), findsOneWidget);
    expect(
      find.textContaining('Suggy wants to add this person'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Do you want to invite them?'),
      findsOneWidget,
    );
  });

  testWidgets('invite posts to the invite endpoint and reloads', (
    tester,
  ) async {
    final posts = <String>[];
    var invited = false;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST') {
        posts.add(options.path);
        invited = true;
        return jsonBody(200, <String, dynamic>{
          'id': 7,
          'name': 'Hikers',
          'admin': <String, dynamic>{
            'matrix_user_id': '@admin:server',
            'display_name': 'Admin',
          },
          'matrix_room_id': '!grp:server',
          'my_status': 'joined',
          'members': <Object>[],
        });
      }
      if (options.path.endsWith('/suggestions')) {
        return jsonBody(
          200,
          invited ? <Object>[] : <Object>[suggestionJson()],
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invite'));
    await tester.pumpAndSettle();

    expect(posts, ['/groups/7/suggestions/11/invite']);
    expect(find.text('Invitation sent.'), findsOneWidget);
    expect(find.text('No pending member suggestions.'), findsOneWidget);
  });

  testWidgets('dismiss posts to the dismiss endpoint and reloads', (
    tester,
  ) async {
    final posts = <String>[];
    var dismissed = false;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST') {
        posts.add(options.path);
        dismissed = true;
        return jsonBody(200, <String, dynamic>{});
      }
      if (options.path.endsWith('/suggestions')) {
        return jsonBody(
          200,
          dismissed ? <Object>[] : <Object>[suggestionJson()],
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();

    expect(posts, ['/groups/7/suggestions/11/dismiss']);
    expect(find.text('No pending member suggestions.'), findsOneWidget);
  });

  testWidgets('a 409 on invite reloads without showing an error', (
    tester,
  ) async {
    var posted = false;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST') {
        posted = true;
        return jsonBody(409, <String, dynamic>{'detail': 'already handled'});
      }
      if (options.path.endsWith('/suggestions')) {
        return jsonBody(
          200,
          posted ? <Object>[] : <Object>[suggestionJson()],
        );
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Invite'));
    await tester.pumpAndSettle();

    expect(find.text('already handled'), findsNothing);
    expect(find.text('No pending member suggestions.'), findsOneWidget);
  });
}
