# openapi.api.PhoneAuthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**phoneStartAuthPhoneStartPost**](PhoneAuthApi.md#phonestartauthphonestartpost) | **POST** /auth/phone/start | Phone Start
[**phoneVerifyAuthPhoneVerifyPost**](PhoneAuthApi.md#phoneverifyauthphoneverifypost) | **POST** /auth/phone/verify | Phone Verify


# **phoneStartAuthPhoneStartPost**
> PhoneStartResponse phoneStartAuthPhoneStartPost(phoneStartRequest)

Phone Start

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhoneAuthApi();
final phoneStartRequest = PhoneStartRequest(); // PhoneStartRequest | 

try {
    final result = api_instance.phoneStartAuthPhoneStartPost(phoneStartRequest);
    print(result);
} catch (e) {
    print('Exception when calling PhoneAuthApi->phoneStartAuthPhoneStartPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **phoneStartRequest** | [**PhoneStartRequest**](PhoneStartRequest.md)|  | 

### Return type

[**PhoneStartResponse**](PhoneStartResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **phoneVerifyAuthPhoneVerifyPost**
> AuthResponse phoneVerifyAuthPhoneVerifyPost(phoneVerifyRequest)

Phone Verify

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhoneAuthApi();
final phoneVerifyRequest = PhoneVerifyRequest(); // PhoneVerifyRequest | 

try {
    final result = api_instance.phoneVerifyAuthPhoneVerifyPost(phoneVerifyRequest);
    print(result);
} catch (e) {
    print('Exception when calling PhoneAuthApi->phoneVerifyAuthPhoneVerifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **phoneVerifyRequest** | [**PhoneVerifyRequest**](PhoneVerifyRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

