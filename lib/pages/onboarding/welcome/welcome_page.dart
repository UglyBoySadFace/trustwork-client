import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {\
    final theme = Theme.of(context);
    return LoginScaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Trustwork',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Trustwork uses third-party solutions — including CZ Bank ID — to verify your identity in your country. That\'s not free, and therefore we must ask you for a small yearly fee of XX currency.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  OnboardingFlowCoordinator.instance.reset();
                  context.go('/rooms');
                },
                child: const Text('Yes, trust is worth it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
