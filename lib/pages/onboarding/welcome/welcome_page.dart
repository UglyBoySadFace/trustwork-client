// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<void> _onContinue(BuildContext context) async {
    final coordinator = OnboardingFlowCoordinator.instance;
    final matrix = coordinator.authResponse?.matrix;

    if (matrix != null) {
      final loginClient = await Matrix.of(context).getLoginClient();
      await loginClient.init(
        newToken: matrix.matrixAccessToken,
        newUserID: matrix.matrixUserId,
        newHomeserver: Uri.parse(AppConfig.matrixHomeserver),
        waitForFirstSync: false,
      );
      // Navigation is handled automatically by the onLoginStateChanged
      // listener set up inside getLoginClient() → routes to /backup
    } else {
      coordinator.reset();
      if (context.mounted) context.go('/rooms');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => _onContinue(context),
                child: const Text('Yes, trust is worth it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
