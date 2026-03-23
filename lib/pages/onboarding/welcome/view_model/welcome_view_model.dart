// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

// Project imports:
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WelcomeState {
  final bool isLoading;
  final String? error;

  const WelcomeState({this.isLoading = false, this.error});

  WelcomeState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) => WelcomeState(
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}

class WelcomeViewModel extends ValueNotifier<WelcomeState> {
  WelcomeViewModel() : super(const WelcomeState());

  Future<void> onContinue(BuildContext context) async {
    final coordinator = OnboardingFlowCoordinator.instance;
    final existingMatrix = coordinator.authResponse?.matrix;

    // Login flow: user already has matrix credentials from email verify
    final existingLoginToken = coordinator.matrixLoginToken;
    final existingDeviceId = coordinator.matrixDeviceId;
    if (existingMatrix != null &&
        existingLoginToken != null &&
        existingDeviceId != null) {
      value = value.copyWith(isLoading: true, clearError: true);
      try {
        await _loginToMatrix(
          context,
          userId: existingMatrix.matrixUserId,
          accessToken: existingLoginToken,
          deviceId: existingDeviceId,
        );
      } catch (e) {
        value = value.copyWith(isLoading: false, error: e.toString());
      }
      return;
    }

    // Registration flow: start Bank iD verification
    value = value.copyWith(isLoading: true, clearError: true);
    try {
      final (:authorizationUrl, state: _) =
          await TrustworkApiService.instance.bankIdStart();

      // Open Bank iD — backend will redirect to trustwork://auth-success?...
      final result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl,
        callbackUrlScheme: AppConfig.trustworkScheme,
        options: FlutterWebAuth2Options(useWebview: PlatformInfos.isMobile),
      );

      final params = Uri.parse(result).queryParameters;
      debugPrint('[TW] Bank iD callback params: $params');

      final callbackError = params['error'];
      if (callbackError != null) {
        final description =
            params['error_description'] ?? callbackError;
        throw Exception(description);
      }

      final accessToken = params['access_token'];
      final refreshToken = params['refresh_token'];
      final matrixUserId = params['matrix_user_id'];
      final matrixAccessToken = params['login_token'];
      final matrixDeviceId = params['matrix_device_id'];

      if (accessToken == null || refreshToken == null) {
        throw Exception('Incomplete tokens in Bank iD callback.');
      }

      await TrustworkApiService.instance.saveTokens(accessToken, refreshToken);

      if (matrixUserId == null ||
          matrixAccessToken == null ||
          matrixDeviceId == null) {
        throw Exception(
          'Bank iD callback missing Matrix credentials. '
          'Backend must include: matrix_user_id, login_token, matrix_device_id.',
        );
      }

      value = value.copyWith(isLoading: false);
      if (context.mounted) {
        await _loginToMatrix(
          context,
          userId: matrixUserId,
          accessToken: matrixAccessToken,
          deviceId: matrixDeviceId,
        );
      }
    } on DioException catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: TrustworkApiService.friendlyError(e),
      );
    } catch (e) {
      value = value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _loginToMatrix(
    BuildContext context, {
    required String userId,
    required String accessToken,
    required String deviceId,
  }) async {
    final loginClient = await Matrix.of(context).getLoginClient();
    await loginClient.init(
      newToken: accessToken,
      newUserID: userId,
      newDeviceID: deviceId,
      newHomeserver: Uri.parse(AppConfig.matrixHomeserver),
      waitForFirstSync: false,
    );
    // getLoginClient() listener navigates to /backup on LoginState.loggedIn
    OnboardingFlowCoordinator.instance.reset();
  }
}
