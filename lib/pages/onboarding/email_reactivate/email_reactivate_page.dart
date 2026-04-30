import 'package:flutter/material.dart';

import 'package:fluffychat/pages/onboarding/email_reactivate/view_model/email_reactivate_view_model.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Enter your email address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter the email linked to your Trustwork account. We'll send you a verification code.",
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: viewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'your@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                    errorText: state.error,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.isValid && !state.isLoading
                        ? () => viewModel.onContinue(context)
                        : null,
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
