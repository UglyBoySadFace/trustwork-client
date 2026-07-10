import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for TokenApi
void main() {
  final instance = ApiClient().getTokenApi();

  group(TokenApi, () {
    // Get Matrix Password
    //
    //Future<MatrixPasswordResponse> getMatrixPasswordMeMatrixPasswordGet() async
    test('test getMatrixPasswordMeMatrixPasswordGet', () async {
      // TODO
    });

    // Get Me
    //
    //Future<UserProfile> getMeMeGet() async
    test('test getMeMeGet', () async {
      // TODO
    });

    // Refresh Token
    //
    //Future<TokenResponse> refreshTokenAuthRefreshPost(RefreshRequest refreshRequest) async
    test('test refreshTokenAuthRefreshPost', () async {
      // TODO
    });

  });
}
