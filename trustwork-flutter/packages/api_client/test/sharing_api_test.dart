import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for SharingApi
void main() {
  final instance = ApiClient().getSharingApi();

  group(SharingApi, () {
    // Approve Data Request
    //
    // Caller approves a data request from the callee. Returns a short-lived token.
    //
    //Future<DataSharingApproveResponse> approveDataRequestDataSharingApprovePost(DataSharingApproveRequest dataSharingApproveRequest) async
    test('test approveDataRequestDataSharingApprovePost', () async {
      // TODO
    });

    // Fetch Shared Data
    //
    // Callee fetches approved data. Requires both the token and the callee's JWT.
    //
    //Future<SharedData> fetchSharedDataDataSharingFetchGet(String token) async
    test('test fetchSharedDataDataSharingFetchGet', () async {
      // TODO
    });

    // Get Sharing Preferences
    //
    //Future<SharingPreferences> getSharingPreferencesMeSharingPreferencesGet() async
    test('test getSharingPreferencesMeSharingPreferencesGet', () async {
      // TODO
    });

    // Update Sharing Preferences
    //
    //Future<SharingPreferences> updateSharingPreferencesMeSharingPreferencesPut(SharingPreferences sharingPreferences) async
    test('test updateSharingPreferencesMeSharingPreferencesPut', () async {
      // TODO
    });

  });
}
