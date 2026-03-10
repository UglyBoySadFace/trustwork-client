//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PhoneAuthApi {
  PhoneAuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Phone Start
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PhoneStartRequest] phoneStartRequest (required):
  Future<Response> phoneStartAuthPhoneStartPostWithHttpInfo(PhoneStartRequest phoneStartRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/phone/start';

    // ignore: prefer_final_locals
    Object? postBody = phoneStartRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Phone Start
  ///
  /// Parameters:
  ///
  /// * [PhoneStartRequest] phoneStartRequest (required):
  Future<PhoneStartResponse?> phoneStartAuthPhoneStartPost(PhoneStartRequest phoneStartRequest,) async {
    final response = await phoneStartAuthPhoneStartPostWithHttpInfo(phoneStartRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PhoneStartResponse',) as PhoneStartResponse;
    
    }
    return null;
  }

  /// Phone Verify
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PhoneVerifyRequest] phoneVerifyRequest (required):
  Future<Response> phoneVerifyAuthPhoneVerifyPostWithHttpInfo(PhoneVerifyRequest phoneVerifyRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/phone/verify';

    // ignore: prefer_final_locals
    Object? postBody = phoneVerifyRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Phone Verify
  ///
  /// Parameters:
  ///
  /// * [PhoneVerifyRequest] phoneVerifyRequest (required):
  Future<AuthResponse?> phoneVerifyAuthPhoneVerifyPost(PhoneVerifyRequest phoneVerifyRequest,) async {
    final response = await phoneVerifyAuthPhoneVerifyPostWithHttpInfo(phoneVerifyRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthResponse',) as AuthResponse;
    
    }
    return null;
  }
}
