import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Card for the `com.trustwork.suggestion_created` timeline event, posted by
/// the suggester into their existing DM with the group admin (or a fresh
/// locked room, if they aren't yet in contact) when they suggest a new
/// member for a Trustwork group.
///
/// Like [GroupInviteBubble]'s `com.trustwork.group_invite`, the event content
/// is a frozen snapshot at creation time (`status` stays `"pending"`
/// forever) — acting on the suggestion (invite/dismiss) happens on
/// `GroupSuggestionsPage`, not here. `suggested_display_name` is omitted by
/// the backend when the admin doesn't already know that person, to avoid
/// leaking a stranger's identity into a push notification — fall back to the
/// generic "this person" copy in that case, same as GroupSuggestionsPage.
class SuggestionCreatedBubble extends StatelessWidget {
  final Event event;

  const SuggestionCreatedBubble({required this.event, super.key});

  int? get _groupId => event.content.tryGet<int>('group_id');

  String get _groupName => event.content.tryGet<String>('group_name') ?? '';

  String get _suggesterDisplayName =>
      event.content.tryGet<String>('suggester_display_name') ?? '';

  String? get _suggestedDisplayName =>
      event.content.tryGet<String>('suggested_display_name');

  String? get _message {
    final message = event.content.tryGet<String>('message');
    if (message == null || message.trim().isEmpty) return null;
    return message;
  }

  bool get _isSender => event.senderId == event.room.client.userID;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);
    final groupId = _groupId;

    Widget content;
    if (groupId == null) {
      content = Text(
        l10n.userSentUnknownEvent(
          Matrix.of(context).contactsCache.label(event.senderId),
          event.type,
        ),
      );
    } else if (_isSender) {
      final suggested = _suggestedDisplayName;
      content = Row(
        children: [
          const Icon(Icons.person_add_alt_outlined),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              suggested != null
                  ? l10n.suggestionCardSentTo(suggested, _groupName)
                  : l10n.suggestionCardSentToUnknown(_groupName),
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      );
    } else {
      final suggested = _suggestedDisplayName;
      final body = suggested != null
          ? l10n.suggestionBodyKnown(
              _suggesterDisplayName,
              suggested,
              _groupName,
            )
          : l10n.suggestionBodyUnknown(_suggesterDisplayName, _groupName);
      final message = _message;
      final roomId = GroupsService.instance.findById(groupId)?.matrixRoomId;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.person_add_alt_outlined),
              const SizedBox(width: 8),
              Expanded(child: Text(body, style: theme.textTheme.titleSmall)),
            ],
          ),
          if (message != null) ...[
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
                    l10n.suggestionWrites(_suggesterDisplayName, message),
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
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: roomId == null
                  ? null
                  : () => context.go('/rooms/$roomId/group-suggestions'),
              child: Text(l10n.viewSuggestion),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        child: Padding(padding: const EdgeInsets.all(16), child: content),
      ),
    );
  }
}
