import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/phone/view_model/phone_state.dart';

class PhoneViewModel extends ValueNotifier<PhoneState> {
  final phoneController = TextEditingController();

  PhoneViewModel() : super(const PhoneState()) {
    phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    value = value.copyWith(
      isValid: phoneController.text.trim().length >= 7,
    );
  }

  void onContinue(BuildContext context) {
    OnboardingFlowCoordinator.instance.phoneNumber =
        phoneController.text.trim();
    context.push('/onboarding/phone-verify');
  }

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }
}
