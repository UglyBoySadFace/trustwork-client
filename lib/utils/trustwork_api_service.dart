// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Project imports:
import 'package:fluffychat/config/app_config.dart';

class TrustworkApiService {
  static const _keyAccessToken = 'tw_access_token';
  static const _keyRefreshToken = 'tw_refresh_token';

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
    ]);
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
