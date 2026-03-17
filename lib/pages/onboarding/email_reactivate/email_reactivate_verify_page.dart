// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/email_reactivate/view_model/email_reactivate_verify_view_model.dart';
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/pages/onboarding/shared/otp_input.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class EmailReactivateVerifyPage extends StatelessWidget {
  const EmailReactivateVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = OnboardingFlowCoordinator.instance.newEmail ?? '';
    return ViewModelBuilder(
      create: EmailReactivateVerifyViewModel.new,
      builder: (context, viewModel, _) {
        final state = viewModel.value;
        return LoginScaffold(
          appBar: AppBar(title: const Text('Reactivate Account')),
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
                  email,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OtpInput(
                  onCompleted: (code) => viewModel.onCodeChanged(code),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.code.length == 6 && !state.isLoading
                        ? () => viewModel.onVerify(context, state.code)
                        : null,
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verify'),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
