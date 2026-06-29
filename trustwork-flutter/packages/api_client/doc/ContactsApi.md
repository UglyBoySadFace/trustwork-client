# api_client.api.ContactsApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptContactRequestContactsRequestsRequestIdAcceptPost**](ContactsApi.md#acceptcontactrequestcontactsrequestsrequestidacceptpost) | **POST** /contacts/requests/{request_id}/accept | Accept Contact Request
[**blockContactRequestContactsRequestsRequestIdBlockPost**](ContactsApi.md#blockcontactrequestcontactsrequestsrequestidblockpost) | **POST** /contacts/requests/{request_id}/block | Block Contact Request
[**createContactRequestContactsRequestsPost**](ContactsApi.md#createcontactrequestcontactsrequestspost) | **POST** /contacts/requests | Create Contact Request
[**declineContactRequestContactsRequestsRequestIdDeclinePost**](ContactsApi.md#declinecontactrequestcontactsrequestsrequestiddeclinepost) | **POST** /contacts/requests/{request_id}/decline | Decline Contact Request
[**listBlockedRequestsContactsBlockedGet**](ContactsApi.md#listblockedrequestscontactsblockedget) | **GET** /contacts/blocked | List Blocked Requests
[**listContactsContactsGet**](ContactsApi.md#listcontactscontactsget) | **GET** /contacts | List Contacts
[**listIncomingRequestsContactsRequestsIncomingGet**](ContactsApi.md#listincomingrequestscontactsrequestsincomingget) | **GET** /contacts/requests/incoming | List Incoming Requests
[**listOutgoingRequestsContactsRequestsOutgoingGet**](ContactsApi.md#listoutgoingrequestscontactsrequestsoutgoingget) | **GET** /contacts/requests/outgoing | List Outgoing Requests
[**removeContactContactsMatrixUserIdDelete**](ContactsApi.md#removecontactcontactsmatrixuseriddelete) | **DELETE** /contacts/{matrix_user_id} | Remove Contact
[**scanContactsContactsScanPost**](ContactsApi.md#scancontactscontactsscanpost) | **POST** /contacts/scan | Scan Contacts
[**unblockContactRequestContactsRequestsRequestIdUnblockPost**](ContactsApi.md#unblockcontactrequestcontactsrequestsrequestidunblockpost) | **POST** /contacts/requests/{request_id}/unblock | Unblock Contact Request


# **acceptContactRequestContactsRequestsRequestIdAcceptPost**
> ContactSummary acceptContactRequestContactsRequestsRequestIdAcceptPost(requestId)

Accept Contact Request

Accept a request — reveals my identity to the requester and opens messaging.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final int requestId = 56; // int | 

try {
    final response = api.acceptContactRequestContactsRequestsRequestIdAcceptPost(requestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->acceptContactRequestContactsRequestsRequestIdAcceptPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **int**|  | 

### Return type

[**ContactSummary**](ContactSummary.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **blockContactRequestContactsRequestsRequestIdBlockPost**
> blockContactRequestContactsRequestsRequestIdBlockPost(requestId)

Block Contact Request

Block the requester of a pending request. They cannot send further requests.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final int requestId = 56; // int | 

try {
    api.blockContactRequestContactsRequestsRequestIdBlockPost(requestId);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->blockContactRequestContactsRequestsRequestIdBlockPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createContactRequestContactsRequestsPost**
> OutgoingContactRequest createContactRequestContactsRequestsPost(contactRequestCreate)

Create Contact Request

Send a contact request to the user behind a Matrix ID.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final ContactRequestCreate contactRequestCreate = ; // ContactRequestCreate | 

try {
    final response = api.createContactRequestContactsRequestsPost(contactRequestCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->createContactRequestContactsRequestsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **contactRequestCreate** | [**ContactRequestCreate**](ContactRequestCreate.md)|  | 

### Return type

[**OutgoingContactRequest**](OutgoingContactRequest.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineContactRequestContactsRequestsRequestIdDeclinePost**
> declineContactRequestContactsRequestsRequestIdDeclinePost(requestId)

Decline Contact Request

Decline a pending request. The requester may send a new one later.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final int requestId = 56; // int | 

try {
    api.declineContactRequestContactsRequestsRequestIdDeclinePost(requestId);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->declineContactRequestContactsRequestsRequestIdDeclinePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBlockedRequestsContactsBlockedGet**
> BuiltList<BlockedContactRequest> listBlockedRequestsContactsBlockedGet()

List Blocked Requests

Requests I blocked — the data behind an Unblock action.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();

try {
    final response = api.listBlockedRequestsContactsBlockedGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->listBlockedRequestsContactsBlockedGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;BlockedContactRequest&gt;**](BlockedContactRequest.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listContactsContactsGet**
> BuiltList<ContactSummary> listContactsContactsGet()

List Contacts

List accepted contacts (two-way, regardless of who initiated).

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();

try {
    final response = api.listContactsContactsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->listContactsContactsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ContactSummary&gt;**](ContactSummary.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listIncomingRequestsContactsRequestsIncomingGet**
> BuiltList<IncomingContactRequest> listIncomingRequestsContactsRequestsIncomingGet()

List Incoming Requests

Requests sent to me. Pending ones await my decision.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();

try {
    final response = api.listIncomingRequestsContactsRequestsIncomingGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->listIncomingRequestsContactsRequestsIncomingGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;IncomingContactRequest&gt;**](IncomingContactRequest.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listOutgoingRequestsContactsRequestsOutgoingGet**
> BuiltList<OutgoingContactRequest> listOutgoingRequestsContactsRequestsOutgoingGet()

List Outgoing Requests

Requests I sent, with their current status.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();

try {
    final response = api.listOutgoingRequestsContactsRequestsOutgoingGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->listOutgoingRequestsContactsRequestsOutgoingGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;OutgoingContactRequest&gt;**](OutgoingContactRequest.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeContactContactsMatrixUserIdDelete**
> removeContactContactsMatrixUserIdDelete(matrixUserId)

Remove Contact

Remove an accepted contact (either direction). Tears down the shared room.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final String matrixUserId = matrixUserId_example; // String | 

try {
    api.removeContactContactsMatrixUserIdDelete(matrixUserId);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->removeContactContactsMatrixUserIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **matrixUserId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **unblockContactRequestContactsRequestsRequestIdUnblockPost**
> unblockContactRequestContactsRequestsRequestIdUnblockPost(requestId)

Unblock Contact Request

Unblock a request you previously blocked — resets it to pending.  Only the blocker (the request's target) may unblock. A blocked requester cannot unblock themselves.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getContactsApi();
final int requestId = 56; // int | 

try {
    api.unblockContactRequestContactsRequestsRequestIdUnblockPost(requestId);
} on DioException catch (e) {
    print('Exception when calling ContactsApi->unblockContactRequestContactsRequestsRequestIdUnblockPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

