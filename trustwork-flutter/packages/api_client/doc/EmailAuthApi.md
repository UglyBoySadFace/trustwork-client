# api_client.api.EmailAuthApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**emailLoginAuthEmailLoginPost**](EmailAuthApi.md#emailloginauthemailloginpost) | **POST** /auth/email/login | Email Login
[**emailStartAuthEmailStartPost**](EmailAuthApi.md#emailstartauthemailstartpost) | **POST** /auth/email/start | Email Start
[**emailVerifyAuthEmailVerifyPost**](EmailAuthApi.md#emailverifyauthemailverifypost) | **POST** /auth/email/verify | Email Verify
[**emailVerifyLinkAuthEmailVerifyLinkGet**](EmailAuthApi.md#emailverifylinkauthemailverifylinkget) | **GET** /auth/email/verify-link | Email Verify Link


# **emailLoginAuthEmailLoginPost**
> AuthResponse emailLoginAuthEmailLoginPost(emailVerifyRequest)

Email Login

Login for existing users — verifies email code and returns full auth tokens.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEmailAuthApi();
final EmailVerifyRequest emailVerifyRequest = ; // EmailVerifyRequest | 

try {
    final response = api.emailLoginAuthEmailLoginPost(emailVerifyRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmailAuthApi->emailLoginAuthEmailLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailVerifyRequest** | [**EmailVerifyRequest**](EmailVerifyRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **emailStartAuthEmailStartPost**
> EmailStartResponse emailStartAuthEmailStartPost(emailStartRequest)

Email Start

Send (or resend) a verification email containing both a 6-digit code and a magic link.  Calling this again acts as resend: any previous unused code is invalidated, subject to a 60s rate limit (returns 429 if called too soon).

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEmailAuthApi();
final EmailStartRequest emailStartRequest = ; // EmailStartRequest | 

try {
    final response = api.emailStartAuthEmailStartPost(emailStartRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmailAuthApi->emailStartAuthEmailStartPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailStartRequest** | [**EmailStartRequest**](EmailStartRequest.md)|  | 

### Return type

[**EmailStartResponse**](EmailStartResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **emailVerifyAuthEmailVerifyPost**
> AuthResponse emailVerifyAuthEmailVerifyPost(emailVerifyRequest)

Email Verify

Registration — verifies email code, creates user with optional phone, returns auth tokens.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEmailAuthApi();
final EmailVerifyRequest emailVerifyRequest = ; // EmailVerifyRequest | 

try {
    final response = api.emailVerifyAuthEmailVerifyPost(emailVerifyRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmailAuthApi->emailVerifyAuthEmailVerifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailVerifyRequest** | [**EmailVerifyRequest**](EmailVerifyRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **emailVerifyLinkAuthEmailVerifyLinkGet**
> JsonObject emailVerifyLinkAuthEmailVerifyLinkGet(token, phone)

Email Verify Link

Magic-link verification — runs in the browser, redirects back into the app via deep link.  Handles both registration and login: a new email creates an account, an existing one logs in.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getEmailAuthApi();
final String token = token_example; // String | 
final String phone = phone_example; // String | 

try {
    final response = api.emailVerifyLinkAuthEmailVerifyLinkGet(token, phone);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EmailAuthApi->emailVerifyLinkAuthEmailVerifyLinkGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 
 **phone** | **String**|  | [optional] 

### Return type

[**JsonObject**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

