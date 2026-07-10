import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for ContactsApi
void main() {
  final instance = ApiClient().getContactsApi();

  group(ContactsApi, () {
    // Accept Contact Request
    //
    // Accept a request — reveals my identity to the requester and opens messaging.
    //
    //Future<ContactSummary> acceptContactRequestContactsRequestsRequestIdAcceptPost(int requestId) async
    test('test acceptContactRequestContactsRequestsRequestIdAcceptPost', () async {
      // TODO
    });

    // Block Contact Request
    //
    // Block the requester of a pending request. They cannot send further requests.
    //
    //Future blockContactRequestContactsRequestsRequestIdBlockPost(int requestId) async
    test('test blockContactRequestContactsRequestsRequestIdBlockPost', () async {
      // TODO
    });

    // Create Contact Request
    //
    // Send a contact request to the user behind a Matrix ID.
    //
    //Future<OutgoingContactRequest> createContactRequestContactsRequestsPost(ContactRequestCreate contactRequestCreate) async
    test('test createContactRequestContactsRequestsPost', () async {
      // TODO
    });

    // Decline Contact Request
    //
    // Decline a pending request. The requester may send a new one later.
    //
    //Future declineContactRequestContactsRequestsRequestIdDeclinePost(int requestId) async
    test('test declineContactRequestContactsRequestsRequestIdDeclinePost', () async {
      // TODO
    });

    // List Blocked Requests
    //
    // Requests I blocked — the data behind an Unblock action.
    //
    //Future<BuiltList<BlockedContactRequest>> listBlockedRequestsContactsBlockedGet() async
    test('test listBlockedRequestsContactsBlockedGet', () async {
      // TODO
    });

    // List Contacts
    //
    // List accepted contacts (two-way, regardless of who initiated).
    //
    //Future<BuiltList<ContactSummary>> listContactsContactsGet() async
    test('test listContactsContactsGet', () async {
      // TODO
    });

    // List Incoming Requests
    //
    // Requests sent to me. Pending ones await my decision.
    //
    //Future<BuiltList<IncomingContactRequest>> listIncomingRequestsContactsRequestsIncomingGet() async
    test('test listIncomingRequestsContactsRequestsIncomingGet', () async {
      // TODO
    });

    // List Outgoing Requests
    //
    // Requests I sent, with their current status.
    //
    //Future<BuiltList<OutgoingContactRequest>> listOutgoingRequestsContactsRequestsOutgoingGet() async
    test('test listOutgoingRequestsContactsRequestsOutgoingGet', () async {
      // TODO
    });

    // Remove Contact
    //
    // Remove an accepted contact (either direction). Tears down the shared room.
    //
    //Future removeContactContactsMatrixUserIdDelete(String matrixUserId) async
    test('test removeContactContactsMatrixUserIdDelete', () async {
      // TODO
    });

    // Scan Contacts
    //
    // Accept a list of SHA-256 hashed phone numbers and return which ones belong to registered users.  Privacy: the client hashes phone numbers locally before sending. The server hashes its stored numbers and compares. Only verified users with a phone number are matchable. The requesting user's own number is excluded from results.
    //
    //Future<ContactsScanResponse> scanContactsContactsScanPost(ContactsScanRequest contactsScanRequest) async
    test('test scanContactsContactsScanPost', () async {
      // TODO
    });

    // Unblock Contact Request
    //
    // Unblock a request you previously blocked — resets it to pending.  Only the blocker (the request's target) may unblock. A blocked requester cannot unblock themselves.
    //
    //Future unblockContactRequestContactsRequestsRequestIdUnblockPost(int requestId) async
    test('test unblockContactRequestContactsRequestsRequestIdUnblockPost', () async {
      // TODO
    });

  });
}
