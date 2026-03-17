# api_client.api.HealthApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthCheckHealthGet**](HealthApi.md#healthcheckhealthget) | **GET** /health | Health Check


# **healthCheckHealthGet**
> BuiltMap<String, JsonObject> healthCheckHealthGet()

Health Check

Basic health check — verifies the app is running and DB is reachable.

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHealthApi();

try {
    final response = api.healthCheckHealthGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling HealthApi->healthCheckHealthGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

