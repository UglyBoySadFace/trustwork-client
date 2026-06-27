import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/data_sharing/data_sharing_service.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ContactRequestDataSheet extends StatefulWidget {
  const ContactRequestDataSheet({
    required this.requesterDisplayName,
    required this.requesterMatrixId,
    required this.sharingPreferences,
    super.key,
  });

  final String requesterDisplayName;
  final String requesterMatrixId;
  final SharingPreferences sharingPreferences;

  @override
  State<ContactRequestDataSheet> createState() =>
      _ContactRequestDataSheetState();
}

sealed class _SheetFlow {
  const _SheetFlow();
}

class _Picking extends _SheetFlow {
  const _Picking();
}

class _Waiting extends _SheetFlow {
  const _Waiting();
}

class _Showing extends _SheetFlow {
  const _Showing(this.fields, this.data);
  final List<ShareableField> fields;
  final SharedData data;
}

class _Errored extends _SheetFlow {
  const _Errored(this.message);
  final String message;
}

class _ContactRequestDataSheetState extends State<ContactRequestDataSheet> {
  late final Map<ShareableField, bool> _selected;
  _SheetFlow _flow = const _Picking();

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final f in ShareableField.values)
        f: f.readPreference(widget.sharingPreferences),
    };
  }

  Set<ShareableField> _selectedFields() => _selected.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toSet();

  List<ShareableField> get _availableFields => ShareableField.values
      .where((f) => f.readPreference(widget.sharingPreferences))
      .toList();

  Future<void> _send() async {
    final service = Matrix.of(context).dataSharingService;
    if (service == null) return;
    final selected = _selectedFields();
    if (selected.isEmpty) return;
    setState(() => _flow = const _Waiting());

    final outcome = await service.request(
      callerMatrixId: widget.requesterMatrixId,
      fields: selected,
    );
    if (!mounted) return;
    _handleOutcome(outcome, selected);
  }

  void _handleOutcome(
    DataSharingOutcome outcome,
    Set<ShareableField> requested,
  ) {
    if (!mounted) return;
    final l10n = L10n.of(context);
    switch (outcome) {
      case DataSharingApproved(:final data):
        final ordered = requested.toList()
          ..sort((a, b) => a.index.compareTo(b.index));
        setState(() => _flow = _Showing(ordered, data));
      case DataSharingDeclined():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataSharingDeclined)),
        );
        Navigator.of(context).pop();
      case DataSharingTimedOut():
        setState(() => _flow = _Errored(l10n.dataSharingTimedOut));
      case DataSharingErrored():
        setState(() => _flow = _Errored(l10n.dataSharingErrored));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            Flexible(
              child: switch (_flow) {
                _Picking() => _buildPicker(),
                _Waiting() => _buildWaiting(),
                _Showing(:final fields, :final data) =>
                  _buildShowing(fields, data),
                _Errored(:final message) => _buildErrored(message),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker() {
    final l10n = L10n.of(context);
    final available = _availableFields;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.dataSharingPickerTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.dataSharingPickerSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        if (available.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              l10n.sharesNothingWithYou,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        else
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final f in available)
                  CheckboxListTile(
                    value: _selected[f] ?? false,
                    onChanged: (v) =>
                        setState(() => _selected[f] = v ?? false),
                    title: Text(f.label(l10n)),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.dataSharingCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: (available.isEmpty || _selectedFields().isEmpty)
                      ? null
                      : _send,
                  child: Text(l10n.dataSharingSendRequest),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWaiting() {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dataSharingWaitingTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dataSharingWaitingSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShowing(List<ShareableField> fields, SharedData data) {
    final l10n = L10n.of(context);
    final rows = <Widget>[];
    for (final f in fields) {
      final value = f.formatValue(data, l10n);
      if (value == null) continue;
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                child: Text(
                  f.label(l10n),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.dataSharingResultTitle,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: rows.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Text(
                    l10n.dataSharingNoData,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView(shrinkWrap: true, children: rows),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.dataSharingClose),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrored(String message) {
    final l10n = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 36,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.dataSharingClose),
            ),
          ),
        ],
      ),
    );
  }
}
