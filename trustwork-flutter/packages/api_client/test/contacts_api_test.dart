import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for ContactsApi
void main() {
  final instance = ApiClient().getContactsApi();

  group(ContactsApi, () {
    // Scan Contacts
    //
    // Accept a list of SHA-256 hashed phone numbers and return which ones belong to registered users.  Privacy: the client hashes phone numbers locally before sending. The server hashes its stored numbers and compares. Only verified users with a phone number are matchable. The requesting user's own number is excluded from results.
    //
    //Future<ContactsScanResponse> scanContactsContactsScanPost(ContactsScanRequest contactsScanRequest) async
    test('test scanContactsContactsScanPost', () async {
      // TODO
    });

  });
}
