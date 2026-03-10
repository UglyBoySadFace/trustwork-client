//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:openapi/api.dart';
import 'package:test/test.dart';


/// tests for AuthApi
void main() {
  // final instance = AuthApi();

  group('tests for AuthApi', () {
    // Bankid Callback
    //
    // Bank iD OAuth2 callback endpoint.  Bank iD redirects here after user authentication with code and state, or with error parameters if authentication failed.  For now, this just extracts the user identity and returns it. Later, this will create/update Matrix accounts and return credentials.
    //
    //Future<Object> bankidCallbackAuthBankidCallbackGet({ String code, String state, String error, String errorDescription }) async
    test('test bankidCallbackAuthBankidCallbackGet', () async {
      // TODO
    });

    // Bankid Start
    //
    // Start Bank iD OAuth2 flow.  Returns a redirect URL that the client should open in a browser/webview.
    //
    //Future<Object> bankidStartAuthBankidStartGet() async
    test('test bankidStartAuthBankidStartGet', () async {
      // TODO
    });

    // Bankid Test
    //
    // Test endpoint: triggers the full Bank iD flow and redirects to authorization URL.  This is for quick browser-based testing. Open http://localhost:8000/auth/bankid/test in your browser to start the flow.
    //
    //Future<Object> bankidTestAuthBankidTestGet() async
    test('test bankidTestAuthBankidTestGet', () async {
      // TODO
    });

  });
}
