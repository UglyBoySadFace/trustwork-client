import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_callkit_incoming/entities/entities.dart' as fci;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart' as callkit;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc_impl;
import 'package:matrix/matrix.dart';
import 'package:webrtc_interface/webrtc_interface.dart' hide Navigator;

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/dialer/dialer.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/ringer_vibration.dart';
import '../../utils/voip/user_media_manager.dart';
import '../widgets/matrix.dart';

class VoipPlugin with WidgetsBindingObserver implements WebRTCDelegate {
  final MatrixState matrix;
  Client get client => matrix.client;

  String? _callkitAcceptedId;
  // Set on cold start when activeCalls() reports an accepted callkit entry.
  // The callkit entry's id does NOT match the Matrix call_id (callkit IDs
  // are minted by the push payload, Matrix IDs come from m.call.invite),
  // so we can't compare by id — we just remember "user has already accepted
  // a call via callkit" and auto-answer the first incoming ringing call.
  bool _callkitAcceptedOnColdStart = false;
  // Timestamp when cold-start flag was set. callkit's activeCalls() can
  // return STALE entries from a previous call that wasn't properly cleared
  // (e.g. app was force-killed before handleCallEnded ran). Without a
  // bound, the flag would auto-answer a brand-new call arriving hours
  // later. We only honor the flag for a brief window after plugin init.
  DateTime? _callkitAcceptedAt;
  static const _callkitAcceptedTtl = Duration(seconds: 15);
  StreamSubscription<fci.CallEvent?>? _callkitSubscription;
  Future<void>? _callkitRestoreFuture;

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
    // Track the future so handleNewCall can await it and avoid a cold-start
    // race where the m.call.invite arrives before _callkitAcceptedId is set.
    _callkitRestoreFuture = _restoreCallkitAcceptedId();

