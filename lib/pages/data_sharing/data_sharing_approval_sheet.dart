import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';

class DataSharingApprovalSheet extends StatefulWidget {
  const DataSharingApprovalSheet({
    super.key,
    required this.requesterDisplayName,
    required this.fields,
    required this.defaults,
    required this.onShare,
    required this.onDecline,
  });

  final String requesterDisplayName;
  final List<ShareableField> fields;
  final Map<ShareableField, bool> defaults;

  /// Returns `null` on success (sheet closes); non-null keeps the sheet open.
  final Future<String?> Function(Set<ShareableField> selected) onShare;
  final Future<void> Function() onDecline;

  @override
  State<DataSharingApprovalSheet> createState() =>
      _DataSharingApprovalSheetState();
}

class _DataSharingApprovalSheetState extends State<DataSharingApprovalSheet> {
  late final Map<ShareableField, bool> _selected = {
    for (final f in widget.fields) f: widget.defaults[f] ?? false,
  };
  bool _busy = false;
  String? _errorMessage;

  Set<ShareableField> _selectedFields() => _selected.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toSet();

  Future<void> _share() async {
    setState(() {
      _busy = true;
      _errorMessage = null;
    });
    final error = await widget.onShare(_selectedFields());
    if (!mounted) return;
    if (error != null) {
      setState(() {
        _busy = false;
        _errorMessage = error;
      });
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _decline() async {
    setState(() => _busy = true);
    await widget.onDecline();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return PopScope(
      canPop: false,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.dataSharingRequestTitle(widget.requesterDisplayName),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.dataSharingRequestSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final f in widget.fields)
                      CheckboxListTile(
                        value: _selected[f] ?? false,
                        onChanged: _busy
                            ? null
                            : (v) => setState(() => _selected[f] = v ?? false),
                        title: Text(f.label(l10n)),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                  ],
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _busy ? null : _decline,
                        child: Text(l10n.dataSharingDecline),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed:
                            (_busy || _selectedFields().isEmpty)
                                ? null
                                : _share,
                        child: _busy
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.dataSharingShare),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
