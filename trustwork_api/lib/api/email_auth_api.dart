//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EmailAuthApi {
  EmailAuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Email Start
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmailStartRequest] emailStartRequest (required):
  Future<Response> emailStartAuthEmailStartPostWithHttpInfo(EmailStartRequest emailStartRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/email/start';

    // ignore: prefer_final_locals
    Object? postBody = emailStartRequest;

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

  /// Email Start
  ///
  /// Parameters:
  ///
  /// * [EmailStartRequest] emailStartRequest (required):
  Future<EmailStartResponse?> emailStartAuthEmailStartPost(EmailStartRequest emailStartRequest,) async {
    final response = await emailStartAuthEmailStartPostWithHttpInfo(emailStartRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmailStartResponse',) as EmailStartResponse;
    
    }
    return null;
  }

  /// Email Verify
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmailVerifyRequest] emailVerifyRequest (required):
  Future<Response> emailVerifyAuthEmailVerifyPostWithHttpInfo(EmailVerifyRequest emailVerifyRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/email/verify';

    // ignore: prefer_final_locals
    Object? postBody = emailVerifyRequest;

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

  /// Email Verify
  ///
  /// Parameters:
  ///
  /// * [EmailVerifyRequest] emailVerifyRequest (required):
  Future<AuthResponse?> emailVerifyAuthEmailVerifyPost(EmailVerifyRequest emailVerifyRequest,) async {
    final response = await emailVerifyAuthEmailVerifyPostWithHttpInfo(emailVerifyRequest,);
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
