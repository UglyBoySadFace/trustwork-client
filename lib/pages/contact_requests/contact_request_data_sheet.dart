import 'dart:async';

import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ContactRequestDataSheet extends StatefulWidget {
  const ContactRequestDataSheet({
    required this.requesterDisplayName,
    required this.requesterMatrixId,
    required this.sharingPreferences,
    this.room,
    super.key,
  });

  final String requesterDisplayName;
  final String requesterMatrixId;
  final SharingPreferences sharingPreferences;
  final Room? room;

  @override
  State<ContactRequestDataSheet> createState() =>
      _ContactRequestDataSheetState();
}

class _ContactRequestDataSheetState extends State<ContactRequestDataSheet> {
  late final Map<ShareableField, bool> _selected;
  bool _sending = false;

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

  Future<void> _send() async {
    final service = Matrix.of(context).dataSharingService;
    if (service == null) return;
    final selected = _selectedFields();
    if (selected.isEmpty) return;
    setState(() => _sending = true);

    // Room event triggers push to the requester's phone.
    final room = widget.room;
    if (room != null) {
      unawaited(room.sendEvent({}, type: 'com.trustwork.data_request'));
    }

    // Fire the to-device request in the background — response may come later.
    unawaited(
      service.request(
        callerMatrixId: widget.requesterMatrixId,
        fields: selected,
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final available = ShareableField.values.toList();
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
                  for (final f in available)
                    CheckboxListTile(
                      value: _selected[f] ?? false,
                      onChanged: _sending
                          ? null
                          : (v) => setState(() => _selected[f] = v ?? false),
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
                      onPressed:
                          _sending ? null : () => Navigator.of(context).pop(),
                      child: Text(l10n.dataSharingCancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          (_sending ||
                                  available.isEmpty ||
                                  _selectedFields().isEmpty)
                              ? null
                              : _send,
                      child: Text(l10n.dataSharingSendRequest),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
