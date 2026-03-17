# api_client.api.PhoneAuthApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**phoneCheckAuthPhoneCheckGet**](PhoneAuthApi.md#phonecheckauthphonecheckget) | **GET** /auth/phone/check | Phone Check


# **phoneCheckAuthPhoneCheckGet**
> PhoneCheckResponse phoneCheckAuthPhoneCheckGet(phone)

Phone Check

Check whether a phone number is already registered.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPhoneAuthApi();
final String phone = phone_example; // String | 

try {
    final response = api.phoneCheckAuthPhoneCheckGet(phone);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PhoneAuthApi->phoneCheckAuthPhoneCheckGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **phone** | **String**|  | 

### Return type

[**PhoneCheckResponse**](PhoneCheckResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

