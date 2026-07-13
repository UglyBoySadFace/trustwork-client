/*
 *   Famedly
 *   Copyright (C) 2019, 2020, 2021 Famedly GmbH
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:api_client/api_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' hide VideoRenderer;
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'package:dio/dio.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/data_sharing/data_sharing_approval_sheet.dart';
import 'package:fluffychat/utils/data_sharing/data_sharing_service.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/data_sharing/sharing_preferences_cache.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/ringer_vibration.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/utils/voip/user_media_manager.dart';
import 'package:fluffychat/utils/voip/video_renderer.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'pip/pip_view.dart';

class _CallStats {
  final double rttMs;
  final double jitterMs;
  final double packetLossPercent;
  final double audioLevel;
  final String iceType;

  const _CallStats({
    required this.rttMs,
    required this.jitterMs,
    required this.packetLossPercent,
    required this.audioLevel,
    required this.iceType,
  });

  static Future<_CallStats?> fromPeerConnection(
    RTCPeerConnection pc,
  ) async {
    final reports = await pc.getStats();

    final remoteInbound = reports.firstWhere(
      (r) => r.type == 'remote-inbound-rtp' && r.values['kind'] == 'audio',
      orElse: () => reports.firstWhere(
        (r) => r.type == 'remote-inbound-rtp',
        orElse: () => StatsReport('', '', 0, {}),
      ),
    );
    final candidatePair = reports.firstWhere(
      (r) =>
          r.type == 'candidate-pair' &&
          (r.values['nominated'] == true || r.values['state'] == 'succeeded'),
      orElse: () => StatsReport('', '', 0, {}),
    );
    final inboundRtp = reports.firstWhere(
      (r) => r.type == 'inbound-rtp' && r.values['kind'] == 'audio',
      orElse: () => StatsReport('', '', 0, {}),
    );

    // RTT: prefer RTCP-based remote-inbound-rtp, fall back to candidate-pair
    final rttRaw =
        _toDouble(remoteInbound.values['roundTripTime']) ??
        _toDouble(candidatePair.values['currentRoundTripTime']);
    if (rttRaw == null) return null;

    final jitterRaw = _toDouble(inboundRtp.values['jitter']) ?? 0.0;
    final lost = _toDouble(inboundRtp.values['packetsLost']) ?? 0.0;
    final received = _toDouble(inboundRtp.values['packetsReceived']) ?? 0.0;
    final total = lost + received;
    final lossPercent = total > 0 ? (lost / total * 100) : 0.0;
    final audioLevel = _toDouble(inboundRtp.values['audioLevel']) ?? 0.0;

    // ICE candidate type from the active candidate pair
    final localCandidateId =
        candidatePair.values['localCandidateId'] as String?;
    final localCandidate = localCandidateId != null
        ? reports.firstWhere(
            (r) => r.id == localCandidateId,
            orElse: () => StatsReport('', '', 0, {}),
          )
        : null;
    final iceType =
        (localCandidate?.values['candidateType'] as String?) ?? '?';

    return _CallStats(
      rttMs: rttRaw * 1000,
      jitterMs: jitterRaw * 1000,
      packetLossPercent: lossPercent,
      audioLevel: audioLevel,
      iceType: iceType,
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}

class _StreamView extends StatelessWidget {
  const _StreamView(
    this.wrappedStream, {
    this.mainView = false,
    required this.matrixClient,
  });

  final WrappedMediaStream wrappedStream;
  final Client matrixClient;

  final bool mainView;

  Uri? get avatarUrl => wrappedStream.getUser().avatarUrl;

  String? get displayName => wrappedStream.displayName;

  String get avatarName => wrappedStream.avatarName;

  bool get isLocal => wrappedStream.isLocal();

  bool get mirrored =>
      wrappedStream.isLocal() &&
      wrappedStream.purpose == SDPStreamMetadataPurpose.Usermedia;

  bool get audioMuted => wrappedStream.audioMuted;

  bool get videoMuted => wrappedStream.videoMuted;

  bool get isScreenSharing =>
      wrappedStream.purpose == SDPStreamMetadataPurpose.Screenshare;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black54),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          VideoRenderer(
            wrappedStream,
            mirror: mirrored,
            fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
          ),
          if (videoMuted) ...[
            Container(color: Colors.black54),
            Positioned(
              child: Avatar(
                mxContent: avatarUrl,
                name: isLocal
                    ? displayName
                    : Matrix.of(context)
                        .contactsCache
                        .label(wrappedStream.getUser().id),
                size: mainView ? 96 : 48,
                client: matrixClient,
                // textSize: mainView ? 36 : 24,
                // matrixClient: matrixClient,
              ),
            ),
          ],
          if (!isScreenSharing)
            Positioned(
              left: 4.0,
              bottom: 4.0,
              child: Icon(
                audioMuted ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 18.0,
              ),
            ),
        ],
      ),
    );
  }
}

class Calling extends StatefulWidget {
  final VoidCallback? onClear;
  final BuildContext context;
  final String callId;
  final CallSession call;
  final Client client;

  const Calling({
    required this.context,
    required this.call,
    required this.client,
    required this.callId,
    this.onClear,
    super.key,
  });

  @override
  MyCallingPage createState() => MyCallingPage();
}

class _StatsOverlay extends StatelessWidget {
  const _StatsOverlay({required this.stats});

  final _CallStats stats;

  Color get _rttColor {
    if (stats.rttMs < 150) return Colors.greenAccent;
    if (stats.rttMs < 400) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Color get _lossColor {
    if (stats.packetLossPercent < 1) return Colors.greenAccent;
    if (stats.packetLossPercent < 5) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(160),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _row('RTT', '${stats.rttMs.round()} ms', _rttColor),
            _row('Jitter', '${stats.jitterMs.round()} ms', Colors.white70),
            _row(
              'Loss',
              '${stats.packetLossPercent.toStringAsFixed(1)} %',
              _lossColor,
            ),
            _row('ICE', stats.iceType, Colors.white70),
            _audioBar(stats.audioLevel),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, Color valueColor) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 1),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          child: Text(label, style: const TextStyle(color: Colors.white54)),
        ),
        Text(value, style: TextStyle(color: valueColor)),
      ],
    ),
  );

  Widget _audioBar(double level) => Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 36,
          child: Text('Audio', style: TextStyle(color: Colors.white54)),
        ),
        Container(
          width: 60,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: level.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class MyCallingPage extends State<Calling> {
  Room? get room => call.room;

  String get displayName {
    final mxId = call.room.directChatMatrixID;
    if (mxId != null) {
      return Matrix.of(widget.context).contactsCache.label(mxId);
    }
    return call.room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(widget.context)),
    );
  }

  String get callId => widget.callId;

  CallSession get call => widget.call;

  MediaStream? get localStream {
    if (call.localUserMediaStream != null) {
      return call.localUserMediaStream!.stream!;
    }
    return null;
  }

  MediaStream? get remoteStream {
    if (call.getRemoteStreams.isNotEmpty) {
      return call.getRemoteStreams.first.stream!;
    }
    return null;
  }

  bool get isMicrophoneMuted => call.isMicrophoneMuted;

  bool get isLocalVideoMuted => call.isLocalVideoMuted;

  bool get isScreensharingEnabled => call.screensharingEnabled;

  bool get isRemoteOnHold => call.remoteOnHold;

  bool get voiceonly => call.type == CallType.kVoice;

  bool get connecting => call.state == CallState.kConnecting;

  bool get connected => call.state == CallState.kConnected;

  double? _localVideoHeight;
  double? _localVideoWidth;
  EdgeInsetsGeometry? _localVideoMargin;
  CallState? _state;
  bool _speakerOn = false;
  _CallStats? _callStats;
  Timer? _statsTimer;
  Timer? _clearTimer;

  // Disables the answer FAB after the first tap; the call only leaves
  // kRinging asynchronously, so without this a double tap answers twice.
  bool _answerPressed = false;

  AudioPlayer? _callSoundPlayer;

  // Snapshot of call.isOutgoing taken once in initState.  Using call.isOutgoing
  // directly on every build opens a small window where the SDK may not have
  // fully initialised the direction (e.g. during the async handleNewCall path),
  // causing the callee UI to flash briefly on an outgoing call.
  late final bool _isOutgoing;

  StreamSubscription<IncomingDataRequest>? _dataReqSub;
  StreamSubscription<ProactiveShareData>? _proactiveShareSub;
  SharedData? _proactiveShareData;
  final List<IncomingDataRequest> _pendingPrompts = [];
  IncomingDataRequest? _currentPrompt;
  BuildContext? _sheetContext;
  Map<ShareableField, bool> _cachedSharingPrefs = const {};

  BuildContext? _calleeSheetContext;

  // The Calling widget is mounted inside an OverlayEntry that sits above the
  // root Navigator, so pushing a modal route through the outer Navigator (as
  // showModalBottomSheet does by default) renders the sheet underneath the
  // opaque call UI. We host the sheets in a local Navigator instead, which
  // lives inside the OverlayEntry's subtree, so they stack above the call UI.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  BuildContext get _sheetHostContext =>
      _navigatorKey.currentState?.overlay?.context ?? context;

  Future<void> _playCallSound() async {
    const path = 'assets/sounds/call.ogg';
    if (kIsWeb || PlatformInfos.isMobile || PlatformInfos.isMacOS) {
      final player = _callSoundPlayer = AudioPlayer();
      // _stopCallSound may run while we're awaiting below (instant answer,
      // hangup during asset load). It nulls the field, so re-check after
      // each await — otherwise we'd start a looping sound nothing owns.
      await player.setAsset(path);
      if (!identical(_callSoundPlayer, player)) {
        await player.dispose();
        return;
      }
      await player.setLoopMode(LoopMode.one);
      if (!identical(_callSoundPlayer, player)) {
        await player.dispose();
        return;
      }
      unawaited(player.play());
    } else {
      Logs().w('Playing sound not implemented for this platform!');
    }
  }

  void _stopCallSound() {
    final player = _callSoundPlayer;
    _callSoundPlayer = null;
    if (player != null) {
      unawaited(player.stop().then((_) => player.dispose()));
    }
  }

  @override
  void initState() {
    super.initState();
    // Capture direction before initialize() so subscriptions and build logic
    // always agree on whether this is an outgoing or incoming call.
    _isOutgoing = call.isOutgoing;
    initialize();
    if (_isOutgoing) {
      // Only play outgoing dialing sound for calls we initiated.
      unawaited(_playCallSound());
      _wireDataSharing();
    } else {
      _wireCalleeProactiveReceive();
    }
  }

  void _wireCalleeProactiveReceive() {
    final service = Matrix.of(widget.context)
        .dataSharingServices[widget.client.clientName];
    if (service == null) {
      Logs().w('[DATA-SHARING] _wireCalleeProactiveReceive: service is null');
      return;
    }
    Logs().i('[DATA-SHARING] _wireCalleeProactiveReceive: subscribed');
    _proactiveShareSub = service.proactiveShares.listen(_onProactiveShare);
    // The to-device event often arrives before the dialer widget is built.
    // Replay the cached share immediately if one already arrived.
    final cached = service.lastProactiveShare;
    if (cached != null) {
      Logs().i('[DATA-SHARING] _wireCalleeProactiveReceive: replaying cached share from=${cached.fromMatrixId}');
      _onProactiveShare(cached);
    }
  }

  void _onProactiveShare(ProactiveShareData share) {
    Logs().i(
      '[DATA-SHARING] _onProactiveShare: from=${share.fromMatrixId} state=$_state mounted=$mounted isOutgoing=$_isOutgoing',
    );
    if (_isOutgoing) {
      Logs().w('[DATA-SHARING] _onProactiveShare: called on outgoing call — ignoring');
      return;
    }
    if (!mounted) return;
    if (!_inDataSharingWindow(_state)) {
      Logs().i('[DATA-SHARING] _onProactiveShare: dropped — outside window');
      return;
    }
    if (!call.room.getParticipants().any((m) => m.id == share.fromMatrixId)) {
      Logs().i('[DATA-SHARING] _onProactiveShare: dropped — sender not in room');
      return;
    }
    Logs().i('[DATA-SHARING] _onProactiveShare: showing inline card');
    setState(() => _proactiveShareData = share.data);
  }

  void _wireDataSharing() {
    final matrix = Matrix.of(widget.context);
    final service = matrix.dataSharingServices[widget.client.clientName];
    if (service == null) return;

    _cachedSharingPrefs =
        SharingPreferencesCache.read(matrix.store) ?? const {};
    // Refresh in the background so the next prompt reflects any settings
    // changes the user made on a different device. Best-effort — failures
    // just leave the cache as-is.
    unawaited(
      SharingPreferencesCache.refresh(matrix.store).then(
        (next) {
          if (!mounted) return;
          _cachedSharingPrefs = next;
        },
        onError: (Object e, StackTrace s) =>
            Logs().d('[DATA-SHARING] background prefs refresh failed', e, s),
      ),
    );

    _dataReqSub = service.incomingRequests.listen(_onIncomingDataRequest);
    _autoProactiveShare(service);
  }

  void _autoProactiveShare(DataSharingService service) {
    final calleeId = call.room.directChatMatrixID;
    if (calleeId == null) {
      Logs().i('[DATA-SHARING] _autoProactiveShare: skipped — not a 1:1 room');
      return;
    }
    final enabledFields = _cachedSharingPrefs.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toSet();
    if (enabledFields.isEmpty) {
      Logs().i('[DATA-SHARING] _autoProactiveShare: skipped — no enabled fields');
      return;
    }
    Logs().i(
      '[DATA-SHARING] _autoProactiveShare: sharing fields=${enabledFields.map((f) => f.wireId).toList()} to=$calleeId',
    );
    unawaited(
      service
          .proactiveShare(calleeMatrixId: calleeId, fields: enabledFields)
          .then(
            (_) {},
            onError: (Object e, StackTrace s) => Logs().w(
              '[DATA-SHARING] proactive share failed callee_id=$calleeId',
              e,
              s,
            ),
          ),
    );
  }

  void _onIncomingDataRequest(IncomingDataRequest req) {
    if (!mounted) return;
    if (!_inDataSharingWindow(_state)) return;
    if (!call.room.getParticipants().any((m) => m.id == req.fromMatrixId)) {
      return;
    }
    _pendingPrompts.add(req);
    _maybeShowNextPrompt();
  }

  /// True while the call is still in its pre-answer phase. Once the caller
  /// answers (kConnecting/kConnected) or the call ends, the data-sharing
  /// window is closed. The caller side moves through kInviteSent rather than
  /// kRinging, so both are accepted.
  static bool _inDataSharingWindow(CallState? state) {
    switch (state) {
      case null:
      case CallState.kFledgling:
      case CallState.kWaitLocalMedia:
      case CallState.kCreateOffer:
      case CallState.kInviteSent:
      case CallState.kRinging:
        return true;
      case CallState.kCreateAnswer:
      case CallState.kConnecting:
      case CallState.kConnected:
      case CallState.kEnding:
      case CallState.kEnded:
        return false;
    }
  }

  void _maybeShowNextPrompt() {
    if (!mounted) return;
    if (_currentPrompt != null) return;
    if (_pendingPrompts.isEmpty) return;
    final next = _pendingPrompts.removeAt(0);
    _currentPrompt = next;
    unawaited(_showApprovalSheet(next));
  }

  Future<void> _showApprovalSheet(IncomingDataRequest req) async {
    final defaults = <ShareableField, bool>{
      for (final f in req.fields) f: _cachedSharingPrefs[f] ?? false,
    };
    final fromName =
        Matrix.of(widget.context).contactsCache.label(req.fromMatrixId);

    try {
      await showModalBottomSheet<void>(
        context: _sheetHostContext,
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetCtx) {
          _sheetContext = sheetCtx;
          return DataSharingApprovalSheet(
            requesterDisplayName: fromName,
            fields: req.fields.toList()..sort((a, b) => a.index.compareTo(b.index)),
            defaults: defaults,
            onShare: (selected) => _handleApprove(req, selected),
            onDecline: () => _handleDecline(req),
          );
        },
      );
    } finally {
      if (identical(_currentPrompt, req)) {
        _currentPrompt = null;
        _sheetContext = null;
      }
      _maybeShowNextPrompt();
    }
  }

  Future<String?> _handleApprove(
    IncomingDataRequest req,
    Set<ShareableField> selected,
  ) async {
    final service =
        Matrix.of(widget.context).dataSharingServices[widget.client.clientName];
    if (service == null) return L10n.of(widget.context).dataSharingShareFailed;
    try {
      await service.approve(request: req, approvedFields: selected);
      _dismissCurrentSheet();
      return null;
    } catch (e, s) {
      Logs().w(
        '[DATA-SHARING] approve failed request_id=${req.requestId} matrix_id=${req.fromMatrixId}',
        e,
        s,
      );
      if (!mounted) return null;
      return L10n.of(widget.context).dataSharingShareFailed;
    }
  }

  Future<void> _handleDecline(IncomingDataRequest req) async {
    final service =
        Matrix.of(widget.context).dataSharingServices[widget.client.clientName];
    try {
      await service?.decline(req);
    } catch (e, s) {
      Logs().w(
        '[DATA-SHARING] decline failed request_id=${req.requestId} matrix_id=${req.fromMatrixId}',
        e,
        s,
      );
    }
    _dismissCurrentSheet();
  }

  void _dismissCurrentSheet() {
    // Null _sheetContext synchronously so a re-entrant dismiss (e.g. call
    // ends while an approve is mid-flight) doesn't try to pop a sibling
    // route after our own sheet was already removed.
    final ctx = _sheetContext;
    _sheetContext = null;
    if (ctx != null && ctx.mounted && Navigator.canPop(ctx)) {
      Navigator.of(ctx).pop();
    }
  }

  void _abortDataSharingPrompts() {
    _pendingPrompts.clear();
    _dismissCurrentSheet();
    _dismissCalleeSheet();
  }

  void _dismissCalleeSheet() {
    final ctx = _calleeSheetContext;
    _calleeSheetContext = null;
    if (ctx != null && ctx.mounted && Navigator.canPop(ctx)) {
      Navigator.of(ctx).pop();
    }
  }

  Future<void> _showRequestInfoSheet() async {
    final mxId = call.room.directChatMatrixID;
    if (mxId == null) return;
    final service =
        Matrix.of(context).dataSharingServices[widget.client.clientName];
    if (service == null) return;
    final callerName = Matrix.of(context).contactsCache.label(mxId);

    try {
      await showModalBottomSheet<void>(
        context: _sheetHostContext,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (sheetCtx) {
          _calleeSheetContext = sheetCtx;
          return _DataSharingRequestSheet(
            callerDisplayName: callerName,
            callerMatrixId: mxId,
            service: service,
          );
        },
      );
    } finally {
      _calleeSheetContext = null;
    }
  }

  void initialize() {
    final call = this.call;
    call.onCallStateChanged.stream.listen(_handleCallState);
    call.onCallEventChanged.stream.listen((event) {
      if (event == CallStateChange.kFeedsChanged) {
        setState(call.tryRemoveStopedStreams);
      } else if (event == CallStateChange.kLocalHoldUnhold ||
          event == CallStateChange.kRemoteHoldUnhold) {
        setState(() {});
        Logs().i(
          'Call hold event: local ${call.localHold}, remote ${call.remoteOnHold}',
        );
      }
    });
    _state = call.state;

    try {
      // Enable wakelock for all call types to prevent CPU sleep dropping audio
      unawaited(WakelockPlus.enable());
    } catch (_) {}
  }

  void cleanUp() {
    _stopCallSound();
    _stopStatsPolling();
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(seconds: 2), () => widget.onClear?.call());
    try {
      unawaited(WakelockPlus.disable());
    } catch (_) {}
  }

  void _startStatsPolling() {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final pc = call.pc;
      if (pc == null) return;
      final stats = await _CallStats.fromPeerConnection(pc);
      if (mounted) setState(() => _callStats = stats);
    });
  }

  void _stopStatsPolling() {
    _statsTimer?.cancel();
    _statsTimer = null;
    _callStats = null;
  }

  @override
  void dispose() {
    // The sound normally stops on kConnected/kEnded, but an overlay removed
    // without a state transition would leave it looping.
    _stopCallSound();
    _stopStatsPolling();
    _clearTimer?.cancel();
    _clearTimer = null;
    _dataReqSub?.cancel();
    _dataReqSub = null;
    _proactiveShareSub?.cancel();
    _proactiveShareSub = null;
    _abortDataSharingPrompts();
    super.dispose();
    // Only tear down the call's media/peer connection when the call is
    // actually over. Every SDK end path (hangup, reject, errors) goes through
    // terminate(), which already runs cleanUp() itself — so for a live call
    // this would destroy the peer connection just because the overlay widget
    // was unmounted (e.g. an OEM activity re-create).
    if (call.callHasEnded) {
      unawaited(call.cleanUp());
    }
  }

  void _resizeLocalVideo(Orientation orientation) {
    final shortSide = min(
      MediaQuery.sizeOf(widget.context).width,
      MediaQuery.sizeOf(widget.context).height,
    );
    _localVideoMargin = remoteStream != null
        ? const EdgeInsets.only(top: 20.0, right: 20.0)
        : EdgeInsets.zero;
    _localVideoWidth = remoteStream != null
        ? shortSide / 3
        : MediaQuery.sizeOf(widget.context).width;
    _localVideoHeight = remoteStream != null
        ? shortSide / 4
        : MediaQuery.sizeOf(widget.context).height;
  }

  void _handleCallState(CallState state) {
    Logs().v('CallingPage::handleCallState: ${state.toString()}');
    if ({CallState.kConnected, CallState.kEnded}.contains(state)) {
      HapticFeedback.heavyImpact();
    }

    if (state == CallState.kConnected) {
      _stopCallSound();
      if (kDebugMode) _startStatsPolling();
    }

    // The data-sharing window is only open while the call is pre-answer.
    // Once the caller answers, hangs up, or the call ends, drop any pending
    // prompts and dismiss the sheet — the callee will time out.
    if (!_inDataSharingWindow(state)) {
      _abortDataSharingPrompts();
    }

    if (mounted) {
      setState(() {
        _state = state;
        if (_state == CallState.kEnded) cleanUp();
      });
    }
  }

  Future<int?> _findContactRequestId() async {
    // Try the DB — works whether or not the room's timeline was opened in UI.
    final events = await widget.client.database.getEventList(
      call.room,
      limit: 30,
    );
    for (final event in events) {
      if (event.type == 'com.trustwork.contact_request') {
        return event.content.tryGet<int>('request_id');
      }
    }
    return null;
  }

  Future<void> _acceptContactRequestInBackground(int requestId) async {
    try {
      await TrustworkApiService.instance.acceptContactRequest(requestId);
      if (!mounted) return;
      final matrix = Matrix.of(context);
      unawaited(matrix.contactsCache.refresh(matrix.store));
      unawaited(matrix.refreshIncomingRequestCount());
      final callerId = call.room
          .getParticipants()
          .where((m) => m.id != widget.client.userID)
          .firstOrNull
          ?.id;
      if (callerId != null) {
        unawaited(call.room.addToDirectChat(callerId));
      }
      unawaited(
        call.room
            .sendEvent({}, type: 'com.trustwork.contact_accepted')
            .catchError((_) => ''),
      );
    } on DioException catch (e) {
      Logs().w('[CALL-CONNECT] acceptContactRequest($requestId) failed: '
          '${TrustworkApiService.friendlyError(e)}');
    } catch (e) {
      Logs().w('[CALL-CONNECT] acceptContactRequest($requestId) failed: $e');
    }
  }

  void _answerCall() {
    if (_answerPressed) return;
    setState(() => _answerPressed = true);
    _stopCallSound();
    UserMediaManager().stopRingingTone();
    unawaited(RingerVibration.stop());
    // Notify the VoIP plugin so it can start the microphone-type foreground
    // service. Doing this here (on user interaction) avoids the Android 14+
    // FOREGROUND_SERVICE_MICROPHONE SecurityException that fires when the
    // service is started while the call is still ringing in the background.
    final voipPlugin = Matrix.of(context).voipPlugin;
    if (voipPlugin != null) {
      unawaited(voipPlugin.onCallAnswered());
    }
    // If answering in a locked contact-request delivery room, also accept the
    // contact request so the room unlocks and both sides become contacts.
    // Only fires on the callee side (_isOutgoing == false).
    if (!_isOutgoing) {
      unawaited(_findAndAcceptContactRequest());
    }
    // Route through the plugin's answer funnel so this can't race the callkit
    // notification action into a second answer() on the same call.
    final answerFuture =
        voipPlugin != null ? voipPlugin.answerCall(call) : call.answer();
    unawaited(
      answerFuture.catchError(
        (Object e, StackTrace s) => Logs().e('[VOIP] call.answer() failed', e, s),
      ),
    );
  }

  Future<void> _findAndAcceptContactRequest() async {
    final requestId = await _findContactRequestId();
    if (requestId != null) {
      await _acceptContactRequestInBackground(requestId);
    }
  }

  void _hangUp() {
    _stopCallSound();
    UserMediaManager().stopRingingTone();
    unawaited(RingerVibration.stop());
    final future = call.isRinging
        ? call.reject()
        : call.hangup(reason: CallErrorCode.userHangup);
    unawaited(
      future.catchError(
        (Object e, StackTrace s) => Logs().e('[VOIP] _hangUp() failed', e, s),
      ),
    );
  }

  void _muteMic() {
    setState(() {
      call.setMicrophoneMuted(!call.isMicrophoneMuted);
    });
  }

  void _muteCamera() {
    setState(() {
      call.setLocalVideoMuted(!call.isLocalVideoMuted);
    });
  }

  void _switchCamera() async {
    if (call.localUserMediaStream != null) {
      await Helper.switchCamera(
        call.localUserMediaStream!.stream!.getVideoTracks().first,
      );
    }
    setState(() {});
  }

  void _switchSpeaker() {
    setState(() {
      _speakerOn = !_speakerOn;
      Helper.setSpeakerphoneOn(_speakerOn);
    });
  }

  List<Widget> _buildActionButtons(bool isFloating) {
    if (isFloating) {
      return [];
    }

    final switchCameraButton = FloatingActionButton(
      heroTag: 'switchCamera',
      onPressed: _switchCamera,
      backgroundColor: Colors.black45,
      child: const Icon(Icons.switch_camera),
    );
    final switchSpeakerButton = FloatingActionButton(
      heroTag: 'switchSpeaker',
      onPressed: _switchSpeaker,
      foregroundColor: _speakerOn ? Colors.black26 : Colors.white,
      backgroundColor: _speakerOn ? Colors.white : Colors.black45,
      child: Icon(_speakerOn ? Icons.volume_up : Icons.volume_off),
    );
    final hangupButton = FloatingActionButton(
      heroTag: 'hangup',
      onPressed: _hangUp,
      tooltip: 'Hangup',
      backgroundColor: _state == CallState.kEnded ? Colors.black45 : Colors.red,
      child: const Icon(Icons.call_end),
    );

    final answerButton = FloatingActionButton(
      heroTag: 'answer',
      onPressed: _answerPressed ? null : _answerCall,
      tooltip: 'Answer',
      backgroundColor: Colors.green,
      child: const Icon(Icons.phone),
    );

    final l10n = L10n.of(widget.context);
    final canRequestInfo = call.room.directChatMatrixID != null;
    final requestInfoButton = TextButton.icon(
      onPressed: _showRequestInfoSheet,
      style: TextButton.styleFrom(
        backgroundColor: Colors.black45,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: const StadiumBorder(),
      ),
      icon: const Icon(Icons.info_outline, size: 18),
      label: Text(l10n.dataSharingRequestInfo),
    );

    final muteMicButton = FloatingActionButton(
      heroTag: 'muteMic',
      onPressed: _muteMic,
      foregroundColor: isMicrophoneMuted ? Colors.black26 : Colors.white,
      backgroundColor: isMicrophoneMuted ? Colors.white : Colors.black45,
      child: Icon(isMicrophoneMuted ? Icons.mic_off : Icons.mic),
    );

    final muteCameraButton = FloatingActionButton(
      heroTag: 'muteCam',
      onPressed: _muteCamera,
      foregroundColor: isLocalVideoMuted ? Colors.black26 : Colors.white,
      backgroundColor: isLocalVideoMuted ? Colors.white : Colors.black45,
      child: Icon(isLocalVideoMuted ? Icons.videocam_off : Icons.videocam),
    );

    switch (_state) {
      case CallState.kRinging:
        return _isOutgoing
            ? <Widget>[muteMicButton, switchSpeakerButton, hangupButton]
            : <Widget>[
                hangupButton,
                if (canRequestInfo) requestInfoButton,
                answerButton,
              ];
      case CallState.kInviteSent:
      case CallState.kCreateAnswer:
      case CallState.kConnecting:
        // answer() was already called — don't show the answer button again.
        return <Widget>[hangupButton];
      case CallState.kConnected:
        return <Widget>[
          muteMicButton,
          switchSpeakerButton,
          if (!voiceonly && !kIsWeb) switchCameraButton,
          if (!voiceonly) muteCameraButton,
          hangupButton,
        ];
      case CallState.kEnded:
        return <Widget>[hangupButton];
      case CallState.kFledgling:
      case CallState.kWaitLocalMedia:
      case CallState.kCreateOffer:
      case CallState.kEnding:
      case null:
        break;
    }
    return <Widget>[];
  }

  List<Widget> _buildContent(Orientation orientation, bool isFloating) {
    final stackWidgets = <Widget>[];

    final call = this.call;
    if (call.callHasEnded) {
      return stackWidgets;
    }

    if (call.localHold || call.remoteOnHold) {
      var title = '';
      if (call.localHold) {
        title = '$displayName held the call.';
      } else if (call.remoteOnHold) {
        title = 'You held the call.';
      }
      stackWidgets.add(
        Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(Icons.pause, size: 48.0, color: Colors.white),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 24.0),
              ),
            ],
          ),
        ),
      );
      return stackWidgets;
    }

    var primaryStream =
        call.remoteScreenSharingStream ??
        call.localScreenSharingStream ??
        call.remoteUserMediaStream ??
        call.localUserMediaStream;

    if (!connected) {
      primaryStream = call.localUserMediaStream;
    }

    if (primaryStream != null) {
      stackWidgets.add(
        Center(
          child: _StreamView(
            primaryStream,
            mainView: true,
            matrixClient: widget.client,
          ),
        ),
      );
    }

    if (isFloating || !connected) {
      return stackWidgets;
    }

    _resizeLocalVideo(orientation);

    if (call.getRemoteStreams.isEmpty) {
      return stackWidgets;
    }

    final secondaryStreamViews = <Widget>[];

    if (call.remoteScreenSharingStream != null) {
      final remoteUserMediaStream = call.remoteUserMediaStream;
      secondaryStreamViews.add(
        SizedBox(
          width: _localVideoWidth,
          height: _localVideoHeight,
          child: _StreamView(
            remoteUserMediaStream!,
            matrixClient: widget.client,
          ),
        ),
      );
      secondaryStreamViews.add(const SizedBox(height: 10));
    }

    final localStream =
        call.localUserMediaStream ?? call.localScreenSharingStream;
    if (localStream != null && !isFloating) {
      secondaryStreamViews.add(
        SizedBox(
          width: _localVideoWidth,
          height: _localVideoHeight,
          child: _StreamView(localStream, matrixClient: widget.client),
        ),
      );
      secondaryStreamViews.add(const SizedBox(height: 10));
    }

    if (call.localScreenSharingStream != null && !isFloating) {
      secondaryStreamViews.add(
        SizedBox(
          width: _localVideoWidth,
          height: _localVideoHeight,
          child: _StreamView(
            call.remoteUserMediaStream!,
            matrixClient: widget.client,
          ),
        ),
      );
      secondaryStreamViews.add(const SizedBox(height: 10));
    }

    if (secondaryStreamViews.isNotEmpty) {
      stackWidgets.add(
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 120),
          alignment: Alignment.bottomRight,
          child: Container(
            width: _localVideoWidth,
            margin: _localVideoMargin,
            child: Column(children: secondaryStreamViews),
          ),
        ),
      );
    }

    return stackWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) => PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (_, _, _) => _buildCallScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _buildProactiveShareCard(SharedData data) {
    final l10n = L10n.of(context);
    final rows = <Widget>[];
    for (final f in ShareableField.values) {
      final value = f.formatValue(data, l10n);
      if (value == null) continue;
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  f.label(l10n),
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }

  Widget _buildCallScreen() {
    return PIPView(
      builder: (context, isFloating) {
        return Scaffold(
          resizeToAvoidBottomInset: !isFloating,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: SizedBox(
            width: 320.0,
            height: 150.0,
            child: Row(
              mainAxisAlignment: .spaceAround,
              children: _buildActionButtons(isFloating),
            ),
          ),
          body: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Container(
                decoration: const BoxDecoration(color: Colors.black87),
                child: Stack(
                  children: [
                    ..._buildContent(orientation, isFloating),
                    if (!isFloating && _proactiveShareData != null)
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 200,
                        child: _buildProactiveShareCard(_proactiveShareData!),
                      ),
                    if (!isFloating)
                      Positioned(
                        top: 24.0,
                        left: 24.0,
                        child: IconButton(
                          color: Colors.black45,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            PIPView.of(context)?.setFloating(true);
                          },
                        ),
                      ),
                    if (!isFloating && kDebugMode && _callStats != null)
                      Positioned(
                        top: 24.0,
                        right: 12.0,
                        child: _StatsOverlay(stats: _callStats!),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

sealed class _CalleeFlowState {
  const _CalleeFlowState();
}

final class _CalleePicking extends _CalleeFlowState {
  const _CalleePicking();
}

final class _CalleeWaiting extends _CalleeFlowState {
  const _CalleeWaiting();
}

final class _CalleeShowing extends _CalleeFlowState {
  const _CalleeShowing(this.fields, this.data);
  final List<ShareableField> fields;
  final SharedData data;
}

final class _CalleeErrored extends _CalleeFlowState {
  const _CalleeErrored(this.message);
  final String message;
}

class _DataSharingRequestSheet extends StatefulWidget {
  const _DataSharingRequestSheet({
    required this.callerDisplayName,
    required this.callerMatrixId,
    this.service,
  });

  final String callerDisplayName;
  final String callerMatrixId;
  final DataSharingService? service;

  @override
  State<_DataSharingRequestSheet> createState() =>
      _DataSharingRequestSheetState();
}

class _DataSharingRequestSheetState extends State<_DataSharingRequestSheet> {
  final Map<ShareableField, bool> _selected = {
    for (final f in ShareableField.values) f: false,
  };
  late _CalleeFlowState _flow = const _CalleePicking();

  Set<ShareableField> _selectedFields() => _selected.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toSet();

  Future<void> _send() async {
    final service = widget.service;
    if (service == null) return;
    final selected = _selectedFields();
    if (selected.isEmpty) return;
    setState(() => _flow = const _CalleeWaiting());

    final outcome = await service.request(
      callerMatrixId: widget.callerMatrixId,
      fields: selected,
    );
    if (!mounted) return;
    _handleOutcome(outcome, selected);
  }

  void _handleOutcome(DataSharingOutcome outcome, Set<ShareableField> fields) {
    if (!mounted) return;
    final l10n = L10n.of(context);
    switch (outcome) {
      case DataSharingApproved(:final data):
        final ordered = fields.toList()
          ..sort((a, b) => a.index.compareTo(b.index));
        setState(() => _flow = _CalleeShowing(ordered, data));
        return;
      case DataSharingDeclined():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataSharingDeclined)),
        );
        Navigator.of(context).pop();
        return;
      case DataSharingTimedOut():
        setState(() => _flow = _CalleeErrored(l10n.dataSharingTimedOut));
        return;
      case DataSharingErrored():
        setState(() => _flow = _CalleeErrored(l10n.dataSharingErrored));
        return;
    }
  }

  void _close() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: switch (_flow) {
                _CalleePicking() => _buildPicker(),
                _CalleeWaiting() => _buildWaiting(),
                _CalleeShowing(:final fields, :final data) =>
                  _buildShowing(fields, data),
                _CalleeErrored(:final message) => _buildErrored(message),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker() {
    final l10n = L10n.of(context);
    const fields = ShareableField.values;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.dataSharingPickerTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.dataSharingPickerSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final f in fields)
                CheckboxListTile(
                  value: _selected[f] ?? false,
                  onChanged: (v) =>
                      setState(() => _selected[f] = v ?? false),
                  title: Text(f.label(l10n)),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _close,
                  child: Text(l10n.dataSharingCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: (_selectedFields().isEmpty || widget.service == null)
                      ? null
                      : _send,
                  child: Text(l10n.dataSharingSendRequest),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaiting() {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dataSharingWaitingTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dataSharingWaitingSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShowing(List<ShareableField> fields, SharedData data) {
    final l10n = L10n.of(context);
    final rows = <Widget>[];
    for (final f in fields) {
      final value = f.formatValue(data, l10n);
      if (value == null) continue;
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  f.label(l10n),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.dataSharingResultTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: rows.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Text(
                    l10n.dataSharingNoData,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(shrinkWrap: true, children: rows),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _close,
              child: Text(l10n.dataSharingClose),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrored(String message) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 36,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _close,
              child: Text(l10n.dataSharingClose),
            ),
          ),
        ],
      ),
    );
  }
}
