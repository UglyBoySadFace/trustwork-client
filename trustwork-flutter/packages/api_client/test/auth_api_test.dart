import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for AuthApi
void main() {
  final instance = ApiClient().getAuthApi();

  group(AuthApi, () {
    // Bankid Callback
    //
    // Bank iD OAuth2 callback endpoint.  Bank iD redirects here after user authentication with code and state, or with error parameters if authentication failed.  For now, this just extracts the user identity and returns it. Later, this will create/update Matrix accounts and return credentials.
    //
    //Future<JsonObject> bankidCallbackAuthBankidCallbackGet({ String code, String state, String error, String errorDescription }) async
    test('test bankidCallbackAuthBankidCallbackGet', () async {
      // TODO
    });

    // Bankid Start
    //
    // Start Bank iD OAuth2 flow.  Requires a valid onboarding_token from email verification. Optionally pass a phone number to link it to the account. Returns a redirect URL that the client should open in a browser/webview.
    //
    //Future<JsonObject> bankidStartAuthBankidStartGet(String onboardingToken, { String phone }) async
    test('test bankidStartAuthBankidStartGet', () async {
      // TODO
    });

    // Bankid Test
    //
    // Test endpoint: triggers the full Bank iD flow and redirects to authorization URL.  This is for quick browser-based testing. Open http://localhost:8000/auth/bankid/test in your browser to start the flow.
    //
    //Future<JsonObject> bankidTestAuthBankidTestGet() async
    test('test bankidTestAuthBankidTestGet', () async {
      // TODO
    });

  });
}
