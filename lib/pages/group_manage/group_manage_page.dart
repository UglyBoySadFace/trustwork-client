import 'dart:async';

import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Member management for a Trustwork group: member list with names from the
/// middleware (Matrix profiles are blank), admin add/remove actions, and a
/// leave-group action for everyone.
class GroupManagePage extends StatefulWidget {
  final String roomId;

  const GroupManagePage({required this.roomId, super.key});

  @override
  State<GroupManagePage> createState() => _GroupManagePageState();
}

class _GroupManagePageState extends State<GroupManagePage> {
  GroupDetail? detail;
  bool busy = false;
  String? error;
  int? _groupId;
  List<MemberSuggestion> pendingSuggestions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// The room is not a known Trustwork group — shouldn't happen with correct
  /// routing. Resolved to a localized error in build (L10n is unavailable in
  /// initState).
  bool _groupMissing = false;

  Future<void> _load() async {
    final group = GroupsService.instance.findByMatrixRoomId(widget.roomId);
    if (group == null) {
      setState(() => _groupMissing = true);
      return;
    }
    _groupId = group.id;
    await _reload();
  }

  Future<void> _reload() async {
    final groupId = _groupId;
    if (groupId == null) return;
    try {
      final result = await TrustworkApiService.instance.getGroupDetail(
        groupId,
      );
      if (!mounted) return;
      var suggestions = <MemberSuggestion>[];
      if (result.admin.matrixUserId == Matrix.of(context).client.userID) {
        try {
          final fetched = await TrustworkApiService.instance.listSuggestions(
            groupId,
          );
          suggestions = fetched
              .where((s) => s.status == 'pending')
              .toList();
        } on DioException catch (_) {
          // Suggestions are secondary — don't block the member list on them.
        }
      }
      if (!mounted) return;
      setState(() {
        detail = result;
        pendingSuggestions = suggestions;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 403) {
        // Not (or no longer) a member — nothing to manage here.
        context.go('/rooms');
        return;
      }
      setState(() => error = TrustworkApiService.friendlyError(e));
    }
  }

  bool get _isAdmin =>
      detail?.admin.matrixUserId == Matrix.of(context).client.userID;

  String _memberLabel(GroupMember member) => member.displayName.isEmpty
      ? (member.matrixUserId ?? '<unknown>')
      : member.displayName;

  Future<void> _removeMember(GroupMember member) async {
    final groupId = _groupId;
    final mxid = member.matrixUserId;
    if (groupId == null || mxid == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L10n.of(context).remove),
        content: Text(
          L10n.of(context).removeMemberConfirmation(_memberLabel(member)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(L10n.of(context).cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(L10n.of(context).remove),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await TrustworkApiService.instance.removeMember(groupId, mxid);
      unawaited(GroupsService.instance.refresh().catchError((_) {}));
      await _reload();
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => error = TrustworkApiService.friendlyError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _addMember() async {
    final groupId = _groupId;
    final detail = this.detail;
    if (groupId == null || detail == null) return;
    final memberIds = detail.members
        .map((m) => m.matrixUserId)
        .whereType<String>()
        .toSet();
    final candidates =
        Matrix.of(context)
            .contactsCache
            .entries
            .where((c) => !memberIds.contains(c.key))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: candidates.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(L10n.of(ctx).noContactsToAdd),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      L10n.of(ctx).addGroupMember,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (final contact in candidates)
                    ListTile(
                      title: Text(contact.value),
                      subtitle: Text(contact.key),
                      onTap: () => Navigator.of(ctx).pop(contact.key),
                    ),
                ],
              ),
      ),
    );
    if (selected == null || !mounted) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await TrustworkApiService.instance.addMember(groupId, selected);
      unawaited(GroupsService.instance.refresh().catchError((_) {}));
      await _reload();
    } on DioException catch (e) {
      if (!mounted) return;
      setState(
        () => error = e.response?.statusCode == 403
            ? L10n.of(context).notInYourContacts
            : TrustworkApiService.friendlyError(e),
      );
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _showSuggestSheet() async {
    final groupId = _groupId;
    final detail = this.detail;
    if (groupId == null || detail == null) return;
    final memberIds = detail.members
        .map((m) => m.matrixUserId)
        .whereType<String>()
        .toSet();
    final candidates =
        Matrix.of(context)
            .contactsCache
            .entries
            .where((c) => !memberIds.contains(c.key))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));
    final messageController = TextEditingController();
    String? selectedMxid;
    String? sheetError;
    var submitting = false;
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SafeArea(
            child: candidates.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(L10n.of(ctx).noContactsToAdd),
                  )
                : Column(
                    mainAxisSize: .min,
                    children: [
                      ListTile(
                        title: Text(
                          L10n.of(ctx).suggestAMember,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (final contact in candidates)
                              ListTile(
                                title: Text(contact.value),
                                subtitle: Text(contact.key),
                                selected: selectedMxid == contact.key,
                                trailing: selectedMxid == contact.key
                                    ? const Icon(Icons.check_circle_outlined)
                                    : null,
                                onTap: submitting
                                    ? null
                                    : () => setSheetState(
                                        () => selectedMxid = contact.key,
                                      ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: TextField(
                          controller: messageController,
                          readOnly: submitting,
                          decoration: InputDecoration(
                            labelText: L10n.of(ctx).suggestionMessageHint,
                          ),
                        ),
                      ),
                      if (sheetError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Text(
                            sheetError!,
                            style: TextStyle(
                              color: Theme.of(ctx).colorScheme.error,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: selectedMxid == null || submitting
                                ? null
                                : () async {
                                    setSheetState(() {
                                      submitting = true;
                                      sheetError = null;
                                    });
                                    try {
                                      final message = messageController.text
                                          .trim();
                                      await TrustworkApiService.instance
                                          .suggestMember(
                                            groupId,
                                            selectedMxid!,
                                            message: message.isEmpty
                                                ? null
                                                : message,
                                          );
                                      if (ctx.mounted) {
                                        Navigator.of(ctx).pop(true);
                                      }
                                    } on DioException catch (e) {
                                      setSheetState(() {
                                        submitting = false;
                                        sheetError =
                                            TrustworkApiService.friendlyError(
                                              e,
                                            );
                                      });
                                    }
                                  },
                            child: submitting
                                ? const LinearProgressIndicator()
                                : Text(L10n.of(ctx).suggest),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).suggestionSent)),
      );
    }
  }

  Future<void> _leaveGroup() async {
    final groupId = _groupId;
    if (groupId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L10n.of(context).leaveGroup),
        content: Text(L10n.of(context).leaveGroupConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(L10n.of(context).cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(L10n.of(context).leave),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await TrustworkApiService.instance.leaveGroup(groupId);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = this.detail;
    final error = _groupMissing
        ? L10n.of(context).oopsSomethingWentWrong
        : this.error;
    final visibleMembers = detail?.members
        .where((m) => m.status == 'joined' || m.status == 'invited')
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(detail?.name ?? L10n.of(context).manageGroup),
      ),
      body: detail == null || visibleMembers == null
          ? Center(
              child: error == null
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
            )
          : ListView(
              children: [
                if (error != null)
                  ListTile(
                    leading: Icon(
                      Icons.warning_outlined,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ListTile(
                  title: Text(
                    L10n.of(context).countParticipants(visibleMembers.length),
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                for (final member in visibleMembers)
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        _memberLabel(member).characters.first.toUpperCase(),
                      ),
                    ),
                    title: Text(_memberLabel(member)),
                    subtitle: Text(
                      member.isAdmin == true
                          ? L10n.of(context).admin
                          : member.status,
                    ),
                    trailing: _isAdmin && member.isAdmin != true
                        ? IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: busy
                                ? null
                                : () => _removeMember(member),
                          )
                        : null,
                  ),
                if (_isAdmin) ...[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.add_outlined),
                    ),
                    title: Text(L10n.of(context).addGroupMember),
                    onTap: busy ? null : _addMember,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.how_to_vote_outlined),
                    ),
                    title: Text(L10n.of(context).memberSuggestions),
                    trailing: pendingSuggestions.isEmpty
                        ? const Icon(Icons.chevron_right_outlined)
                        : Badge(
                            label: Text('${pendingSuggestions.length}'),
                          ),
                    onTap: busy
                        ? null
                        : () => context.go(
                            '/rooms/${widget.roomId}/group-suggestions',
                          ),
                  ),
                ] else if (detail.myStatus == 'joined')
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      child: const Icon(Icons.person_add_outlined),
                    ),
                    title: Text(L10n.of(context).suggestAMember),
                    onTap: busy ? null : _showSuggestSheet,
                  ),
                Divider(color: theme.dividerColor),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.errorContainer,
                    foregroundColor: theme.colorScheme.onErrorContainer,
                    child: const Icon(Icons.logout_outlined),
                  ),
                  title: Text(
                    L10n.of(context).leaveGroup,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: busy ? null : _leaveGroup,
                ),
              ],
            ),
    );
  }
}
