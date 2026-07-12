import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/utils/contacts/contacts_cache.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

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

  test('loadFromStore restores persisted names', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      ContactsCache.storageKey: jsonEncode(<String, String>{
        '@alice:server': 'Alice',
      }),
    });
    final store = await SharedPreferences.getInstance();

    final cache = ContactsCache()..loadFromStore(store);

    expect(cache.isContact('@alice:server'), isTrue);
    expect(cache.label('@alice:server'), 'Alice');
    expect(cache.displayName('@alice:server'), 'Alice');
  });

  test('label falls back to the Matrix ID for strangers', () async {
    final store = await SharedPreferences.getInstance();
    final cache = ContactsCache()..loadFromStore(store);

    expect(cache.isContact('@stranger:server'), isFalse);
    expect(cache.displayName('@stranger:server'), isNull);
    expect(cache.label('@stranger:server'), '@stranger:server');
  });

  test('loadFromStore ignores a corrupt cache entry', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      ContactsCache.storageKey: 'this is not json',
    });
    final store = await SharedPreferences.getInstance();

    final cache = ContactsCache()..loadFromStore(store);

    expect(cache.isContact('@alice:server'), isFalse);
    expect(cache.label('@alice:server'), '@alice:server');
  });

  test('refresh fetches GET /contacts, replaces entries and persists',
      () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      ContactsCache.storageKey: jsonEncode(<String, String>{
        '@old:server': 'Old Contact',
      }),
    });
    final store = await SharedPreferences.getInstance();
    final cache = ContactsCache()..loadFromStore(store);

    TrustworkApiService.instance.dio.httpClientAdapter = _MockAdapter((
      options,
    ) async {
      if (options.method == 'GET' && options.path.endsWith('/contacts')) {
        return _jsonBody(200, <Map<String, dynamic>>[
          <String, dynamic>{
            'matrix_user_id': '@bob:server',
            'display_name': 'Bob',
          },
          // Entry without a matrix_user_id must be skipped, not crash.
          <String, dynamic>{'matrix_user_id': null, 'display_name': 'Ghost'},
        ]);
      }
      return _jsonBody(404, <String, dynamic>{});
    });

    await cache.refresh(store);

    expect(cache.isContact('@bob:server'), isTrue);
    expect(cache.label('@bob:server'), 'Bob');
    // The stale entry is replaced, not merged.
    expect(cache.isContact('@old:server'), isFalse);

    // Persisted for the next cold start.
    final persisted =
        jsonDecode(store.getString(ContactsCache.storageKey)!)
            as Map<String, dynamic>;
    expect(persisted, <String, String>{'@bob:server': 'Bob'});
  });
}
