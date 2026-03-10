//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AuthApi {
  AuthApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Bankid Callback
  ///
  /// Bank iD OAuth2 callback endpoint.  Bank iD redirects here after user authentication with code and state, or with error parameters if authentication failed.  For now, this just extracts the user identity and returns it. Later, this will create/update Matrix accounts and return credentials.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] code:
  ///   Authorization code from Bank iD
  ///
  /// * [String] state:
  ///   State token for CSRF protection
  ///
  /// * [String] error:
  ///   Error code from Bank iD
  ///
  /// * [String] errorDescription:
  ///   Error description from Bank iD
  Future<Response> bankidCallbackAuthBankidCallbackGetWithHttpInfo({ String? code, String? state, String? error, String? errorDescription, }) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/bankid/callback';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (code != null) {
      queryParams.addAll(_queryParams('', 'code', code));
    }
    if (state != null) {
      queryParams.addAll(_queryParams('', 'state', state));
    }
    if (error != null) {
      queryParams.addAll(_queryParams('', 'error', error));
    }
    if (errorDescription != null) {
      queryParams.addAll(_queryParams('', 'error_description', errorDescription));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Bankid Callback
  ///
  /// Bank iD OAuth2 callback endpoint.  Bank iD redirects here after user authentication with code and state, or with error parameters if authentication failed.  For now, this just extracts the user identity and returns it. Later, this will create/update Matrix accounts and return credentials.
  ///
  /// Parameters:
  ///
  /// * [String] code:
  ///   Authorization code from Bank iD
  ///
  /// * [String] state:
  ///   State token for CSRF protection
  ///
  /// * [String] error:
  ///   Error code from Bank iD
  ///
  /// * [String] errorDescription:
  ///   Error description from Bank iD
  Future<Object?> bankidCallbackAuthBankidCallbackGet({ String? code, String? state, String? error, String? errorDescription, }) async {
    final response = await bankidCallbackAuthBankidCallbackGetWithHttpInfo( code: code, state: state, error: error, errorDescription: errorDescription, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Bankid Start
  ///
  /// Start Bank iD OAuth2 flow.  Returns a redirect URL that the client should open in a browser/webview.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> bankidStartAuthBankidStartGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/bankid/start';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Bankid Start
  ///
  /// Start Bank iD OAuth2 flow.  Returns a redirect URL that the client should open in a browser/webview.
  Future<Object?> bankidStartAuthBankidStartGet() async {
    final response = await bankidStartAuthBankidStartGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Bankid Test
  ///
  /// Test endpoint: triggers the full Bank iD flow and redirects to authorization URL.  This is for quick browser-based testing. Open http://localhost:8000/auth/bankid/test in your browser to start the flow.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> bankidTestAuthBankidTestGetWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/bankid/test';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Bankid Test
  ///
  /// Test endpoint: triggers the full Bank iD flow and redirects to authorization URL.  This is for quick browser-based testing. Open http://localhost:8000/auth/bankid/test in your browser to start the flow.
  Future<Object?> bankidTestAuthBankidTestGet() async {
    final response = await bankidTestAuthBankidTestGetWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }
}
