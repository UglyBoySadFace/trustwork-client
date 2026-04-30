import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/shared/otp_view_model.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class EmailReactivateVerifyViewModel extends OtpViewModel {
  @override
  Future<void> onVerify(BuildContext context, String code) async {
    final coordinator = OnboardingFlowCoordinator.instance;
    final email = coordinator.newEmail ?? '';
    value = value.copyWith(isLoading: true, clearError: true);
    try {
      final (:authResponse, :loginToken, :deviceId) =
          await TrustworkApiService.instance.emailLogin(
        email: email,
        code: code,
      );
      coordinator.authResponse = authResponse;
      coordinator.matrixLoginToken = loginToken;
      coordinator.matrixDeviceId = deviceId;
      await TrustworkApiService.instance.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      final matrixPassword = authResponse.matrix?.matrixPassword;
      if (matrixPassword != null) {
        await TrustworkApiService.instance.saveMatrixPassword(matrixPassword);
      }
      value = value.copyWith(isLoading: false);
      if (context.mounted) {
        context.go('/onboarding/welcome');
      }
    } on DioException catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: TrustworkApiService.friendlyError(e),
      );
    } catch (_) {
      value = value.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }
}