    _callkitSubscription?.cancel();
    _callkitSubscription = callkit.FlutterCallkitIncoming.onEvent.listen((fci.CallEvent? event) {
      switch (event?.event) {
        case fci.Event.actionCallAccept:
          Logs().i('[VOIP] callkit actionCallAccept id=${event?.body['id']}');
          unawaited(RingerVibration.stop());
          final callId = event?.body['id'] as String?;
          // If handleNewCall already ran and the call is waiting, answer it now.
          if (callId != null) {
            final existing = voip.calls.entries
                .where((e) => e.key.callId == callId)
                .firstOrNull
                ?.value;
            if (existing != null) {
              Logs().i('[VOIP] callkit accept: existing call found, answering directly');
              // Answer first so the call transitions out of kRinging before
              // the overlay's initState reads the state — otherwise the dialer
              // briefly shows the answer/decline buttons again.
              existing.answer();
              if (overlayEntry == null) {
                addCallingOverlay(callId, existing);
              }
              return;
            }
          }
          Logs().i('[VOIP] callkit accept: storing id for auto-answer in handleNewCall');
          // Otherwise store the ID so handleNewCall can auto-answer when it fires.
          _callkitAcceptedId = callId;
          break;
        case fci.Event.actionCallDecline:
          unawaited(RingerVibration.stop());
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
          unawaited(RingerVibration.stop());
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
              Logs().i('[VOIP] Cold-start: callkit reports accepted call (callkit id=$id) — will auto-answer first ringing Matrix call within ${_callkitAcceptedTtl.inSeconds}s');
              _callkitAcceptedOnColdStart = true;
              _callkitAcceptedAt = DateTime.now();
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
    if (_callkitAcceptedOnColdStart) {
      final pending = client.onCallEvents.value;
      if (pending != null && pending.isNotEmpty) {
        Logs().i('[VOIP] Replaying ${pending.length} cached call event(s) for auto-answer');
        client.onCallEvents.add(pending);
      } else {
        // No pending invite to auto-answer means the callkit entry is stale
        // (left over from a previously-killed call). Drop the flag and clear
        // callkit state so the next real call doesn't get auto-answered
        // without user consent.
        Logs().i('[VOIP] Cold-start flag set but no pending call events — treating as stale, clearing');
        _callkitAcceptedOnColdStart = false;
        _callkitAcceptedAt = null;
        try {
          await callkit.FlutterCallkitIncoming.endAllCalls();
        } catch (e) {
          Logs().w('[VOIP] endAllCalls failed: $e');
        }
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
  ]) async {
    Logs().i('[VOIP] createPeerConnection iceServers (raw): ${configuration['iceServers']}');
    // If the SDK didn't supply any TURN/STUN servers, fetch them ourselves
    // from the homeserver so calls between different networks can traverse NAT.
    final rawServers = configuration['iceServers'];
    var servers = rawServers;
    if (rawServers == null || (rawServers is List && rawServers.isEmpty)) {
      try {
        final turn = await client.getTurnServer();
        servers = <Map<String, dynamic>>[
          {
            'urls': turn.uris,
            if (turn.username != null) 'username': turn.username,
            if (turn.password != null) 'credential': turn.password,
          },
        ];
        Logs().i('[VOIP] Injecting fallback iceServers from /voip/turnServer: $servers');
      } catch (e, s) {
        Logs().w('[VOIP] getTurnServer failed', e, s);
      }
    }

    // Sanitize URLs: matrix homeservers commonly emit
    //   turns:host?transport=udp
    // which is invalid (TURNS = TLS over TCP). Chrome's libwebrtc tolerates
    // it; libwebrtc on Android (via flutter_webrtc) sometimes rejects the
    // whole entry, which leaves us with no relay candidates — calls work
    // only on the same LAN. Filter the bogus combos out.
    if (servers is List) {
      final cleaned = <Map<String, dynamic>>[];
      for (final s in servers) {
        if (s is! Map) continue;
        final urlsRaw = s['urls'];
        List<String> urls;
        if (urlsRaw is List) {
          urls = urlsRaw.whereType<String>().toList();
        } else if (urlsRaw is String) {
          urls = [urlsRaw];
        } else {
          urls = const [];
        }
        final filtered = urls.where((u) {
          // drop turns:...?transport=udp — invalid per RFC 7065 (TURNS is TCP).
          if (u.startsWith('turns:') && u.contains('transport=udp')) {
            return false;
          }
          return true;
        }).toList();
        if (filtered.isEmpty) continue;
        cleaned.add(<String, dynamic>{
          ...Map<String, dynamic>.from(s),
          'urls': filtered,
        });
      }
      Logs().i('[VOIP] createPeerConnection iceServers (sanitized): $cleaned');
      configuration = {...configuration, 'iceServers': cleaned};
    }
    return webrtc_impl.createPeerConnection(configuration, constraints);
  }

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
    Logs().i('[VOIP] handleNewCall enter id=${call.callId} state=${call.state} acceptedId=$_callkitAcceptedId coldStartAccepted=$_callkitAcceptedOnColdStart restorePending=${_callkitRestoreFuture != null}');
    // On cold start the m.call.invite can be processed before activeCalls()
    // sets the cold-start flag. Wait for the restore so we don't fall
    // through to the ringing-overlay path for a call the user already
    // accepted.
    if (_callkitRestoreFuture != null) {
      try {
        await _callkitRestoreFuture;
      } catch (_) {}
    }
    Logs().i('[VOIP] handleNewCall after-restore id=${call.callId} acceptedId=$_callkitAcceptedId coldStartAccepted=$_callkitAcceptedOnColdStart');

    // Cold-start auto-answer: if callkit reported an accepted call when we
    // booted, the very first ringing Matrix call we see is the one the user
    // accepted. The callkit id and Matrix call_id don't match, so we can't
    // compare them — we just consume the flag here.
    // Time-bound the flag: callkit's activeCalls() can return stale entries
    // from previously killed calls. Without a TTL a brand-new call arriving
    // hours later would be auto-answered against the user's consent.
    final acceptedAt = _callkitAcceptedAt;
    final flagFresh = acceptedAt != null &&
        DateTime.now().difference(acceptedAt) < _callkitAcceptedTtl;
    if (_callkitAcceptedOnColdStart && !flagFresh) {
      Logs().i('[VOIP] Discarding stale cold-start accept flag (age=${acceptedAt == null ? 'null' : DateTime.now().difference(acceptedAt).inSeconds}s)');
      _callkitAcceptedOnColdStart = false;
      _callkitAcceptedAt = null;
    }
    final coldStartMatch = _callkitAcceptedOnColdStart &&
        flagFresh &&
        call.isRinging &&
        !call.isOutgoing;
    if (coldStartMatch) {
      _callkitAcceptedOnColdStart = false;
      _callkitAcceptedAt = null;
    }

    // If the user already accepted from the callkit lock-screen UI, auto-answer.
    // The foreground service can be started here because the user has just
    // interacted with the callkit notification — Android treats that as an
    // eligible state for starting a microphone-type FGS.
    if (_callkitAcceptedId == call.callId || coldStartMatch) {
      Logs().i('[VOIP] handleNewCall: AUTO-ANSWER path id=${call.callId} (coldStart=$coldStartMatch)');
      _callkitAcceptedId = null;
      if (PlatformInfos.isAndroid) {
        unawaited(_startForegroundService());
      }
      // Answer before showing the overlay so the dialer doesn't briefly
      // render the ringing UI (answer/decline buttons) on top of a call
      // the user already accepted from the lock-screen callkit notification.
      await call.answer();
      Logs().i('[VOIP] handleNewCall: answered, state=${call.state}, adding overlay');
      addCallingOverlay(call.callId, call);
      return;
    }
    Logs().i('[VOIP] handleNewCall: RINGING path (no auto-answer) id=${call.callId}');

    // Show the call screen immediately — don't wait for foreground service setup.
    // We deliberately do NOT start the foreground service here: on Android 14+
    // (targetSDK 34+) starting a microphone-type FGS while the call is still
    // ringing throws SecurityException and triggers a 5-second restart loop.
    // The service is started by the dialer when the user actually answers.
    addCallingOverlay(call.callId, call);
    if (call.isRinging && !call.isOutgoing) {
      unawaited(RingerVibration.start());
    }
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
      // When the app is already in the foreground, don't relaunch the
      // activity or wake up the screen — those calls trigger an Activity
      // re-create on some OEMs (observed on OnePlus/ColorOS), which tears
      // down the Calling overlay mid-connection. The overlay's dispose()
      // then calls call.cleanUp(), terminating the call we just answered.
      // Only set lock-screen visibility / launch-app when the user
      // actually needs the app brought to front.
      if (wasForeground != true) {
        FlutterForegroundTask.setOnLockScreenVisibility(true);
        FlutterForegroundTask.wakeUpScreen();
        FlutterForegroundTask.launchApp();
      }
      await matrix.store.setString(
        'wasForeground',
        wasForeground == true ? 'true' : 'false',
      );
      await FlutterForegroundTask.startService(
        serviceTypes: [ForegroundServiceTypes.microphone],
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
      unawaited(RingerVibration.stop());
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
      unawaited(RingerVibration.stop());
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
