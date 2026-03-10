import 'package:flutter/material.dart';

import 'package:fluffychat/pages/onboarding/email_reactivate/view_model/email_reactivate_view_model.dart';
import 'package:fluffychat/pages/onboarding/shared/otp_input.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class EmailReactivatePage extends StatelessWidget {
  const EmailReactivatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder(
      create: EmailReactivateViewModel.new,
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
                  'We sent a code to',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'placeholder@email.com',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OtpInput(
                  onCompleted: (code) => viewModel.onCodeChanged(code),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
