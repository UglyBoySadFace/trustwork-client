import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for PhoneAuthApi
void main() {
  final instance = ApiClient().getPhoneAuthApi();

  group(PhoneAuthApi, () {
    // Phone Check
    //
    // Check whether a phone number is already registered.
    //
    //Future<PhoneCheckResponse> phoneCheckAuthPhoneCheckGet(String phone) async
    test('test phoneCheckAuthPhoneCheckGet', () async {
      // TODO
    });

  });
}
