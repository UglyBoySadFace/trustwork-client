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
import 'package:fluffychat/utils/trustwork_api_service.dart';
import '../../utils/voip/user_media_manager.dart';
import '../widgets/matrix.dart';

// Wraps RTCPeerConnection to fix a DTLS role conflict that crashes iceRestart.
//
// When we answer as callee we commit to a=setup:active (DTLS client). On
// iceRestart our re-offer uses a=setup:actpass, but Firefox/Element responds
// a=setup:active (both want to be DTLS client). libwebrtc-android then throws
// "Failed to set SSL role for the transport" and the call is torn down before
// relay candidates get a chance to connect. We fix the conflict by rewriting
// the remote answer's a=setup:active → passive whenever we are already active.
class _DtlsRoleFixPeerConnection extends RTCPeerConnection {
  _DtlsRoleFixPeerConnection(this._pc) {
    _pc.onSignalingState = (s) => onSignalingState?.call(s);
    _pc.onConnectionState = (s) => onConnectionState?.call(s);
    _pc.onIceGatheringState = (s) => onIceGatheringState?.call(s);
    _pc.onIceConnectionState = (s) => onIceConnectionState?.call(s);
    _pc.onIceCandidate = (c) => onIceCandidate?.call(c);
    _pc.onAddStream = (s) => onAddStream?.call(s);
    _pc.onRemoveStream = (s) => onRemoveStream?.call(s);
    _pc.onAddTrack = (s, t) => onAddTrack?.call(s, t);
    _pc.onRemoveTrack = (s, t) => onRemoveTrack?.call(s, t);
    _pc.onDataChannel = (c) => onDataChannel?.call(c);
    _pc.onRenegotiationNeeded = () => onRenegotiationNeeded?.call();
    _pc.onTrack = (e) => onTrack?.call(e);
  }

  final RTCPeerConnection _pc;
  // Committed DTLS role (active/passive). Updated only when we see a final
  // role, not actpass, so re-offer actpass doesn't overwrite our real role.
  String? _localDtlsRole;

  @override
  RTCSignalingState? get signalingState => _pc.signalingState;
  @override
  RTCIceGatheringState? get iceGatheringState => _pc.iceGatheringState;
  @override
  RTCIceConnectionState? get iceConnectionState => _pc.iceConnectionState;
  @override
  RTCPeerConnectionState? get connectionState => _pc.connectionState;
  @override
  Map<String, dynamic> get getConfiguration => _pc.getConfiguration;

  @override
  Future<void> dispose() => _pc.dispose();
  @override
  Future<void> setConfiguration(Map<String, dynamic> configuration) =>
      _pc.setConfiguration(configuration);
  @override
  Future<RTCSessionDescription> createOffer([Map<String, dynamic> constraints = const {}]) =>
      _pc.createOffer(constraints);
  @override
  Future<RTCSessionDescription> createAnswer([Map<String, dynamic> constraints = const {}]) =>
      _pc.createAnswer(constraints);
  @override
  Future<void> addStream(MediaStream stream) => _pc.addStream(stream);
  @override
  Future<void> removeStream(MediaStream stream) => _pc.removeStream(stream);
  @override
  Future<RTCSessionDescription?> getLocalDescription() =>
      _pc.getLocalDescription();

  @override
  Future<void> setLocalDescription(RTCSessionDescription description) async {
    final match = RegExp(r'a=setup:(\w+)').firstMatch(description.sdp ?? '');
    if (match != null) {
      final role = match.group(1);
      if (role == 'active' || role == 'passive') {
        _localDtlsRole = role;
        Logs().d('[VOIP] DTLS local role: $_localDtlsRole (${description.type})');
      }
    }
    return _pc.setLocalDescription(description);
  }

  @override
  Future<RTCSessionDescription?> getRemoteDescription() =>
      _pc.getRemoteDescription();

  @override
  Future<void> setRemoteDescription(RTCSessionDescription description) {
    var sdp = description.sdp ?? '';
    if (description.type == 'answer' &&
        _localDtlsRole == 'active' &&
        sdp.contains('a=setup:active')) {
      Logs().i('[VOIP] Fixing DTLS role conflict: a=setup:active → passive in remote answer');
      sdp = sdp.replaceAll('a=setup:active', 'a=setup:passive');
    }
    return _pc.setRemoteDescription(RTCSessionDescription(sdp, description.type));
  }

  @override
  Future<void> addCandidate(RTCIceCandidate candidate) =>
      _pc.addCandidate(candidate);
  @override
  Future<List<StatsReport>> getStats([MediaStreamTrack? track]) =>
      _pc.getStats(track);
  @override
  List<MediaStream?> getLocalStreams() => _pc.getLocalStreams();
  @override
  List<MediaStream?> getRemoteStreams() => _pc.getRemoteStreams();
  @override
  Future<RTCDataChannel> createDataChannel(
    String label,
    RTCDataChannelInit dataChannelDict,
  ) => _pc.createDataChannel(label, dataChannelDict);
  @override
  Future<void> restartIce() => _pc.restartIce();
  @override
  Future<void> close() => _pc.close();
  @override
  RTCDTMFSender createDtmfSender(MediaStreamTrack track) =>
      _pc.createDtmfSender(track);
  @override
  Future<List<RTCRtpSender>> getSenders() => _pc.getSenders();
  @override
  Future<List<RTCRtpReceiver>> getReceivers() => _pc.getReceivers();
  @override
  Future<List<RTCRtpTransceiver>> getTransceivers() => _pc.getTransceivers();
  @override
  Future<RTCRtpSender> addTrack(MediaStreamTrack track, [MediaStream? stream]) {
    if (stream != null) return _pc.addTrack(track, stream);
    return _pc.addTrack(track);
  }

