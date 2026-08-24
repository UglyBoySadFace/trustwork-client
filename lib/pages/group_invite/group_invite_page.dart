import 'dart:async';

import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/events/group_invite_bubble.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Full-page prompt shown when the user opens a Matrix room that is a
/// pending Trustwork group invite. Shows who invited them (and who suggested
/// them, if anyone), how many members they don't know yet, and lets them
/// join or decline via the Trustwork API.
class GroupInvitePage extends StatefulWidget {
  final int groupId;

  const GroupInvitePage({required this.groupId, super.key});

  @override
  State<GroupInvitePage> createState() => _GroupInvitePageState();
}

class _GroupInvitePageState extends State<GroupInvitePage> {
  GroupInvitePreview? preview;
  bool busy = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    try {
      final result = await TrustworkApiService.instance.getGroupInvitePreview(
        widget.groupId,
      );
      if (!mounted) return;
      setState(() => preview = result);
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 404) {
        // Invite already acted on elsewhere — refresh and leave.
        unawaited(GroupsService.instance.refresh().catchError((_) {}));
        context.go('/rooms');
        return;
      }
      setState(() => error = TrustworkApiService.friendlyError(e));
    }
  }

  Future<void> _join() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final detail = await TrustworkApiService.instance.joinGroup(
        widget.groupId,
      );
      // Joining created contacts with every member server-side — refresh
      // groups AND contacts before entering the room so real names (instead
      // of raw Matrix IDs) show up immediately.
      await _refreshCaches();
      unawaited(_sendDecisionEvent(detail.matrixRoomId, 'joined'));
      if (!mounted) return;
      _goToRoom(detail.matrixRoomId);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Already joined — treat as success.
        await _refreshCaches();
        final roomId =
            GroupsService.instance.findById(widget.groupId)?.matrixRoomId;
        unawaited(_sendDecisionEvent(roomId, 'joined'));
        if (!mounted) return;
        _goToRoom(roomId);
        return;
      }
      if (!mounted) return;
      setState(() {
        busy = false;
        error = TrustworkApiService.friendlyError(e);
      });
    }
  }

  /// Best-effort refresh of groups + contacts (names of the new contacts
  /// created by the join). Falls back to the groups list alone when no
  /// Matrix ancestor exists (widget tests).
  ///
  /// `POST /groups/:id/join` can return before the middleware finishes
  /// writing every pairwise contact, so the immediately-following
  /// `GET /contacts` can miss some members. Retry with a short backoff until
  /// every member of the joined room resolves as a contact, so names don't
  /// render as raw Matrix IDs while that eventual-consistency window closes.
  Future<void> _refreshCaches() async {
    final matrix = mounted
        ? context.findAncestorStateOfType<MatrixState>()
        : null;
    if (matrix == null) {
      await GroupsService.instance.refresh().catchError((_) {});
      return;
    }
    await matrix.refreshContactsAndGroups().catchError((_) {});
    final roomId =
        GroupsService.instance.findById(widget.groupId)?.matrixRoomId;
    final room = roomId != null ? matrix.client.getRoomById(roomId) : null;
    if (room == null) return;
    final memberIds = room
        .getParticipants()
        .map((m) => m.id)
        .where((id) => id != matrix.client.userID)
        .toList();
    for (final delay in const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 4),
    ]) {
      if (memberIds.every(matrix.contactsCache.isContact)) return;
      await Future.delayed(delay);
      if (!mounted) return;
      await matrix.contactsCache.refresh(matrix.store).catchError((_) {});
    }
  }

  /// Stamps the decision into the room as a `com.trustwork.group_invite_decision`
  /// event so [GroupInviteBubble] can show "you joined/declined on" a date —
  /// visible to both sides, using the event's own originServerTs as the
  /// timestamp. Best-effort: a failed stamp still leaves the plain (dateless)
  /// resolved label via GroupsService.myStatus, so this never blocks the flow.
  Future<void> _sendDecisionEvent(String? roomId, String status) async {
    if (!mounted || roomId == null) return;
    final room = context.findAncestorStateOfType<MatrixState>()?.client.getRoomById(
      roomId,
    );
    if (room == null) return;
    try {
      await room.sendEvent(
        {'group_id': widget.groupId, 'status': status},
        type: groupInviteDecisionEventType,
      );
    } catch (_) {}
  }

  void _goToRoom(String? roomId) {
    if (roomId != null) {
      context.go('/rooms/$roomId');
    } else {
      context.go('/rooms');
    }
  }

  Future<void> _decline() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await TrustworkApiService.instance.declineGroup(widget.groupId);
      // Best-effort leave the underlying Matrix room too: the middleware
      // joined us into it at invite time, and there's no guarantee the
      // server retracts that membership on decline.
      final roomId = GroupsService.instance.findById(widget.groupId)?.matrixRoomId;
      final room = mounted && roomId != null
          ? context.findAncestorStateOfType<MatrixState>()?.client.getRoomById(
              roomId,
            )
          : null;
      // Stamp the decision before leaving — leaving may revoke send power.
      await _sendDecisionEvent(roomId, 'declined');
      if (room != null && room.membership != Membership.leave) {
        unawaited(room.leave().catchError((_) {}));
      }
      unawaited(GroupsService.instance.refresh().catchError((_) {}));
      if (!mounted) return;
      context.go('/rooms');
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        busy = false;
        error = TrustworkApiService.friendlyError(e);
      });
    }
  }

  String _buildBody(BuildContext context, GroupInvitePreview p) {
    final l10n = L10n.of(context);
    final suggestedBy = p.suggestedBy;
    if (suggestedBy != null) {
      return l10n.groupInviteBodySuggested(
        suggestedBy.displayName,
        p.name,
        p.admin.displayName,
        p.totalMembers,
        p.unknownCount,
      );
    }
    if (p.unknownCount == 0) {
      return l10n.groupInviteBodyAllKnown(
        p.admin.displayName,
        p.name,
        p.totalMembers,
      );
    }
    return l10n.groupInviteBodyUnknown(
      p.admin.displayName,
      p.name,
      p.totalMembers,
      p.unknownCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = this.preview;
    final error = this.error;
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).groupInvitation)),
      body: preview == null
          ? Center(
              child: error == null
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  Text(preview.name, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Text(_buildBody(context, preview)),
                  const SizedBox(height: 32),
                  if (error != null) ...[
                    Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: busy ? null : _decline,
                          child: Text(L10n.of(context).decline),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: busy ? null : _join,
                          child: busy
                              ? const LinearProgressIndicator()
                              : Text(L10n.of(context).join),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
