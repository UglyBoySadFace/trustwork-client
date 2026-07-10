import 'dart:async';

import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/data_sharing/data_sharing_approval_sheet.dart';
import 'package:fluffychat/utils/data_sharing/data_sharing_service.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/data_sharing/sharing_preferences_cache.dart';
import 'package:fluffychat/widgets/matrix.dart';

class DataRequestBubble extends StatefulWidget {
  final Event event;

  const DataRequestBubble({required this.event, super.key});

  @override
  State<DataRequestBubble> createState() => _DataRequestBubbleState();
}

class _DataRequestBubbleState extends State<DataRequestBubble> {
  // The room-event sender is the one who asked for info (the "receiver" of the
  // contact request). The current user is the "requester" if they are NOT the
  // sender of this room event.
  bool get _isSender =>
      widget.event.senderId == widget.event.room.client.userID;

  // Requester side: pending request from the other party.
  IncomingDataRequest? _pendingRequest;
  StreamSubscription<IncomingDataRequest>? _incomingSub;
  bool _busy = false;

  // Sender side: approved data received from the requester.
  SharedData? _receivedData;
  StreamSubscription<ProactiveShareData>? _approvalSub;

  String? get _otherParticipantId => widget.event.room
      .getParticipants()
      .where((m) => m.id != widget.event.room.client.userID)
      .map((m) => m.id)
      .firstOrNull;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = Matrix.of(context).dataSharingService;
    if (service == null) return;

    if (_isSender) {
      _setupSenderSide(service);
    } else {
      _setupRequesterSide(service);
    }
  }

  void _setupSenderSide(DataSharingService service) {
    if (_approvalSub != null) return;
    final buffered = service.lastRequestApproval;
    if (buffered != null && buffered.fromMatrixId == _otherParticipantId) {
      _receivedData = buffered.data;
      service.clearLastRequestApproval();
    }
    _approvalSub = service.requestApprovals.listen((share) {
      if (!mounted || share.fromMatrixId != _otherParticipantId) return;
      service.clearLastRequestApproval();
      setState(() => _receivedData = share.data);
    });
  }

  void _setupRequesterSide(DataSharingService service) {
    if (_incomingSub != null) return;
    final buffered = service.lastIncomingRequest;
    if (buffered != null && _isForThisRoom(buffered)) {
      _pendingRequest = buffered;
    }
    _incomingSub = service.incomingRequests.listen((req) {
      if (!mounted || !_isForThisRoom(req)) return;
      setState(() => _pendingRequest = req);
    });
  }

  bool _isForThisRoom(IncomingDataRequest req) =>
      req.fromMatrixId == widget.event.senderId;

  @override
  void dispose() {
    _incomingSub?.cancel();
    _approvalSub?.cancel();
    super.dispose();
  }

  Future<void> _openShareSheet() async {
    final req = _pendingRequest;
    if (req == null || _busy) return;
    final service = Matrix.of(context).dataSharingService;
    if (service == null) return;
    service.clearLastIncomingRequest();
    setState(() => _pendingRequest = null);
    final prefs = SharingPreferencesCache.read(Matrix.of(context).store);
    final defaults = <ShareableField, bool>{
      for (final f in req.fields) f: prefs?[f] ?? false,
    };
    final fromName =
        Matrix.of(context).contactsCache.label(req.fromMatrixId);
    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DataSharingApprovalSheet(
        requesterDisplayName: fromName,
        fields: req.fields.toList()
          ..sort((a, b) => a.index.compareTo(b.index)),
        defaults: defaults,
        onShare: (selected) async {
          try {
            await service.approve(request: req, approvedFields: selected);
            return null;
          } catch (e) {
            return e.toString();
          }
        },
        onDecline: () => service.decline(req),
      ),
    );
  }

  Future<void> _decline() async {
    final req = _pendingRequest;
    if (req == null || _busy) return;
    final service = Matrix.of(context).dataSharingService;
    if (service == null) return;
    setState(() => _busy = true);
    service.clearLastIncomingRequest();
    await service.decline(req);
    if (!mounted) return;
    setState(() {
      _pendingRequest = null;
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final fromName =
        Matrix.of(context).contactsCache.label(widget.event.senderId);

    if (_isSender) {
      final data = _receivedData;
      if (data != null) return _buildReceivedData(data, l10n);
      return _buildLabel(l10n.dataRequestSentWaiting);
    }

    if (_pendingRequest != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelRow(l10n.dataRequestReceived(fromName)),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: _busy ? null : _decline,
                  child: Text(l10n.dataSharingDecline),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _busy ? null : _openShareSheet,
                  child: _busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.dataSharingShare),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return _buildLabel(l10n.dataRequestReceived(fromName));
  }

  Widget _buildReceivedData(SharedData data, L10n l10n) {
    final rows = ShareableField.values
        .map((f) => (f, f.formatValue(data, l10n)))
        .where((pair) => pair.$2 != null)
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelRow(l10n.dataSharingResultTitle),
          for (final (field, value) in rows)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 2),
              child: Text(
                '${field.label(l10n)}: $value',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: _buildLabelRow(text),
  );

  Widget _buildLabelRow(String text) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.info_outline, size: 16),
      const SizedBox(width: 8),
      Flexible(
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      ),
    ],
  );
}
