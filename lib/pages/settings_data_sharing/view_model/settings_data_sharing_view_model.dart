import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/pages/settings_data_sharing/view_model/settings_data_sharing_state.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/data_sharing/sharing_preferences_cache.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class SettingsDataSharingViewModel
    extends ValueNotifier<SettingsDataSharingState> {
  SettingsDataSharingViewModel(this._store)
    : super(const SettingsDataSharingState()) {
    _bootstrap();
  }

  static const _debounce = Duration(milliseconds: 500);

  final SharedPreferences _store;
  Timer? _debounceTimer;
  Map<ShareableField, bool> _lastSaved = const {};
  bool _disposed = false;

  Future<void> _bootstrap() async {
    final cached = SharingPreferencesCache.read(_store);
    if (cached != null) {
      _lastSaved = cached;
      value = value.copyWith(loading: false, values: cached);
    }
    await _refresh(initial: cached == null);
  }

  Future<void> retry() => _refresh(initial: true);

  void toggle(ShareableField field, bool enabled) {
    final next = Map<ShareableField, bool>.from(value.values)..[field] = enabled;
    value = value.copyWith(values: next, clearSaveError: true);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, _flush);
  }

  void clearSaveError() {
    if (value.saveError == null) return;
    value = value.copyWith(clearSaveError: true);
  }

  Future<void> _refresh({required bool initial}) async {
    try {
      final next = await SharingPreferencesCache.refresh(_store);
      _lastSaved = next;
      if (_disposed) return;
      value = value.copyWith(
        loading: false,
        values: next,
        clearLoadError: true,
      );
    } on DioException catch (e) {
      if (_disposed) return;
      if (initial) {
        value = value.copyWith(
          loading: false,
          loadError: TrustworkApiService.friendlyError(e),
        );
      }
    } catch (_) {
      if (_disposed) return;
      if (initial) {
        value = value.copyWith(
          loading: false,
          loadError: 'Couldn\'t load preferences. Please try again.',
        );
      }
    }
  }

  Future<void> _flush() async {
    if (_disposed) return;
    final snapshot = Map<ShareableField, bool>.from(value.values);
    value = value.copyWith(saving: true, clearSaveError: true);
    try {
      final response = await TrustworkApiService.instance.authedRequest(
        (token) => TrustworkApiService.instance.sharing
            .updateSharingPreferencesMeSharingPreferencesPut(
              sharingPreferences: ShareableField.buildPreferences(snapshot),
              headers: <String, String>{'Authorization': 'Bearer $token'},
            ),
      );
      final updated = response.data;
      final next = updated != null
          ? SharingPreferencesCache.toMap(updated)
          : snapshot;
      _lastSaved = next;
      await SharingPreferencesCache.write(_store, next);
      if (_disposed) return;
      value = value.copyWith(saving: false, values: next);
    } on DioException catch (e) {
      if (_disposed) return;
      value = value.copyWith(
        saving: false,
        values: Map<ShareableField, bool>.from(_lastSaved),
        saveError: TrustworkApiService.friendlyError(e),
      );
    } catch (_) {
      if (_disposed) return;
      value = value.copyWith(
        saving: false,
        values: Map<ShareableField, bool>.from(_lastSaved),
        saveError: 'Couldn\'t save changes. Please try again.',
      );
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }
}
