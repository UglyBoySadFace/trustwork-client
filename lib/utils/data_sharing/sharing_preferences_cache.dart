import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/utils/data_sharing/shareable_field.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';

/// Locally-cached copy of the user's `share_*` flags so other surfaces (the
/// caller-side approval prompt during ringing) can pre-tick checkboxes
/// without an API round-trip. The settings screen owns writes; readers may
/// also trigger a background refresh.
class SharingPreferencesCache {
  static const String storageKey = 'tw_sharing_preferences_cache';

  static Map<ShareableField, bool>? read(SharedPreferences store) {
    final raw = store.getString(storageKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return {
        for (final f in ShareableField.values) f: decoded[f.wireId] == true,
      };
    } catch (_) {
      return null;
    }
  }

  static Future<void> write(
    SharedPreferences store,
    Map<ShareableField, bool> values,
  ) {
    final json = <String, bool>{
      for (final entry in values.entries) entry.key.wireId: entry.value,
    };
    return store.setString(storageKey, jsonEncode(json));
  }

  static Map<ShareableField, bool> toMap(SharingPreferences prefs) => {
    for (final f in ShareableField.values) f: f.readPreference(prefs),
  };

  /// Fetches the latest preferences, writes them to the cache, and returns
  /// the resulting map. Callers fire-and-forget when they only need the
  /// cache to stay warm.
  static Future<Map<ShareableField, bool>> refresh(
    SharedPreferences store,
  ) async {
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
    final map = toMap(data);
    await write(store, map);
    return map;
  }
}
