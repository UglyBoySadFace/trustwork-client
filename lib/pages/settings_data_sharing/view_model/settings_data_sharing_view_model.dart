import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:api_client/api_client.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/pages/settings_data_sharing/view_model/settings_data_sharing_state.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

class SettingsDataSharingViewModel
    extends ValueNotifier<SettingsDataSharingState> {
  SettingsDataSharingViewModel(this._store)
    : super(const SettingsDataSharingState()) {
    _bootstrap();
  }

  static const cacheKey = 'tw_sharing_preferences_cache';
  static const _debounce = Duration(milliseconds: 500);

  final SharedPreferences _store;
  Timer? _debounceTimer;
  Map<ShareableField, bool> _lastSaved = const {};
  bool _disposed = false;

  Future<void> _bootstrap() async {
    final cached = _readCache();
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
      final prefs = await _fetchPreferences();
      final next = _toMap(prefs);
      _lastSaved = next;
      await _writeCache(next);
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
      final next = updated != null ? _toMap(updated) : snapshot;
      _lastSaved = next;
      await _writeCache(next);
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

  Future<SharingPreferences> _fetchPreferences() async {
    final response = await TrustworkApiService.instance.authedRequest(
      (token) => TrustworkApiService.instance.sharing
          .getSharingPreferencesMeSharingPreferencesGet(
            headers: <String, String>{'Authorization': 'Bearer $token'},
          ),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty sharing preferences response');
    }
    return data;
  }

  Map<ShareableField, bool> _toMap(SharingPreferences prefs) => {
    for (final f in ShareableField.values) f: f.readPreference(prefs),
  };

  Map<ShareableField, bool>? _readCache() {
    final raw = _store.getString(cacheKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final map = <ShareableField, bool>{};
      for (final field in ShareableField.values) {
        final stored = decoded[field.wireId];
        map[field] = stored is bool && stored;
      }
      return map;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(Map<ShareableField, bool> values) {
    final json = <String, bool>{
      for (final entry in values.entries) entry.key.wireId: entry.value,
    };
    return _store.setString(cacheKey, jsonEncode(json));
  }

  @override
  void dispose() {
    _disposed = true;
    _debounceTimer?.cancel();
    super.dispose();
  }
}
