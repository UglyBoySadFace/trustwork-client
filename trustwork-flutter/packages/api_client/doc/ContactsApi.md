# api_client.api.ContactsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**scanContactsContactsScanPost**](ContactsApi.md#scancontactscontactsscanpost) | **POST** /contacts/scan | Scan Contacts


# **scanContactsContactsScanPost**
> ContactsScanResponse scanContactsContactsScanPost(contactsScanRequest)

Scan Contacts

Accept a list of SHA-256 hashed phone numbers and return which ones belong to registered users.  Privacy: the client hashes phone numbers locally before sending. The server hashes its stored numbers and compares. Only verified users with a phone number are matchable. The requesting user's own number is excluded from results.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final ContactsScanRequest contactsScanRequest = ; // ContactsScanRequest | 

try {
    final response = api.scanContactsContactsScanPost(contactsScanRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->scanContactsContactsScanPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contactsScanRequest** | [**ContactsScanRequest**](ContactsScanRequest.md)|  | 

### Return type

[**ContactsScanResponse**](ContactsScanResponse.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

