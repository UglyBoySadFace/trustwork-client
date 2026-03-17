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

