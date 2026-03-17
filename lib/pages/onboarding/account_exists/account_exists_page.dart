// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';

class AccountExistsPage extends StatelessWidget {
  const AccountExistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phoneNumber =
        OnboardingFlowCoordinator.instance.phoneNumber ?? '';
    return LoginScaffold(
      appBar: AppBar(title: const Text('Account Found')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Account already exists',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'A Trustwork account is associated with $phoneNumber. Would you like to reactivate it?',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    context.push('/onboarding/email-reactivate'),
                child: const Text('Yes, reactivate'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/onboarding/email-new'),
                child: const Text('No, set up a new Trustwork account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
