import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/widgets/matrix.dart';

/// Dio adapter that routes every request through [handler] so tests can fake
/// the Trustwork middleware without real HTTP.
class MockAdapter implements HttpClientAdapter {
  MockAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(int status, Object body) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: <String, List<String>>{
      Headers.contentTypeHeader: <String>[Headers.jsonContentType],
    },
  );
}

/// Decodes a captured request body regardless of whether Dio buffered it as a
/// JSON string or an already-decoded map.
Map<String, dynamic> decodeRequestBody(Object? data) {
  if (data is String) return jsonDecode(data) as Map<String, dynamic>;
  return Map<String, dynamic>.from(data as Map);
}

/// Mocks the flutter_secure_storage method channel (it hits a platform
/// channel that doesn't exist in tests) and seeds valid Trustwork tokens so
/// `authedRequest` passes the auth gate.
void mockSecureStorage() {
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
}

/// Detached [MatrixState] with the [client] and [store] accessors overridden
/// so widgets that call `Matrix.of(context).client` / `.store` work without
/// mounting the full [Matrix] widget. Provide it via
/// `Provider<MatrixState>.value`.
class TestMatrixState extends MatrixState {
  TestMatrixState({Client? client, SharedPreferences? store})
      : _client = client,
        _store = store;

  final Client? _client;
  final SharedPreferences? _store;

  @override
  Client get client => _client ?? super.client;

  @override
  SharedPreferences get store => _store ?? super.store;
}
