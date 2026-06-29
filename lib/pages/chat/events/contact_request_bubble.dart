import 'dart:async';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ContactRequestBubble extends StatefulWidget {
  final Event event;

  const ContactRequestBubble({required this.event, super.key});

  @override
  State<ContactRequestBubble> createState() => _ContactRequestBubbleState();
}

class _ContactRequestBubbleState extends State<ContactRequestBubble> {
  bool _loading = false;
  String? _resolvedStatus;

  bool get _isSender =>
      widget.event.senderId == widget.event.room.client.userID;

  int? get _requestId => widget.event.content.tryGet<int>('request_id');

  String get _requesterDisplayName =>
      widget.event.content.tryGet<String>('requester_display_name') ??
      widget.event.content.tryGet<String>('requester_matrix_id') ??
      'Unknown';

  String get _targetMatrixId =>
      widget.event.content.tryGet<String>('target_matrix_id') ?? '';

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

  @override
  Widget build(BuildContext context) {
    final id = _requestId;
    final resolved = _resolvedStatus;
    final theme = Theme.of(context);

    Widget body;

    if (_isSender) {
      body = Text(
        'Waiting for $_targetMatrixId to respond.',
        style: theme.textTheme.bodySmall,
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
              const SizedBox(height: 12),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
