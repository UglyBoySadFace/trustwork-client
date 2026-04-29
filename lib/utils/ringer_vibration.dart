import 'package:flutter/services.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/platform_infos.dart';

/// Drives a continuous ringtone-class vibration via a native method channel.
/// Used alongside flutter_callkit_incoming because that package's repeating
/// vibration is unattributed and gets throttled by several OEMs (Samsung,
/// Xiaomi, OnePlus) under DND-allow-calls and vibrate-only ringer modes.
class RingerVibration {
  static const _channel = MethodChannel(
    'chat.fluffy.fluffychat/ringer_vibration',
  );

  static Future<void> start() async {
    if (!PlatformInfos.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('start');
    } catch (e, s) {
      Logs().w('RingerVibration.start failed', e, s);
    }
  }

  static Future<void> stop() async {
    if (!PlatformInfos.isAndroid) return;
    try {
      await _channel.invokeMethod<void>('stop');
    } catch (e, s) {
      Logs().w('RingerVibration.stop failed', e, s);
    }
  }
}
