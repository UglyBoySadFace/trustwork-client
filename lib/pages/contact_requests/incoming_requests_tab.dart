import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/contact_requests/contact_request_data_sheet.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

class IncomingRequestsTab extends StatefulWidget {
  const IncomingRequestsTab({super.key});

  @override
  State<IncomingRequestsTab> createState() => _IncomingRequestsTabState();
}

class _IncomingRequestsTabState extends State<IncomingRequestsTab> {
  BuiltList<IncomingContactRequest>? _requests;
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
      final requests =
          await TrustworkApiService.instance.getIncomingContactRequests();
      if (!mounted) return;
      Matrix.of(context).incomingContactRequestCount.value = requests.length;
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

  Future<void> _accept(IncomingContactRequest req) async {
    setState(() => _processingIds.add(req.id));
    try {
      await TrustworkApiService.instance.acceptContactRequest(req.id);
      if (!mounted) return;
      await Matrix.of(context).contactsCache.refresh(Matrix.of(context).store);
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

  Future<void> _decline(IncomingContactRequest req) async {
    setState(() => _processingIds.add(req.id));
    try {
      await TrustworkApiService.instance.declineContactRequest(req.id);
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

  Future<void> _requestMoreInfo(IncomingContactRequest req) async {
    final mxid = req.requester.matrixUserId;
    if (mxid == null || mxid.isEmpty) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ContactRequestDataSheet(
        requesterDisplayName: req.requester.displayName,
        requesterMatrixId: mxid,
        sharingPreferences: req.requesterSharingPreferences,
      ),
    );
  }

  Future<void> _block(IncomingContactRequest req) async {
    setState(() => _processingIds.add(req.id));
    try {
      await TrustworkApiService.instance.blockContactRequest(req.id);
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

  String _sharingPreferencesSummary(SharingPreferences prefs, L10n l10n) {
    final parts = <String>[];
    if (prefs.shareCountry == true) parts.add(l10n.shareableFieldCountry);
    if (prefs.shareState == true) parts.add(l10n.shareableFieldState);
    if (prefs.shareFullAge == true) parts.add(l10n.shareableFieldFullAge);
    if (prefs.shareDecadeOfAge == true) {
      parts.add(l10n.shareableFieldDecadeOfAge);
    }
    if (prefs.shareIsAdult == true) parts.add(l10n.shareableFieldIsAdult);
    if (prefs.shareNationalities == true) {
      parts.add(l10n.shareableFieldNationalities);
    }
    if (parts.isEmpty) return l10n.sharesNothingWithYou;
    return l10n.willShareWithYou(parts.join(', '));
  }

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

    final requests = _requests ?? BuiltList<IncomingContactRequest>();
    if (requests.isEmpty) {
      return Center(
        child: Text(
          l10n.noIncomingRequests,
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
          final isProcessing = _processingIds.contains(req.id);
          final displayName = req.requester.displayName;
          final mxid = req.requester.matrixUserId ?? '';
          final sharingText = _sharingPreferencesSummary(
            req.requesterSharingPreferences,
            l10n,
          );
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(displayName, style: theme.textTheme.titleMedium),
                  if (mxid.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      mxid,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    sharingText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isProcessing)
                    const Center(child: CircularProgressIndicator.adaptive())
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        FilledButton(
                          onPressed: () => _accept(req),
                          child: Text(l10n.accept),
                        ),
                        OutlinedButton(
                          onPressed: () => _decline(req),
                          child: Text(l10n.decline),
                        ),
                        OutlinedButton(
                          onPressed: () => _block(req),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          ),
                          child: Text(l10n.block),
                        ),
                        OutlinedButton(
                          onPressed: () => _requestMoreInfo(req),
                          child: Text(l10n.requestMoreInfo),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
