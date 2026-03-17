// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class EmailReactivateState {
  final bool isValid;
  final bool isLoading;
  final String? error;

  const EmailReactivateState({
    this.isValid = false,
    this.isLoading = false,
    this.error,
  });

  EmailReactivateState copyWith({
    bool? isValid,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) => EmailReactivateState(
    isValid: isValid ?? this.isValid,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}

class EmailReactivateViewModel extends ValueNotifier<EmailReactivateState> {
  final emailController = TextEditingController();

  EmailReactivateViewModel() : super(const EmailReactivateState()) {
    emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    value = value.copyWith(
      isValid: emailController.text.trim().contains('@'),
      clearError: true,
    );
  }

  Future<void> onContinue(BuildContext context) async {
    final email = emailController.text.trim();
    value = value.copyWith(isLoading: true, clearError: true);
    try {
      await TrustworkApiService.instance.emailAuth.emailStartAuthEmailStartPost(
        emailStartRequest: EmailStartRequest((b) => b..email = email),
      );
      OnboardingFlowCoordinator.instance.newEmail = email;
      value = value.copyWith(isLoading: false);
      if (context.mounted) {
        context.push('/onboarding/email-reactivate/verify');
      }
    } on DioException catch (e) {
      value = value.copyWith(
        isLoading: false,
        error: TrustworkApiService.friendlyError(e),
      );
    } catch (_) {
      value = value.copyWith(
        isLoading: false,
        error: 'Failed to send code. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    emailController.removeListener(_onEmailChanged);
    emailController.dispose();
    super.dispose();
  }
}
