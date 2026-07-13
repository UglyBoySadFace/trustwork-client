import 'dart:async';

import 'package:just_audio/just_audio.dart';

class UserMediaManager {
  factory UserMediaManager() {
    return _instance;
  }

  UserMediaManager._internal();

  static final UserMediaManager _instance = UserMediaManager._internal();

  AudioPlayer? _assetsAudioPlayer;

  Future<void> startRingingTone() async {
    const path = 'assets/sounds/phone.ogg';
    final player = _assetsAudioPlayer = AudioPlayer();
    // stopRingingTone may run while we're awaiting below. It nulls the
    // field, so re-check after each await — otherwise we'd start a looping
    // ringtone nothing owns.
    await player.setAsset(path);
    if (!identical(_assetsAudioPlayer, player)) {
      await player.dispose();
      return;
    }
    await player.setLoopMode(LoopMode.one);
    if (!identical(_assetsAudioPlayer, player)) {
      await player.dispose();
      return;
    }
    unawaited(player.play());
  }

  Future<void> stopRingingTone() async {
    final player = _assetsAudioPlayer;
    _assetsAudioPlayer = null;
    if (player != null) {
      await player.stop();
      unawaited(player.dispose());
    }
  }
}