  @override
  Future<bool> removeTrack(RTCRtpSender sender) => _pc.removeTrack(sender);

  @override
  Future<RTCRtpTransceiver> addTransceiver({
    MediaStreamTrack? track,
    RTCRtpMediaType? kind,
    RTCRtpTransceiverInit? init,
  }) =>
      // The abstract class declares non-null params but the concrete flutter_webrtc
      // impl uses nullable. Cast through dynamic to match the actual runtime signature.
      (_pc as dynamic).addTransceiver(track: track, kind: kind, init: init)
          as Future<RTCRtpTransceiver>;
}

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
              unawaited(answerCall(existing));
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
  // callId the current overlayEntry was created for, so re-adding the overlay
  // for the same call is a no-op instead of a destructive remove+reinsert
  // (removing unmounts the old Calling widget, whose dispose() tears down the
  // very call the new overlay is about to show).
  String? _overlayCallId;
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

  // Scans the room's DB timeline for a com.trustwork.contact_request event
  // and fires acceptContactRequest if found. Used on the callee side when
  // answering from the lock screen (cold-start path) where the dialer's
  // _answerCall() is never invoked.
  Future<void> _acceptContactRequestFromRoom(CallSession call) async {
    final events = await client.database.getEventList(call.room, limit: 30);
    for (final event in events) {
      if (event.type == 'com.trustwork.contact_request') {
        final requestId = event.content.tryGet<int>('request_id');
        if (requestId != null) {
          unawaited(_doAcceptContactRequest(requestId, call.room));
          return;
        }
      }
    }
  }

  Future<void> _doAcceptContactRequest(int requestId, Room room) async {
    try {
      await TrustworkApiService.instance.acceptContactRequest(requestId);
      await matrix.contactsCache.refresh(matrix.store);
      final callerId = room
          .getParticipants()
          .where((m) => m.id != client.userID)
          .firstOrNull
          ?.id;
      if (callerId != null) {
        unawaited(room.addToDirectChat(callerId));
      }
      unawaited(
        room
            .sendEvent({}, type: 'com.trustwork.contact_accepted')
            .catchError((_) => ''),
      );
    } catch (e) {
      Logs().w('[CALL-CONNECT] _doAcceptContactRequest($requestId) failed: $e');
    }
  }

  void addCallingOverlay(String callId, CallSession call) {
    final context = ChatList.contextForVoip ?? this.context;

    if (overlayEntry != null) {
      if (_overlayCallId == callId) {
        Logs().i(
          '[VOIP] addCallingOverlay: overlay for $callId already shown, skipping',
        );
        return;
      }
      Logs().e(
        '[VOIP] addCallingOverlay: replacing overlay for $_overlayCallId with $callId',
      );
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
      late final OverlayEntry entry;
      entry = OverlayEntry(
        builder: (_) => Calling(
          context: context,
          client: client,
          callId: callId,
          call: call,
          onClear: () => _removeOverlayEntry(entry),
        ),
      );
      overlayEntry = entry;
      _overlayCallId = callId;
      Overlay.of(context).insert(entry);
    }
  }

  void _removeOverlay() {
    final entry = overlayEntry;
    overlayEntry = null;
    _overlayCallId = null;
    entry?.remove();
  }

  // Entry-specific removal: a stale onClear (e.g. the previous call's delayed
  // clear timer in the dialer) must not remove the overlay of a newer call.
  void _removeOverlayEntry(OverlayEntry entry) {
    if (!identical(entry, overlayEntry)) return;
    _removeOverlay();
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
    final pc = await webrtc_impl.createPeerConnection(configuration, constraints);
    return _DtlsRoleFixPeerConnection(pc);
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
      // If this call arrived in a contact-request delivery room, accept the
      // request so the room unlocks. Fire-and-forget alongside the call answer.
      unawaited(_acceptContactRequestFromRoom(call));
      // Answer before showing the overlay so the dialer doesn't briefly
      // render the ringing UI (answer/decline buttons) on top of a call
      // the user already accepted from the lock-screen callkit notification.
      await answerCall(call);
      Logs().i('[VOIP] handleNewCall: answered, state=${call.state}, adding overlay');
      addCallingOverlay(call.callId, call);
      return;
    }
    Logs().i('[VOIP] handleNewCall: RINGING path (no auto-answer) id=${call.callId}');

    // The callkit accept handler may have answered this call and added its
    // overlay while we were awaiting the restore future above — in that case
    // re-adding the overlay or starting the ringer would fight the live call.
    if (overlayEntry != null && _overlayCallId == call.callId) {
      Logs().i(
        '[VOIP] handleNewCall: overlay for ${call.callId} already shown, skipping ringing path',
      );
      return;
    }

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

  // Calls we already invoked answer() on. The SDK's own reentrancy guard
  // (_inviteOrAnswerSent) is only set after createAnswer + the network send
  // complete, so two overlapping answer() calls (in-app answer button +
  // callkit notification action) would both run createAnswer on the same
  // peer connection.
  final _answeredCallIds = <String>{};

  /// Single funnel for answering a call — all answer paths (callkit accept,
  /// cold-start auto-answer, dialer answer button) must go through here so
  /// [CallSession.answer] runs at most once per call.
  Future<void> answerCall(CallSession call) async {
    if (!_answeredCallIds.add(call.callId)) {
      Logs().i(
        '[VOIP] answerCall: ${call.callId} already being answered, ignoring',
      );
      return;
    }
    await call.answer();
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
    _answeredCallIds.remove(session.callId);
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
    _answeredCallIds.remove(session.callId);
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
