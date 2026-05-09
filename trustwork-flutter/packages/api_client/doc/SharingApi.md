# api_client.api.SharingApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approveDataRequestDataSharingApprovePost**](SharingApi.md#approvedatarequestdatasharingapprovepost) | **POST** /data-sharing/approve | Approve Data Request
[**fetchSharedDataDataSharingFetchGet**](SharingApi.md#fetchshareddatadatasharingfetchget) | **GET** /data-sharing/fetch | Fetch Shared Data
[**getSharingPreferencesMeSharingPreferencesGet**](SharingApi.md#getsharingpreferencesmesharingpreferencesget) | **GET** /me/sharing-preferences | Get Sharing Preferences
[**updateSharingPreferencesMeSharingPreferencesPut**](SharingApi.md#updatesharingpreferencesmesharingpreferencesput) | **PUT** /me/sharing-preferences | Update Sharing Preferences


# **approveDataRequestDataSharingApprovePost**
> DataSharingApproveResponse approveDataRequestDataSharingApprovePost(dataSharingApproveRequest)

Approve Data Request

Caller approves a data request from the callee. Returns a short-lived token.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getSharingApi();
final DataSharingApproveRequest dataSharingApproveRequest = ; // DataSharingApproveRequest | 

try {
    final response = api.approveDataRequestDataSharingApprovePost(dataSharingApproveRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharingApi->approveDataRequestDataSharingApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dataSharingApproveRequest** | [**DataSharingApproveRequest**](DataSharingApproveRequest.md)|  | 

### Return type

[**DataSharingApproveResponse**](DataSharingApproveResponse.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **fetchSharedDataDataSharingFetchGet**
> SharedData fetchSharedDataDataSharingFetchGet(token)

Fetch Shared Data

Callee fetches approved data. Requires both the token and the callee's JWT.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getSharingApi();
final String token = token_example; // String | 

try {
    final response = api.fetchSharedDataDataSharingFetchGet(token);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharingApi->fetchSharedDataDataSharingFetchGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 

### Return type

[**SharedData**](SharedData.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSharingPreferencesMeSharingPreferencesGet**
> SharingPreferences getSharingPreferencesMeSharingPreferencesGet()

Get Sharing Preferences

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getSharingApi();

try {
    final response = api.getSharingPreferencesMeSharingPreferencesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharingApi->getSharingPreferencesMeSharingPreferencesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SharingPreferences**](SharingPreferences.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSharingPreferencesMeSharingPreferencesPut**
> SharingPreferences updateSharingPreferencesMeSharingPreferencesPut(sharingPreferences)

Update Sharing Preferences

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getSharingApi();
final SharingPreferences sharingPreferences = ; // SharingPreferences | 

try {
    final response = api.updateSharingPreferencesMeSharingPreferencesPut(sharingPreferences);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SharingApi->updateSharingPreferencesMeSharingPreferencesPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sharingPreferences** | [**SharingPreferences**](SharingPreferences.md)|  | 

### Return type

[**SharingPreferences**](SharingPreferences.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

