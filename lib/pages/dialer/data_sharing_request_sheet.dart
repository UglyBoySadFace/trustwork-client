import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/data_sharing/data_sharing_service.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';

sealed class _CalleeFlowState {
  const _CalleeFlowState();
}

final class _CalleePicking extends _CalleeFlowState {
  const _CalleePicking();
}

final class _CalleeWaiting extends _CalleeFlowState {
  const _CalleeWaiting();
}

final class _CalleeShowing extends _CalleeFlowState {
  const _CalleeShowing(this.fields, this.data);
  final List<ShareableField> fields;
  final SharedData data;
}

final class _CalleeErrored extends _CalleeFlowState {
  const _CalleeErrored(this.message);
  final String message;
}

/// Callee-initiated data-sharing request sheet: the callee picks which fields
/// to ask the caller for, sends the request, and sees the result (or an
/// error) inline. Hosted in the dialer's local navigator so it stacks above
/// the call overlay.
class DataSharingRequestSheet extends StatefulWidget {
  const DataSharingRequestSheet({
    required this.callerDisplayName,
    required this.callerMatrixId,
    this.service,
    super.key,
  });

  final String callerDisplayName;
  final String callerMatrixId;
  final DataSharingService? service;

  @override
  State<DataSharingRequestSheet> createState() =>
      _DataSharingRequestSheetState();
}

class _DataSharingRequestSheetState extends State<DataSharingRequestSheet> {
  final Map<ShareableField, bool> _selected = {
    for (final f in ShareableField.values) f: false,
  };
  late _CalleeFlowState _flow = const _CalleePicking();

  Set<ShareableField> _selectedFields() => _selected.entries
      .where((e) => e.value)
      .map((e) => e.key)
      .toSet();

  Future<void> _send() async {
    final service = widget.service;
    if (service == null) return;
    final selected = _selectedFields();
    if (selected.isEmpty) return;
    setState(() => _flow = const _CalleeWaiting());

    final outcome = await service.request(
      callerMatrixId: widget.callerMatrixId,
      fields: selected,
    );
    if (!mounted) return;
    _handleOutcome(outcome, selected);
  }

  void _handleOutcome(DataSharingOutcome outcome, Set<ShareableField> fields) {
    if (!mounted) return;
    final l10n = L10n.of(context);
    switch (outcome) {
      case DataSharingApproved(:final data):
        final ordered = fields.toList()
          ..sort((a, b) => a.index.compareTo(b.index));
        setState(() => _flow = _CalleeShowing(ordered, data));
        return;
      case DataSharingDeclined():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.dataSharingDeclined)),
        );
        _close();
        return;
      case DataSharingTimedOut():
        setState(() => _flow = _CalleeErrored(l10n.dataSharingTimedOut));
        return;
      case DataSharingErrored():
        setState(() => _flow = _CalleeErrored(l10n.dataSharingErrored));
        return;
    }
  }

  void _close() {
    // The dialer dismisses this sheet externally when the call leaves the
    // data-sharing window; a second pop would remove the call screen route
    // from the dialer's local navigator.
    if (ModalRoute.of(context)?.isCurrent != true) return;
    Navigator.of(context).pop();
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
                _CalleePicking() => _buildPicker(),
                _CalleeWaiting() => _buildWaiting(),
                _CalleeShowing(:final fields, :final data) =>
                  _buildShowing(fields, data),
                _CalleeErrored(:final message) => _buildErrored(message),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker() {
    final l10n = L10n.of(context);
    const fields = ShareableField.values;
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
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final f in fields)
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
                  onPressed: _close,
                  child: Text(l10n.dataSharingCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: (_selectedFields().isEmpty || widget.service == null)
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
              onPressed: _close,
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
              onPressed: _close,
              child: Text(l10n.dataSharingClose),
            ),
          ),
        ],
      ),
    );
  }
}
