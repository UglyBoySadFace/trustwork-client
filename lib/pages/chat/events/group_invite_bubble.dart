import 'dart:async';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Follow-up event stamped into the room by [GroupInvitePage] when the
/// invitee joins or declines. Its own originServerTs is the decision
/// timestamp — [GroupSummary.myStatus] (the other source of truth for
/// [GroupInviteBubble]'s resolved label) carries no timestamp at all.
const groupInviteDecisionEventType = 'com.trustwork.group_invite_decision';

/// Card for the `com.trustwork.group_invite` timeline event, posted into
/// the pair's existing DM (or a fresh locked room for a suggest-flow
/// stranger) when an admin invites someone to a Trustwork group.
///
/// The event's own `status` field is frozen at `"invited"` forever — never
/// updated when the invite resolves — so live state always comes from
/// [GroupsService], never from the event content. The full invite prompt
/// (join/decline) lives in `GroupInvitePage`; this bubble only routes there.
class GroupInviteBubble extends StatefulWidget {
  final Event event;

  const GroupInviteBubble({required this.event, super.key});

  @override
  State<GroupInviteBubble> createState() => _GroupInviteBubbleState();
}

class _GroupInviteBubbleState extends State<GroupInviteBubble> {
  Event get event => widget.event;

  int? get _groupId => event.content.tryGet<int>('group_id');

  String get _groupName => event.content.tryGet<String>('group_name') ?? '';

  String get _adminDisplayName =>
      event.content.tryGet<String>('admin_display_name') ?? '';

  String get _inviteeMatrixId =>
      event.content.tryGet<String>('invitee_matrix_id') ?? '';

  String? get _suggestedByDisplayName =>
      event.content.containsKey('suggested_by_display_name')
      ? event.content.tryGet<String>('suggested_by_display_name')
      : null;

  bool get _isSender => event.senderId == event.room.client.userID;

  String? _decisionStatus;
  DateTime? _decisionAt;
  StreamSubscription<Event>? _decisionSub;

  @override
  void initState() {
    super.initState();
    unawaited(_scanForDecision());
    _decisionSub = event.room.client.onTimelineEvent.stream
        .where(
          (e) =>
              e.roomId == event.room.id &&
              e.type == groupInviteDecisionEventType,
        )
        .listen(_applyDecisionEvent);
  }

  @override
  void dispose() {
    _decisionSub?.cancel();
    super.dispose();
  }

  void _applyDecisionEvent(Event e) {
    final groupId = _groupId;
    if (groupId == null || e.content.tryGet<int>('group_id') != groupId) {
      return;
    }
    if (!mounted) return;
    setState(() {
      _decisionStatus = e.content.tryGet<String>('status');
      _decisionAt = e.originServerTs;
    });
  }

  // The decision event may already be sitting in the local DB from a
  // previous session (e.g. the decision was made before this bubble was ever
  // built) — scan recent history for it once on init, mirroring the
  // com.trustwork.contact_request scan in VoipPlugin._findContactRequestId.
  Future<void> _scanForDecision() async {
    final groupId = _groupId;
    if (groupId == null) return;
    final events = await event.room.client.database.getEventList(
      event.room,
      limit: 30,
    );
    for (var e in events) {
      if (e.type == EventTypes.Encrypted) {
        try {
          e =
              await event.room.client.encryption?.decryptRoomEvent(
                e,
                store: true,
              ) ??
              e;
        } catch (_) {
          continue;
        }
        if (e.type == EventTypes.Encrypted) continue;
      }
      if (e.type == groupInviteDecisionEventType &&
          e.content.tryGet<int>('group_id') == groupId) {
        if (!mounted) return;
        setState(() {
          _decisionStatus = e.content.tryGet<String>('status');
          _decisionAt = e.originServerTs;
        });
        return;
      }
    }
  }

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
      final inviteeLabel = Matrix.of(
        context,
      ).contactsCache.label(_inviteeMatrixId);
      final decisionAt = _decisionAt;
      final decisionLabel = decisionAt == null
          ? null
          : switch (_decisionStatus) {
              'joined' => l10n.groupInviteCardInviteeJoinedAt(
                inviteeLabel,
                decisionAt.localizedTime(context),
              ),
              'declined' => l10n.groupInviteCardInviteeDeclinedAt(
                inviteeLabel,
                decisionAt.localizedTime(context),
              ),
              _ => null,
            };
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.group_add_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.groupInviteCardSentTo(inviteeLabel, _groupName),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (decisionLabel != null) ...[
            const SizedBox(height: 8),
            Text(
              decisionLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );
    } else {
      final myStatus = GroupsService.instance.findById(groupId)?.myStatus;
      final decisionAt = _decisionAt;
      final resolvedLabel = switch (myStatus) {
        'joined' => decisionAt != null
            ? l10n.groupInviteCardJoinedAt(decisionAt.localizedTime(context))
            : l10n.groupInviteCardJoined,
        'declined' => decisionAt != null
            ? l10n.groupInviteCardDeclinedAt(
                decisionAt.localizedTime(context),
              )
            : l10n.groupInviteCardDeclined,
        'left' => l10n.groupInviteCardLeft,
        _ => null,
      };
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.group_add_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.groupInviteCardInvitedYou(
                    _adminDisplayName,
                    _groupName,
                  ),
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          if (_suggestedByDisplayName != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.groupInviteCardSuggestedBy(
                      _suggestedByDisplayName!,
                    ),
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
          if (resolvedLabel != null)
            Text(
              resolvedLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                onPressed: () =>
                    context.go('/rooms/group-invite/$groupId'),
                child: Text(l10n.viewInvite),
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
