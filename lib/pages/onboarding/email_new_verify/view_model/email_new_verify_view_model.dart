// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/shared/otp_view_model.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class EmailNewVerifyViewModel extends OtpViewModel {
  @override
  Future<void> onVerify(BuildContext context, String code) async {
    final coordinator = OnboardingFlowCoordinator.instance;
    final email = coordinator.newEmail ?? '';
    final phone = coordinator.phoneNumber;
    value = value.copyWith(isLoading: true, clearError: true);
    try {
      final (:authResponse, :loginToken, :deviceId) =
          await TrustworkApiService.instance.emailVerify(
        email: email,
        code: code,
        phone: phone,
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
      final String error;
      if (e.response?.statusCode == 409) {
        error =
            'This phone number is already registered. Please go back and sign in instead.';
      } else {
        error = TrustworkApiService.friendlyError(e);
      }
      value = value.copyWith(isLoading: false, error: error);
    } catch (_) {
      value = value.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }
}
