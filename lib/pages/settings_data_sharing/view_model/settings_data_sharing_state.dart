import 'package:fluffychat/utils/data_sharing/shareable_field.dart';

class SettingsDataSharingState {
  final bool loading;
  final bool saving;
  final String? loadError;
  final String? saveError;
  final Map<ShareableField, bool> values;

  const SettingsDataSharingState({
    this.loading = true,
    this.saving = false,
    this.loadError,
    this.saveError,
    this.values = const {},
  });

  SettingsDataSharingState copyWith({
    bool? loading,
    bool? saving,
    String? loadError,
    String? saveError,
    Map<ShareableField, bool>? values,
    bool clearLoadError = false,
    bool clearSaveError = false,
  }) => SettingsDataSharingState(
    loading: loading ?? this.loading,
    saving: saving ?? this.saving,
    loadError: clearLoadError ? null : loadError ?? this.loadError,
    saveError: clearSaveError ? null : saveError ?? this.saveError,
    values: values ?? this.values,
  );
}
