// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:matrix/matrix.dart';

const _channel = MethodChannel('chat.fluffy.fluffychat/permissions');

/// Returns true if the app can use full-screen intents (needed for incoming
/// call UI on lock screen). Always true on non-Android or below Android 14.
Future<bool> canUseFullScreenIntent() async {
  if (!Platform.isAndroid) return true;
  try {
    final info = await DeviceInfoPlugin().androidInfo;
    if (info.version.sdkInt < 34) return true;
    return await _channel.invokeMethod<bool>('canUseFullScreenIntent') ?? true;
  } catch (e) {
    Logs().e('[FSI] canUseFullScreenIntent check failed: $e');
    return true;
  }
}

Future<void> _openFullScreenIntentSettings() async {
  try {
    await _channel.invokeMethod<void>('openFullScreenIntentSettings');
  } catch (e) {
    Logs().e('[FSI] openFullScreenIntentSettings failed: $e');
  }
}

/// Checks the full-screen intent permission and shows a dialog prompting the
/// user to grant it if missing (Android 14+ only).
Future<void> checkAndPromptFullScreenIntent(BuildContext context) async {
  if (!Platform.isAndroid) return;
  if (await canUseFullScreenIntent()) return;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Incoming call permission'),
      content: const Text(
        'To show incoming calls on the lock screen, please grant the '
        '"Display over full screen" special permission.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Later'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            await _openFullScreenIntentSettings();
          },
          child: const Text('Grant permission'),
        ),
      ],
    ),
  );
}
