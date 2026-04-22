# api_client.api.TokenApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getMatrixPasswordMeMatrixPasswordGet**](TokenApi.md#getmatrixpasswordmematrixpasswordget) | **GET** /me/matrix-password | Get Matrix Password
[**getMeMeGet**](TokenApi.md#getmemeget) | **GET** /me | Get Me
[**refreshTokenAuthRefreshPost**](TokenApi.md#refreshtokenauthrefreshpost) | **POST** /auth/refresh | Refresh Token


# **getMatrixPasswordMeMatrixPasswordGet**
> MatrixPasswordResponse getMatrixPasswordMeMatrixPasswordGet()

Get Matrix Password

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getTokenApi();

try {
    final response = api.getMatrixPasswordMeMatrixPasswordGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling TokenApi->getMatrixPasswordMeMatrixPasswordGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MatrixPasswordResponse**](MatrixPasswordResponse.md)

### Authorization

[OAuth2PasswordBearer](../README.md#OAuth2PasswordBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMeMeGet**
> UserProfile getMeMeGet()

Get Me

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure OAuth2 access token for authorization: OAuth2PasswordBearer
//defaultApiClient.getAuthentication<OAuth>('OAuth2PasswordBearer').accessToken = 'YOUR_ACCESS_TOKEN';

final api = ApiClient().getTokenApi();

try {
    final response = api.getMeMeGet();
    print(response);
} on DioException catch (e) {
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
import 'package:api_client/api.dart';

final api = ApiClient().getTokenApi();
final RefreshRequest refreshRequest = ; // RefreshRequest | 

try {
    final response = api.refreshTokenAuthRefreshPost(refreshRequest);
    print(response);
} on DioException catch (e) {
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

