import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for EmailAuthApi
void main() {
  final instance = ApiClient().getEmailAuthApi();

  group(EmailAuthApi, () {
    // Email Login
    //
    // Login flow for existing users — verifies email code and returns full auth tokens.
    //
    //Future<AuthResponse> emailLoginAuthEmailLoginPost(EmailVerifyRequest emailVerifyRequest) async
    test('test emailLoginAuthEmailLoginPost', () async {
      // TODO
    });

    // Email Start
    //
    //Future<EmailStartResponse> emailStartAuthEmailStartPost(EmailStartRequest emailStartRequest) async
    test('test emailStartAuthEmailStartPost', () async {
      // TODO
    });

    // Email Verify
    //
    // Registration flow — returns an onboarding token to continue with Bank iD.
    //
    //Future<OnboardingTokenResponse> emailVerifyAuthEmailVerifyPost(EmailVerifyRequest emailVerifyRequest) async
    test('test emailVerifyAuthEmailVerifyPost', () async {
      // TODO
    });

  });
}
