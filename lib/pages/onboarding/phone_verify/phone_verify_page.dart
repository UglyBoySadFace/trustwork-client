// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/phone_verify/view_model/phone_verify_view_model.dart';
import 'package:fluffychat/pages/onboarding/shared/otp_input.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class PhoneVerifyPage extends StatelessWidget {
  const PhoneVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneNumber =
        OnboardingFlowCoordinator.instance.phoneNumber ?? '';
    return ViewModelBuilder(
      create: PhoneVerifyViewModel.new,
      builder: (context, viewModel, _) {
        final state = viewModel.value;
        return LoginScaffold(
          appBar: AppBar(title: const Text('Verify Phone')),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Enter the code sent to',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  phoneNumber,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OtpInput(
                  onCompleted: (code) {
                    viewModel.onCodeChanged(code);
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.code.length == 6
                        ? () => viewModel.onVerify(context, state.code)
                        : null,
                    child: const Text('Verify'),
                  ),
                ),
                const SizedBox(height: 16),
                state.resendCooldown > 0
                    ? Text(
                        'Resend code in ${state.resendCooldown}s',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : TextButton(
                        onPressed: viewModel.onResend,
                        child: const Text('Resend code'),
                      ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.go('/onboarding/welcome'),
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
