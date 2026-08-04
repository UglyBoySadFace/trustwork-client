import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart' hide VideoRenderer;

/// A snapshot of WebRTC connection quality, sampled from an [RTCPeerConnection]
/// while a call is connected. Used by the debug-only [StatsOverlay].
class CallStats {
  final double rttMs;
  final double jitterMs;
  final double packetLossPercent;
  final double audioLevel;
  final String iceType;

  const CallStats({
    required this.rttMs,
    required this.jitterMs,
    required this.packetLossPercent,
    required this.audioLevel,
    required this.iceType,
  });

  static Future<CallStats?> fromPeerConnection(
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

    return CallStats(
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

/// Debug-only overlay that renders a [CallStats] snapshot in the corner of the
/// call screen.
class StatsOverlay extends StatelessWidget {
  const StatsOverlay({required this.stats, super.key});

  final CallStats stats;

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
