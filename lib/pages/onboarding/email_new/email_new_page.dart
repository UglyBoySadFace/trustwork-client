import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';

class EmailNewPage extends StatefulWidget {
  const EmailNewPage({super.key});

  @override
  State<EmailNewPage> createState() => _EmailNewPageState();
}

class _EmailNewPageState extends State<EmailNewPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      appBar: AppBar(title: const Text('New Account Email')),
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
              "We'll send you a verification code to set up your new Trustwork account.",
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'your@email.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  if (email.isEmpty) return;
                  OnboardingFlowCoordinator.instance.newEmail = email;
                  context.push('/onboarding/email-new/verify');
                },
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
