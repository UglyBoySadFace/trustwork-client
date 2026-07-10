import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/contact_requests/contact_request_data_sheet.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

const _eventTypeAccepted = 'com.trustwork.contact_accepted';

class ContactRequestBubble extends StatefulWidget {
  final Event event;

  const ContactRequestBubble({required this.event, super.key});

  @override
  State<ContactRequestBubble> createState() => _ContactRequestBubbleState();
}

class _ContactRequestBubbleState extends State<ContactRequestBubble> {
  bool _loading = false;
  bool _loadingSheet = false;
  String? _resolvedStatus;
  bool _accepted = false;
  StreamSubscription<Event>? _acceptanceSub;

  bool get _isSender =>
      widget.event.senderId == widget.event.room.client.userID;

  int? get _requestId => widget.event.content.tryGet<int>('request_id');

  String get _requesterDisplayName =>
      widget.event.content.tryGet<String>('requester_display_name') ??
      widget.event.content.tryGet<String>('requester_matrix_id') ??
      'Unknown';

  String get _targetMatrixId =>
      widget.event.content.tryGet<String>('target_matrix_id') ?? '';

  String? get _initialMessage =>
      widget.event.content.tryGet<String>('initial_message');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isSender && !_accepted) {
      _accepted = Matrix.of(context)
          .contactsCache
          .isContact(_targetMatrixId);
    }
    if (_acceptanceSub != null) return;
    _acceptanceSub = widget.event.room.client.onTimelineEvent.stream
        .where(
          (e) =>
              e.roomId == widget.event.room.id &&
              e.type == _eventTypeAccepted,
        )
        .listen((_) {
          if (!mounted) return;
          setState(() => _accepted = true);
        });
  }

  @override
  void dispose() {
    _acceptanceSub?.cancel();
    super.dispose();
  }

  Future<void> _act(String outcome, Future<void> Function() call) async {
    setState(() => _loading = true);
    try {
      await call();
      if (!mounted) return;
      setState(() => _resolvedStatus = outcome);
      unawaited(Matrix.of(context).refreshIncomingRequestCount());
      if (outcome == 'accepted') {
        unawaited(
          Matrix.of(context)
              .contactsCache
              .refresh(Matrix.of(context).store),
        );
        // Mark as a DM so the call button and other DM affordances appear.
        unawaited(
          widget.event.room.addToDirectChat(widget.event.senderId),
        );
        // Notify the requester's side via a room event (fire-and-forget;
        // may fail silently if the room has restricted power levels).
        unawaited(
          widget.event.room
              .sendEvent({}, type: _eventTypeAccepted)
              .catchError((_) => ''),
        );
      }
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TrustworkApiService.friendlyError(e))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _requestMoreInfo() async {
    final id = _requestId;
    if (id == null) return;
    setState(() => _loadingSheet = true);
    try {
      final requests =
          await TrustworkApiService.instance.getIncomingContactRequests();
      final request = requests.where((r) => r.id == id).firstOrNull;
      if (!mounted) return;
      if (request == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request not found')),
        );
        return;
      }
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => ContactRequestDataSheet(
          requesterDisplayName: _requesterDisplayName,
          requesterMatrixId: widget.event.senderId,
          sharingPreferences: request.requesterSharingPreferences,
          room: widget.event.room,
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TrustworkApiService.friendlyError(e))),
      );
    } finally {
      if (mounted) setState(() => _loadingSheet = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = _requestId;
    final resolved = _resolvedStatus;
    final theme = Theme.of(context);

    Widget body;

    if (_isSender) {
      body = Text(
        _accepted
            ? L10n.of(context).connectionRequestAccepted
            : 'Waiting for $_targetMatrixId to respond.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: _accepted ? theme.colorScheme.primary : null,
        ),
      );
    } else if (resolved != null) {
      final label = switch (resolved) {
        'accepted' => 'You accepted this request.',
        'declined' => 'You declined this request.',
        _ => 'You blocked this requester.',
      };
      body = Text(
        label,
        style: theme.textTheme.bodySmall
            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      );
    } else if (id == null) {
      body = const Text('Invalid contact request event.');
    } else if (_loading) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else {
      body = Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          FilledButton(
            onPressed: () => _act(
              'accepted',
              () => TrustworkApiService.instance.acceptContactRequest(id),
            ),
            child: const Text('Accept'),
          ),
          OutlinedButton(
            onPressed: () => _act(
              'declined',
              () => TrustworkApiService.instance.declineContactRequest(id),
            ),
            child: const Text('Decline'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () => _act(
              'blocked',
              () => TrustworkApiService.instance.blockContactRequest(id),
            ),
            child: const Text('Block'),
          ),
          _loadingSheet
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                )
              : TextButton.icon(
                  onPressed: _requestMoreInfo,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Request more info'),
                ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_add_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isSender
                          ? 'Connection request sent'
                          : '$_requesterDisplayName wants to connect',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              if (!_isSender && _initialMessage != null && _initialMessage!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _initialMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
