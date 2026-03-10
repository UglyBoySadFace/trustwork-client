# openapi.api.AuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bankidCallbackAuthBankidCallbackGet**](AuthApi.md#bankidcallbackauthbankidcallbackget) | **GET** /auth/bankid/callback | Bankid Callback
[**bankidStartAuthBankidStartGet**](AuthApi.md#bankidstartauthbankidstartget) | **GET** /auth/bankid/start | Bankid Start
[**bankidTestAuthBankidTestGet**](AuthApi.md#bankidtestauthbankidtestget) | **GET** /auth/bankid/test | Bankid Test


# **bankidCallbackAuthBankidCallbackGet**
> Object bankidCallbackAuthBankidCallbackGet(code, state, error, errorDescription)

Bankid Callback

Bank iD OAuth2 callback endpoint.  Bank iD redirects here after user authentication with code and state, or with error parameters if authentication failed.  For now, this just extracts the user identity and returns it. Later, this will create/update Matrix accounts and return credentials.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AuthApi();
final code = code_example; // String | Authorization code from Bank iD
final state = state_example; // String | State token for CSRF protection
final error = error_example; // String | Error code from Bank iD
final errorDescription = errorDescription_example; // String | Error description from Bank iD

try {
    final result = api_instance.bankidCallbackAuthBankidCallbackGet(code, state, error, errorDescription);
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->bankidCallbackAuthBankidCallbackGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**| Authorization code from Bank iD | [optional] 
 **state** | **String**| State token for CSRF protection | [optional] 
 **error** | **String**| Error code from Bank iD | [optional] 
 **errorDescription** | **String**| Error description from Bank iD | [optional] 

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bankidStartAuthBankidStartGet**
> Object bankidStartAuthBankidStartGet()

Bankid Start

Start Bank iD OAuth2 flow.  Returns a redirect URL that the client should open in a browser/webview.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AuthApi();

try {
    final result = api_instance.bankidStartAuthBankidStartGet();
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->bankidStartAuthBankidStartGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **bankidTestAuthBankidTestGet**
> Object bankidTestAuthBankidTestGet()

Bankid Test

Test endpoint: triggers the full Bank iD flow and redirects to authorization URL.  This is for quick browser-based testing. Open http://localhost:8000/auth/bankid/test in your browser to start the flow.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AuthApi();

try {
    final result = api_instance.bankidTestAuthBankidTestGet();
    print(result);
} catch (e) {
    print('Exception when calling AuthApi->bankidTestAuthBankidTestGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Object**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

