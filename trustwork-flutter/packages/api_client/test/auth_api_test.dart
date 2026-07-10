import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for AuthApi
void main() {
  final instance = ApiClient().getAuthApi();

  group(AuthApi, () {
    // Bankid Callback
    //
    // Bank iD callback — links identity to existing user and provisions Matrix account.
    //
    //Future<JsonObject> bankidCallbackAuthBankidCallbackGet({ String code, String state, String error, String errorDescription }) async
    test('test bankidCallbackAuthBankidCallbackGet', () async {
      // TODO
    });

    // Bankid Start
    //
    // Start Bank iD verification for an authenticated user. Requires Bearer token from email verify/login.
    //
    //Future<JsonObject> bankidStartAuthBankidStartGet() async
    test('test bankidStartAuthBankidStartGet', () async {
      // TODO
    });

  });
}
