import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_group/new_group.dart';
import 'package:fluffychat/utils/contacts/contacts_cache.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../utils/test_client.dart';
import '../utils/trustwork_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Client client;

  setUpAll(() async {
    client = await prepareTestClient(loggedIn: true);
  });

  setUp(() async {
    mockSecureStorage();
  });

  Future<Widget> buildApp({Map<String, String>? contacts}) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      if (contacts != null) ContactsCache.storageKey: jsonEncode(contacts),
    });
    final prefs = await SharedPreferences.getInstance();
    final state = TestMatrixState(client: client, store: prefs)
      ..contactsCache.loadFromStore(prefs);
    final router = GoRouter(
      initialLocation: '/new',
      routes: [
        GoRoute(
          path: '/new',
          builder: (_, _) => Provider<MatrixState>.value(
            value: state,
            child: const NewGroup(),
          ),
        ),
        GoRoute(
          path: '/rooms',
          builder: (_, _) => const Scaffold(body: Text('rooms-list')),
        ),
        GoRoute(
          path: '/rooms/:roomid',
          builder: (_, s) =>
              Scaffold(body: Text('room:${s.pathParameters['roomid']}')),
        ),
      ],
    );
    return MaterialApp.router(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: router,
    );
  }

  testWidgets('lists accepted contacts sorted by display name', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(
        contacts: <String, String>{
          '@zed:server': 'Zed',
          '@amy:server': 'Amy',
        },
      ),
    );
    await tester.pumpAndSettle();

    final checkboxes = tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .toList();
    expect(checkboxes.length, 2);
    expect((checkboxes.first.title as Text).data, 'Amy');
    expect((checkboxes.last.title as Text).data, 'Zed');
  });

  testWidgets('warns when there are no accepted contacts', (tester) async {
    await tester.pumpWidget(await buildApp());
    await tester.pumpAndSettle();

    expect(
      find.text(
        'You have no accepted contacts yet. '
        'Add contacts first before creating a group.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('requires a name and at least one selected contact', (
    tester,
  ) async {
    await tester.pumpWidget(
      await buildApp(contacts: <String, String>{'@amy:server': 'Amy'}),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Please fill out'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hikers');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    expect(find.text('Select at least one contact.'), findsOneWidget);
  });

  testWidgets('creates the group via POST /groups and opens the room', (
    tester,
  ) async {
    Map<String, dynamic>? posted;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST' && options.path.endsWith('/groups')) {
        posted = decodeRequestBody(options.data);
        return jsonBody(201, <String, dynamic>{
          'id': 7,
          'name': 'Hikers',
          'admin': <String, dynamic>{
            'matrix_user_id': client.userID,
            'display_name': 'Me',
          },
          'matrix_room_id': '!new:server',
          'my_status': 'joined',
          'members': <Object>[],
        });
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(
      await buildApp(contacts: <String, String>{'@amy:server': 'Amy'}),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Hikers');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(posted?['name'], 'Hikers');
    expect(posted?['member_matrix_ids'], <String>['@amy:server']);
    expect(find.text('room:!new:server'), findsOneWidget);
  });

  testWidgets('shows the API error when creation fails', (tester) async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST' && options.path.endsWith('/groups')) {
        return jsonBody(400, <String, dynamic>{
          'detail': 'not your contact',
        });
      }
      return jsonBody(200, <Object>[]);
    });

    await tester.pumpWidget(
      await buildApp(contacts: <String, String>{'@amy:server': 'Amy'}),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Hikers');
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('not your contact'), findsOneWidget);
  });
}
