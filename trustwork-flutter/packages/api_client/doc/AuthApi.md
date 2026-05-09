# api_client.api.AuthApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bankidCallbackAuthBankidCallbackGet**](AuthApi.md#bankidcallbackauthbankidcallbackget) | **GET** /auth/bankid/callback | Bankid Callback
[**bankidStartAuthBankidStartGet**](AuthApi.md#bankidstartauthbankidstartget) | **GET** /auth/bankid/start | Bankid Start


# **bankidCallbackAuthBankidCallbackGet**
> JsonObject bankidCallbackAuthBankidCallbackGet(code, state, error, errorDescription)

Bankid Callback

Bank iD callback — links identity to existing user and provisions Matrix account.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAuthApi();
final String code = code_example; // String | 
final String state = state_example; // String | 
final String error = error_example; // String | 
final String errorDescription = errorDescription_example; // String | 

try {
    final response = api.bankidCallbackAuthBankidCallbackGet(code, state, error, errorDescription);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->bankidCallbackAuthBankidCallbackGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**|  | [optional] 
 **state** | **String**|  | [optional] 
 **error** | **String**|  | [optional] 
 **errorDescription** | **String**|  | [optional] 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bankidStartAuthBankidStartGet**
> JsonObject bankidStartAuthBankidStartGet()

Bankid Start

Start Bank iD verification for an authenticated user. Requires Bearer token from email verify/login.

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getAuthApi();

try {
    final response = api.bankidStartAuthBankidStartGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->bankidStartAuthBankidStartGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

