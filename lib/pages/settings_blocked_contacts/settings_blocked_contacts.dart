import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class SettingsBlockedContacts extends StatefulWidget {
  const SettingsBlockedContacts({super.key});

  @override
  State<SettingsBlockedContacts> createState() =>
      _SettingsBlockedContactsState();
}

class _SettingsBlockedContactsState extends State<SettingsBlockedContacts> {
  List<IncomingContactRequest>? _blocked;
  String? _error;
  bool _loading = false;
  final _processingIds = <int>{};

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
      final all = await TrustworkApiService.instance.getIncomingContactRequests();
      if (!mounted) return;
      setState(() {
        _blocked = all.where((r) => r.status == 'blocked').toList();
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = TrustworkApiService.friendlyError(e);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _unblock(IncomingContactRequest req) async {
    setState(() => _processingIds.add(req.id));
    try {
      await TrustworkApiService.instance.unblockContactRequest(req.id);
      if (!mounted) return;
      await _load();
    } on DioException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TrustworkApiService.friendlyError(e))),
      );
    } finally {
      if (mounted) setState(() => _processingIds.remove(req.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    Widget body;

    if (_loading && _blocked == null) {
      body = const Center(child: CircularProgressIndicator.adaptive());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_outlined),
              label: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    } else if (_blocked?.isEmpty ?? true) {
      body = Center(
        child: Text(
          l10n.noBlockedUsers,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    } else {
      body = RefreshIndicator.adaptive(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _blocked!.length,
          itemBuilder: (context, i) {
            final req = _blocked![i];
            final isProcessing = _processingIds.contains(req.id);
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.block_outlined)),
              title: Text(req.requester.displayName),
              subtitle: req.requester.matrixUserId != null
                  ? Text(req.requester.matrixUserId!)
                  : null,
              trailing: isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : TextButton(
                      onPressed: () => _unblock(req),
                      child: Text(l10n.unblock),
                    ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.blockedUsers)),
      body: body,
    );
  }
}
