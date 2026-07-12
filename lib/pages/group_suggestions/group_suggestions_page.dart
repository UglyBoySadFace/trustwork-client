import 'dart:async';

import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

/// Admin-only list of pending member suggestions for a Trustwork group, with
/// invite / dismiss actions per suggestion.
class GroupSuggestionsPage extends StatefulWidget {
  final String roomId;

  const GroupSuggestionsPage({required this.roomId, super.key});

  @override
  State<GroupSuggestionsPage> createState() => _GroupSuggestionsPageState();
}

class _GroupSuggestionsPageState extends State<GroupSuggestionsPage> {
  List<MemberSuggestion>? suggestions;
  bool busy = false;
  String? error;
  int? _groupId;
  String? _groupName;

  /// The room is not a known Trustwork group — shouldn't happen with correct
  /// routing. Resolved to a localized error in build (L10n is unavailable in
  /// initState).
  bool _groupMissing = false;

  @override
  void initState() {
    super.initState();
    final group = GroupsService.instance.findByMatrixRoomId(widget.roomId);
    _groupId = group?.id;
    _groupName = group?.name;
    if (group == null) {
      _groupMissing = true;
    } else {
      _reload();
    }
  }

  Future<void> _reload() async {
    final groupId = _groupId;
    if (groupId == null) return;
    try {
      final fetched = await TrustworkApiService.instance.listSuggestions(
        groupId,
      );
      if (!mounted) return;
      setState(
        () => suggestions = fetched
            .where((s) => s.status == 'pending')
            .toList(),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() => error = TrustworkApiService.friendlyError(e));
    }
  }

  Future<void> _invite(MemberSuggestion suggestion) async {
    final groupId = _groupId;
    if (groupId == null) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await TrustworkApiService.instance.inviteSuggestion(
        groupId,
        suggestion.id,
      );
      unawaited(GroupsService.instance.refresh().catchError((_) {}));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context).invitationSent)),
      );
      await _reload();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Already handled elsewhere — just refresh.
        await _reload();
      } else if (mounted) {
        setState(() => error = TrustworkApiService.friendlyError(e));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _dismiss(MemberSuggestion suggestion) async {
    final groupId = _groupId;
    if (groupId == null) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await TrustworkApiService.instance.dismissSuggestion(
        groupId,
        suggestion.id,
      );
      await _reload();
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        await _reload();
      } else if (mounted) {
        setState(() => error = TrustworkApiService.friendlyError(e));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  String _buildBody(BuildContext context, MemberSuggestion s) {
    final l10n = L10n.of(context);
    final groupName = _groupName ?? '';
    final suggested = s.suggested;
    final parts = <String>[];
    if (s.adminKnowsSuggested && suggested != null) {
      parts.add(
        l10n.suggestionBodyKnown(
          s.suggester.displayName,
          suggested.displayName,
          groupName,
        ),
      );
    } else {
      parts.add(
        l10n.suggestionBodyUnknown(s.suggester.displayName, groupName),
      );
    }
    final message = s.message;
    if (message != null && message.trim().isNotEmpty) {
      parts.add(l10n.suggestionWrites(s.suggester.displayName, message));
    }
    if (s.adminKnowsSuggested && suggested != null) {
      parts.add(l10n.suggestionAdminMustInviteKnown(suggested.displayName));
    } else {
      parts.add(l10n.suggestionAdminMustInviteUnknown);
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = this.suggestions;
    final error = _groupMissing
        ? L10n.of(context).oopsSomethingWentWrong
        : this.error;
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).memberSuggestions)),
      body: suggestions == null
          ? Center(
              child: error == null
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
            )
          : suggestions.isEmpty
          ? Center(child: Text(L10n.of(context).noPendingSuggestions))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                for (final suggestion in suggestions)
                  Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: .stretch,
                        children: [
                          if (suggestion.suggested == null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                suggestion.suggestedMatrixId,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          Text(_buildBody(context, suggestion)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: busy
                                      ? null
                                      : () => _dismiss(suggestion),
                                  child: Text(L10n.of(context).dismiss),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledButton(
                                  onPressed: busy
                                      ? null
                                      : () => _invite(suggestion),
                                  child: Text(L10n.of(context).invite),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
