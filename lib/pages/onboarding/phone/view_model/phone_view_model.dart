import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/phone/view_model/phone_state.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class PhoneViewModel extends ValueNotifier<PhoneState> {
  final phoneController = TextEditingController();

  PhoneViewModel() : super(const PhoneState()) {
    phoneController.addListener(_onPhoneChanged);
  }

  // Strips formatting and normalises to E.164.
  // Accepts: +420123456789, +420 123 456 789, 00420123456789
  // Returns null when the result is not a plausible E.164 number.
  static String? _toE164(String raw) {
    var digits = raw.replaceAll(RegExp(r'[\s\-().]+'), '');
    if (digits.startsWith('00')) digits = '+${digits.substring(2)}';
    // E.164: + followed by 7–15 digits
    if (!RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(digits)) return null;
    return digits;
  }

  void _onPhoneChanged() {
    final e164 = _toE164(phoneController.text);
    value = value.copyWith(isValid: e164 != null, clearError: true);
  }

  Future<void> onContinue(BuildContext context) async {
    final e164 = _toE164(phoneController.text);
    if (e164 == null) {
      value = value.copyWith(
        error: 'Enter your number in international format, e.g. +420123456789',
      );
      return;
    }
    value = value.copyWith(isLoading: true, clearError: true);
    final phone = e164;
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
