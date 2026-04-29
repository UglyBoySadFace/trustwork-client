// Dart imports:
import 'dart:async';
import 'dart:core';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_callkit_incoming/entities/entities.dart' as fci;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart' as callkit;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

// Project imports:
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/dialer/dialer.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import '../../utils/voip/user_media_manager.dart';
import '../widgets/matrix.dart';

class VoipPlugin with WidgetsBindingObserver implements WebRTCDelegate {
  final MatrixState matrix;
  Client get client => matrix.client;

  String? _callkitAcceptedId;
  StreamSubscription<fci.CallEvent?>? _callkitSubscription;

  VoipPlugin(this.matrix) {
    voip = VoIP(client, this);
    if (!kIsWeb) {
      final wb = WidgetsBinding.instance;
      wb.addObserver(this);
      didChangeAppLifecycleState(wb.lifecycleState);
      if (PlatformInfos.isMobile) _initCallkit();
    }
  }

  void _initCallkit() {
    // Check if app was launched by the user accepting a call while it was killed.
    // EventChannel events are not buffered, so the actionCallAccept event fires
    // before our listener is registered. activeCalls() catches this case.
    _restoreCallkitAcceptedId();

    _callkitSubscription?.cancel();
    _callkitSubscription = callkit.FlutterCallkitIncoming.onEvent.listen((fci.CallEvent? event) {
      switch (event?.event) {
        case fci.Event.actionCallAccept:
          final callId = event?.body['id'] as String?;
          // If handleNewCall already ran and the call is waiting, answer it now.
          if (callId != null) {
            final existing = voip.calls.entries
                .where((e) => e.key.callId == callId)
                .firstOrNull
                ?.value;
            if (existing != null) {
              // Only add overlay if it isn't already showing (race condition guard).
              if (overlayEntry == null) {
                addCallingOverlay(callId, existing);
              }
              existing.answer();
              return;
            }
          }
          // Otherwise store the ID so handleNewCall can auto-answer when it fires.
          _callkitAcceptedId = callId;
          break;
        case fci.Event.actionCallDecline:
          final callId = event?.body['id'] as String?;
          _callkitAcceptedId = null;
          if (callId != null) {
            final existing = voip.calls.entries
                .where((e) => e.key.callId == callId)
                .firstOrNull
                ?.value;
            existing?.reject();
          }
          break;
        case fci.Event.actionCallTimeout:
        case fci.Event.actionCallEnded:
          _callkitAcceptedId = null;
          break;
        default:
          break;
      }
    });
  }

  bool background = false;
  bool speakerOn = false;
  late VoIP voip;
  OverlayEntry? overlayEntry;
  BuildContext get context => matrix.context;

  @override
  void didChangeAppLifecycleState(AppLifecycleState? state) {
    background =
        (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused);
  }

  Future<void> _restoreCallkitAcceptedId() async {
    try {
      final activeCalls = await callkit.FlutterCallkitIncoming.activeCalls();
      if (activeCalls is List) {
        for (final c in activeCalls) {
          if (c is Map) {
            final id = c['id'] as String?;
            // flutter_callkit_incoming v3 stores isAccepted:bool, not status:int.
            final isAccepted = c['isAccepted'] as bool? ?? false;
            if (id != null && isAccepted) {
              Logs().i('[VOIP] Restoring callkit accepted ID from activeCalls: $id');
              _callkitAcceptedId = id;
              break;
            }
          }
        }
      }
    } catch (e) {
      Logs().e('[VOIP] _restoreCallkitAcceptedId failed: $e');
    }

    // The initial background sync (run before VoIP is created) may have
    // already processed the m.call.invite event and advanced the sync token
    // past it. If so, the incremental sync will never re-deliver it and
    // handleNewCall would never fire. Replay the cached call events now so
    // VoIP can process any invite that was missed before it subscribed.
    if (_callkitAcceptedId != null) {
      final pending = client.onCallEvents.value;
      if (pending != null && pending.isNotEmpty) {
        Logs().i('[VOIP] Replaying ${pending.length} cached call event(s) for auto-answer');
        client.onCallEvents.add(pending);
      }
    }
  }

