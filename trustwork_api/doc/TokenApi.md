# openapi.api.TokenApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMeMeGet**](TokenApi.md#getmemeget) | **GET** /me | Get Me
[**refreshTokenAuthRefreshPost**](TokenApi.md#refreshtokenauthrefreshpost) | **POST** /auth/refresh | Refresh Token


# **getMeMeGet**
> UserProfile getMeMeGet()

Get Me

### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api_instance = TokenApi();

try {
    final result = api_instance.getMeMeGet();
    print(result);
} catch (e) {
    print('Exception when calling TokenApi->getMeMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshTokenAuthRefreshPost**
> TokenResponse refreshTokenAuthRefreshPost(refreshRequest)

Refresh Token

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = TokenApi();
final refreshRequest = RefreshRequest(); // RefreshRequest | 

try {
    final result = api_instance.refreshTokenAuthRefreshPost(refreshRequest);
    print(result);
} catch (e) {
    print('Exception when calling TokenApi->refreshTokenAuthRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | 

### Return type

[**TokenResponse**](TokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

