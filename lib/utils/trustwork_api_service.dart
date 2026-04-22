// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:api_client/api_client.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Project imports:
import 'package:fluffychat/config/app_config.dart';

class TrustworkApiService {
  static const _keyAccessToken = 'tw_access_token';
  static const _keyRefreshToken = 'tw_refresh_token';
  static const _keyMatrixPassword = 'tw_matrix_password';

  static final instance = TrustworkApiService._();
  TrustworkApiService._();

  final _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.trustworkApiBaseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ),
  )..interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint('[TW-API] $o'),
      ),
    );

  late final _apiClient = ApiClient(dio: _dio);
  final _storage = const FlutterSecureStorage();

  PhoneAuthApi get phoneAuth => _apiClient.getPhoneAuthApi();
  EmailAuthApi get emailAuth => _apiClient.getEmailAuthApi();
  TokenApi get token => _apiClient.getTokenApi();

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyMatrixPassword),
    ]);
  }

  Future<void> saveMatrixPassword(String password) =>
      _storage.write(key: _keyMatrixPassword, value: password);

  Future<String?> getMatrixPassword() async {
    final stored = await _storage.read(key: _keyMatrixPassword);
    if (stored != null) return stored;
    return _fetchAndCacheMatrixPassword();
  }

  Future<String?> _fetchAndCacheMatrixPassword() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) return null;
      final response = await _dio.get<Map<String, dynamic>>(
        '/me/matrix-password',
        options: Options(
          headers: <String, String>{'Authorization': 'Bearer $accessToken'},
        ),
      );
      final password = response.data?['matrix_password'] as String?;
      if (password != null) await saveMatrixPassword(password);
      return password;
    } catch (_) {
      return null;
    }
  }

  AuthApi get auth => _apiClient.getAuthApi();

  /// Calls POST /auth/email/verify. Extracts the AuthResponse plus the Matrix
  /// access token (login_token) and device ID (matrix_device_id).
  Future<({AuthResponse authResponse, String? loginToken, String? deviceId})>
  emailVerify({
    required String email,
    required String code,
    String? phone,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/email/verify',
      data: <String, dynamic>{
        'email': email,
        'code': code,
        if (phone != null) 'phone': phone,
      },
    );
    final data = response.data!;
    final authResponse = standardSerializers.deserialize(
      data,
      specifiedType: const FullType(AuthResponse),
    ) as AuthResponse;
    final loginToken = data['login_token'] as String?;
    final deviceId = data['matrix_device_id'] as String?;
    return (authResponse: authResponse, loginToken: loginToken, deviceId: deviceId);
  }

  /// Calls POST /auth/email/login. Extracts the AuthResponse plus the Matrix
  /// access token (login_token) and device ID (matrix_device_id).
  Future<({AuthResponse authResponse, String? loginToken, String? deviceId})>
  emailLogin({
    required String email,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/email/login',
      data: <String, dynamic>{'email': email, 'code': code},
    );
    final data = response.data!;
    final authResponse = standardSerializers.deserialize(
      data,
      specifiedType: const FullType(AuthResponse),
    ) as AuthResponse;
    final loginToken = data['login_token'] as String?;
    final deviceId = data['matrix_device_id'] as String?;
    return (authResponse: authResponse, loginToken: loginToken, deviceId: deviceId);
  }

  /// Calls GET /auth/bankid/start with the stored access token.
  /// Returns the authorization_url to open in the browser.
  Future<({String authorizationUrl, String state})> bankIdStart() async {
    final accessToken = await getAccessToken();
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/bankid/start',
      options: Options(
        headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      ),
    );
    final data = response.data!;
    return (
      authorizationUrl: data['authorization_url'] as String,
      state: data['state'] as String,
    );
  }

  /// Calls GET /auth/bankid/callback?code=...&state=... and returns AuthResponse.
  Future<AuthResponse> bankIdCallback({
    required String code,
    required String state,
  }) async {
    final response = await _dio.get<Object>(
      '/auth/bankid/callback',
      queryParameters: <String, String>{'code': code, 'state': state},
    );
    return standardSerializers.deserialize(
          response.data,
          specifiedType: const FullType(AuthResponse),
        ) as AuthResponse;
  }

  /// Extracts a user-friendly message from a DioException and logs the full
  /// details so the complete response body is visible in Logcat.
  static String friendlyError(DioException e) {
    debugPrint('[TW-API] ERROR ${e.response?.statusCode}: ${e.message}');
    debugPrint('[TW-API] Response body: ${e.response?.data}');
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map) return first['msg']?.toString() ?? e.message ?? 'Error';
      }
    }
    return e.message ?? 'Something went wrong. Please try again.';
  }
}
