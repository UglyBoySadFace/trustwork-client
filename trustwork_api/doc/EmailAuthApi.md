# openapi.api.EmailAuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**emailStartAuthEmailStartPost**](EmailAuthApi.md#emailstartauthemailstartpost) | **POST** /auth/email/start | Email Start
[**emailVerifyAuthEmailVerifyPost**](EmailAuthApi.md#emailverifyauthemailverifypost) | **POST** /auth/email/verify | Email Verify


# **emailStartAuthEmailStartPost**
> EmailStartResponse emailStartAuthEmailStartPost(emailStartRequest)

Email Start

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = EmailAuthApi();
final emailStartRequest = EmailStartRequest(); // EmailStartRequest | 

try {
    final result = api_instance.emailStartAuthEmailStartPost(emailStartRequest);
    print(result);
} catch (e) {
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

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = EmailAuthApi();
final emailVerifyRequest = EmailVerifyRequest(); // EmailVerifyRequest | 

try {
    final result = api_instance.emailVerifyAuthEmailVerifyPost(emailVerifyRequest);
    print(result);
} catch (e) {
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

