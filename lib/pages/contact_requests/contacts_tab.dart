import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({super.key});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  BuiltList<ContactSummary>? _contacts;
  String? _error;
  bool _loading = false;
  final _removingIds = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final contacts = await TrustworkApiService.instance.getContacts();
      if (!mounted) return;
      setState(() {
        _contacts = contacts;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = TrustworkApiService.friendlyError(e);
        _loading = false;
      });
    }
  }

  Future<void> _remove(ContactSummary contact) async {
    final mxid = contact.matrixUserId;
    if (mxid == null || mxid.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L10n.of(context).removeContact),
        content: Text(L10n.of(context).removeContactConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(L10n.of(context).cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(L10n.of(context).removeContact),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _removingIds.add(mxid));
    try {
      final client = Matrix.of(context).client;
      final dmRoom = client.rooms.where((r) {
        final ids = r.getParticipants().map((m) => m.id).toSet();
        return r.isDirectChat &&
            ids.contains(mxid) &&
            ids.contains(client.userID) &&
            ids.length == 2;
      }).firstOrNull;
      if (dmRoom != null) await dmRoom.removeFromDirectChat();
      await TrustworkApiService.instance.removeContact(mxid);
      if (!mounted) return;
      await Matrix.of(context)
          .contactsCache
          .refresh(Matrix.of(context).store);
      if (!mounted) return;
      await _load();
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TrustworkApiService.friendlyError(e))),
      );
    } finally {
      if (mounted) setState(() => _removingIds.remove(mxid));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _load,
              child: Text(L10n.of(context).tryAgain),
            ),
          ],
        ),
      );
    }
    final contacts = _contacts;
    if (contacts == null || contacts.isEmpty) {
      return Center(child: Text(L10n.of(context).noContactsYet));
    }
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, i) {
        final contact = contacts[i];
        final mxid = contact.matrixUserId ?? '';
        final removing = _removingIds.contains(mxid);
        return ListTile(
          leading: CircleAvatar(
            child: Text(
              contact.displayName.isNotEmpty
                  ? contact.displayName[0].toUpperCase()
                  : '?',
            ),
          ),
          title: Text(contact.displayName),
          subtitle: mxid.isNotEmpty ? Text(mxid) : null,
          trailing: removing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.person_remove_outlined),
                  tooltip: L10n.of(context).removeContact,
                  onPressed: () => _remove(contact),
                ),
        );
      },
    );
  }
}
