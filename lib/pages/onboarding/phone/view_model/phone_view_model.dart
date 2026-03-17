// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/phone/view_model/phone_state.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class PhoneViewModel extends ValueNotifier<PhoneState> {
  final phoneController = TextEditingController();

  PhoneViewModel() : super(const PhoneState()) {
    phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    value = value.copyWith(
      isValid: phoneController.text.trim().length >= 7,
      clearError: true,
    );
  }

  Future<void> onContinue(BuildContext context) async {
    final phone = phoneController.text.trim();
    value = value.copyWith(isLoading: true, clearError: true);
    try {
      final response = await TrustworkApiService.instance.phoneAuth
          .phoneCheckAuthPhoneCheckGet(phone: phone);
      final isRegistered = response.data?.registered ?? false;
      OnboardingFlowCoordinator.instance
        ..phoneNumber = phone
        ..isRegistered = isRegistered;
      value = value.copyWith(isLoading: false);
      if (context.mounted) {
        context.push(
          isRegistered ? '/onboarding/account-exists' : '/onboarding/email-new',
        );
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

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }
}
