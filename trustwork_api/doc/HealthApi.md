# openapi.api.HealthApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthCheckHealthGet**](HealthApi.md#healthcheckhealthget) | **GET** /health | Health Check


# **healthCheckHealthGet**
> Map<String, Object> healthCheckHealthGet()

Health Check

Basic health check — verifies the app is running and DB is reachable.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = HealthApi();

try {
    final result = api_instance.healthCheckHealthGet();
    print(result);
} catch (e) {
    print('Exception when calling HealthApi->healthCheckHealthGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Map<String, Object>**](Object.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