  void addCallingOverlay(String callId, CallSession call) {
    final context = ChatList.contextForVoip ?? this.context;

    if (overlayEntry != null) {
      Logs().e('[VOIP] addCallingOverlay: The call session already exists?');
      _removeOverlay();
    }
    // Overlay.of(context) is broken on web
    // falling back on a dialog
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (context) => Calling(
          context: context,
          client: client,
          callId: callId,
          call: call,
          onClear: () => Navigator.of(context).pop(),
        ),
      );
    } else {
      overlayEntry = OverlayEntry(
        builder: (_) => Calling(
          context: context,
          client: client,
          callId: callId,
          call: call,
          onClear: _removeOverlay,
        ),
      );
      Overlay.of(context).insert(overlayEntry!);
    }
  }

  void _removeOverlay() {
    final entry = overlayEntry;
    overlayEntry = null;
    entry?.remove();
  }

  @override
  MediaDevices get mediaDevices => webrtc_impl.navigator.mediaDevices;

  @override
  bool get isWeb => kIsWeb;

  @override
  Future<RTCPeerConnection> createPeerConnection(
    Map<String, dynamic> configuration, [
    Map<String, dynamic> constraints = const {},
  ]) => webrtc_impl.createPeerConnection(configuration, constraints);

  Future<bool> get hasCallingAccount async => false;

  @override
  Future<void> playRingtone() async {
    if (!background && !await hasCallingAccount) {
      try {
        await UserMediaManager().startRingingTone();
      } catch (_) {}
    }
  }

  @override
  Future<void> stopRingtone() async {
    if (!background && !await hasCallingAccount) {
      try {
        await UserMediaManager().stopRingingTone();
      } catch (_) {}
    }
  }

  @override
  Future<void> handleNewCall(CallSession call) async {
    // If the user already accepted from the callkit lock-screen UI, auto-answer.
    // The foreground service can be started here because the user has just
    // interacted with the callkit notification — Android treats that as an
    // eligible state for starting a microphone-type FGS.
    if (_callkitAcceptedId == call.callId) {
      _callkitAcceptedId = null;
      addCallingOverlay(call.callId, call);
      if (PlatformInfos.isAndroid) {
        unawaited(_startForegroundService());
      }
      await call.answer();
      return;
    }

    // Show the call screen immediately — don't wait for foreground service setup.
    // We deliberately do NOT start the foreground service here: on Android 14+
    // (targetSDK 34+) starting a microphone-type FGS while the call is still
    // ringing throws SecurityException and triggers a 5-second restart loop.
    // The service is started by the dialer when the user actually answers.
    addCallingOverlay(call.callId, call);
  }

  /// Called by the dialer when the user answers a call from the in-app overlay.
  /// Starts the microphone-type foreground service so mic capture survives
  /// the app going to background after accept.
  Future<void> onCallAnswered() async {
    if (PlatformInfos.isAndroid) {
      unawaited(_startForegroundService());
    }
  }

  Future<void> _startForegroundService() async {
    try {
      final wasForeground = await FlutterForegroundTask.isAppOnForeground;
      await matrix.store.setString(
        'wasForeground',
        wasForeground == true ? 'true' : 'false',
      );
      FlutterForegroundTask.setOnLockScreenVisibility(true);
      FlutterForegroundTask.wakeUpScreen();
      FlutterForegroundTask.launchApp();
      await FlutterForegroundTask.startService(
        notificationTitle: 'Call in progress',
        notificationText: 'Trustwork call active',
      );
    } catch (e) {
      Logs().e('VOIP foreground failed $e');
    }
  }

  @override
  Future<void> handleCallEnded(CallSession session) async {
    if (PlatformInfos.isMobile) {
      await callkit.FlutterCallkitIncoming.endCall(session.callId);
    }
    if (overlayEntry != null) {
      _removeOverlay();
      if (PlatformInfos.isAndroid) {
        FlutterForegroundTask.setOnLockScreenVisibility(false);
        FlutterForegroundTask.stopService();
        final wasForeground = matrix.store.getString('wasForeground');
        if (wasForeground == 'false') FlutterForegroundTask.minimizeApp();
      }
    }
  }

  @override
  Future<void> handleGroupCallEnded(GroupCallSession groupCall) async {
    // TODO: implement handleGroupCallEnded
  }

  @override
  Future<void> handleNewGroupCall(GroupCallSession groupCall) async {
    // TODO: implement handleNewGroupCall
  }

  @override
  // TODO: implement canHandleNewCall
  bool get canHandleNewCall =>
      voip.currentCID == null && voip.currentGroupCID == null;

  @override
  Future<void> handleMissedCall(CallSession session) async {
    if (PlatformInfos.isMobile) {
      await callkit.FlutterCallkitIncoming.endCall(session.callId);
    }
  }

  @override
  EncryptionKeyProvider? get keyProvider => null;

  @override
  Future<void> registerListeners(CallSession session) async {}

  void dispose() {
    _callkitSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}
