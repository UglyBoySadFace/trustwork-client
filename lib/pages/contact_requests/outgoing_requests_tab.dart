import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class OutgoingRequestsTab extends StatefulWidget {
  const OutgoingRequestsTab({super.key});

  @override
  State<OutgoingRequestsTab> createState() => _OutgoingRequestsTabState();
}

class _OutgoingRequestsTabState extends State<OutgoingRequestsTab> {
  BuiltList<OutgoingContactRequest>? _requests;
  String? _error;
  bool _loading = false;

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
      final requests =
          await TrustworkApiService.instance.getOutgoingContactRequests();
      if (!mounted) return;
      setState(() {
        _requests = requests;
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

  String _statusLabel(String status, L10n l10n) => switch (status) {
    'accepted' => l10n.contactRequestStatusAccepted,
    'declined' => l10n.contactRequestStatusDeclined,
    'blocked' => l10n.contactRequestStatusBlocked,
    _ => l10n.contactRequestStatusPending,
  };

  Color _statusColor(String status, ColorScheme colors) => switch (status) {
    'accepted' => colors.primary,
    'declined' || 'blocked' => colors.error,
    _ => colors.secondary,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    if (_loading && _requests == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_error != null) {
      return Center(
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
    }

    final requests = _requests ?? BuiltList<OutgoingContactRequest>();
    if (requests.isEmpty) {
      return Center(
        child: Text(
          l10n.noOutgoingRequests,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, i) {
          final req = requests[i];
          final target = req.target;
          final title = target != null ? target.displayName : req.targetMatrixId;
          final subtitle = target?.matrixUserId ?? req.targetMatrixId;
          final statusColor = _statusColor(req.status, theme.colorScheme);
          return ListTile(
            title: Text(title),
            subtitle: subtitle != title ? Text(subtitle) : null,
            trailing: Chip(
              label: Text(
                _statusLabel(req.status, l10n),
                style: TextStyle(color: statusColor, fontSize: 12),
              ),
              backgroundColor: statusColor.withAlpha(26),
              side: BorderSide.none,
            ),
          );
        },
      ),
    );
  }
}
