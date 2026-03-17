// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:api_client/api_client.dart';
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
      final response = await TrustworkApiService.instance.emailAuth
          .emailVerifyAuthEmailVerifyPost(
        emailVerifyRequest: EmailVerifyRequest(
          (b) => b
            ..email = email
            ..code = code
            ..phone = phone,
        ),
      );
      final authResponse = response.data!;
      coordinator.authResponse = authResponse;
      await TrustworkApiService.instance.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
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
