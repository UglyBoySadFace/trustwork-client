import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for EmailAuthApi
void main() {
  final instance = ApiClient().getEmailAuthApi();

  group(EmailAuthApi, () {
    // Email Login
    //
    // Login for existing users — verifies email code and returns full auth tokens.
    //
    //Future<AuthResponse> emailLoginAuthEmailLoginPost(EmailVerifyRequest emailVerifyRequest) async
    test('test emailLoginAuthEmailLoginPost', () async {
      // TODO
    });

    // Email Start
    //
    // Send (or resend) a verification email containing both a 6-digit code and a magic link.  Calling this again acts as resend: any previous unused code is invalidated, subject to a 60s rate limit (returns 429 if called too soon).
    //
    //Future<EmailStartResponse> emailStartAuthEmailStartPost(EmailStartRequest emailStartRequest) async
    test('test emailStartAuthEmailStartPost', () async {
      // TODO
    });

    // Email Verify
    //
    // Registration — verifies email code, creates user with optional phone, returns auth tokens.
    //
    //Future<AuthResponse> emailVerifyAuthEmailVerifyPost(EmailVerifyRequest emailVerifyRequest) async
    test('test emailVerifyAuthEmailVerifyPost', () async {
      // TODO
    });

    // Email Verify Link
    //
    // Magic-link verification — runs in the browser, redirects back into the app via deep link.  Handles both registration and login: a new email creates an account, an existing one logs in.
    //
    //Future<JsonObject> emailVerifyLinkAuthEmailVerifyLinkGet(String token, { String phone }) async
    test('test emailVerifyLinkAuthEmailVerifyLinkGet', () async {
      // TODO
    });

  });
}
