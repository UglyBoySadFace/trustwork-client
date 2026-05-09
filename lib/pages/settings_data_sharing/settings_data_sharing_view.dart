import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_data_sharing/view_model/settings_data_sharing_state.dart';
import 'package:fluffychat/pages/settings_data_sharing/view_model/settings_data_sharing_view_model.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class SettingsDataSharingView extends StatefulWidget {
  final SettingsDataSharingViewModel viewModel;

  const SettingsDataSharingView(this.viewModel, {super.key});

  @override
  State<SettingsDataSharingView> createState() =>
      _SettingsDataSharingViewState();
}

class _SettingsDataSharingViewState extends State<SettingsDataSharingView> {
  String? _lastSaveError;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    final error = widget.viewModel.value.saveError;
    if (error != null && error != _lastSaveError) {
      _lastSaveError = error;
      final messenger = ScaffoldMessenger.maybeOf(context);
      messenger?.hideCurrentSnackBar();
      messenger?.showSnackBar(SnackBar(content: Text(error)));
    } else if (error == null) {
      _lastSaveError = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.viewModel.value;
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dataSharingPreferencesTitle),
        automaticallyImplyLeading: !FluffyThemes.isColumnMode(context),
        centerTitle: FluffyThemes.isColumnMode(context),
      ),
      body: MaxWidthBody(
        child: _buildBody(context, theme, state, l10n),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    SettingsDataSharingState state,
    L10n l10n,
  ) {
    if (state.loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 64),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.loadError != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(state.loadError!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: widget.viewModel.retry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Text(
            l10n.dataSharingPreferencesSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        for (final field in ShareableField.values)
          SwitchListTile.adaptive(
            value: state.values[field] ?? false,
            title: Text(field.label(l10n)),
            onChanged: (next) => widget.viewModel.toggle(field, next),
          ),
      ],
    );
  }
}
