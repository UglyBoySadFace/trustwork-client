import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_data_sharing/settings_data_sharing_view.dart';
import 'package:fluffychat/pages/settings_data_sharing/view_model/settings_data_sharing_view_model.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class _MockAdapter implements HttpClientAdapter {
  _MockAdapter(this._handler);

  final Future<ResponseBody> Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) =>
      _handler(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonBody(int status, Map<String, dynamic> body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // Mock the secure-storage method channel — flutter_secure_storage hits a
    // platform channel that doesn't exist in tests.
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const channel =
        MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
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

  Future<Widget> buildApp() async {
    final prefs = await SharedPreferences.getInstance();
    return MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: ViewModelBuilder<SettingsDataSharingViewModel>(
        create: () => SettingsDataSharingViewModel(prefs),
        builder: (context, vm, _) => SettingsDataSharingView(vm),
      ),
    );
  }

  testWidgets(
    'optimistic toggle stays after a successful PUT',
    (tester) async {
      // Arrange: mock server returns all-false on GET; PUT echoes the body
      // back (so the toggle persists).
      var serverPrefs = _allFalse();
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter(
        (options) async {
          if (options.method == 'GET') {
            return _jsonBody(200, serverPrefs);
          }
          if (options.method == 'PUT') {
            serverPrefs = Map<String, dynamic>.from(options.data);
            return _jsonBody(200, serverPrefs);
          }
          return _jsonBody(404, <String, dynamic>{});
        },
      );

      await tester.pumpWidget(await buildApp());

      // Wait for bootstrap GET to complete and switches to render.
      await tester.pumpAndSettle();

      final countryFinder = find.byWidgetPredicate(
        (w) => w is SwitchListTile && _matchesField(w, 'Country'),
      );
      expect(countryFinder, findsOneWidget);
      expect(_isOn(tester, countryFinder), isFalse);

      // Act: tap to enable.
      await tester.tap(countryFinder);
      await tester.pump();

      // Assert: optimistic update — switch is on immediately.
      expect(_isOn(tester, countryFinder), isTrue);

      // Wait out the 500ms debounce + PUT round-trip.
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Assert: still on after the network round-trip.
      expect(_isOn(tester, countryFinder), isTrue);
      expect(serverPrefs['share_country'], isTrue);
    },
  );

  testWidgets(
    'failed PUT reverts the toggle to its prior value',
    (tester) async {
      final serverPrefs = _allFalse();
      TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter(
        (options) async {
          if (options.method == 'GET') {
            return _jsonBody(200, serverPrefs);
          }
          if (options.method == 'PUT') {
            return _jsonBody(500, <String, dynamic>{
              'detail': 'something broke',
            });
          }
          return _jsonBody(404, <String, dynamic>{});
        },
      );

      await tester.pumpWidget(await buildApp());
      await tester.pumpAndSettle();

      final countryFinder = find.byWidgetPredicate(
        (w) => w is SwitchListTile && _matchesField(w, 'Country'),
      );
      expect(_isOn(tester, countryFinder), isFalse);

      await tester.tap(countryFinder);
      await tester.pump();
      // Optimistic ON.
      expect(_isOn(tester, countryFinder), isTrue);

      // Debounce + PUT (failure).
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Reverted back to OFF.
      expect(_isOn(tester, countryFinder), isFalse);
    },
  );
}

Map<String, dynamic> _allFalse() => <String, dynamic>{
      'share_country': false,
      'share_state': false,
      'share_street': false,
      'share_street_full': false,
      'share_full_age': false,
      'share_decade_of_age': false,
      'share_is_adult': false,
      'share_nationalities': false,
    };

bool _matchesField(SwitchListTile tile, String label) {
  final title = tile.title;
  if (title is Text) return title.data == label;
  return false;
}

bool _isOn(WidgetTester tester, Finder finder) {
  final tile = tester.widget<SwitchListTile>(finder);
  return tile.value;
}
