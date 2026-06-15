import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/utils/trustwork_api_service.dart';

/// Synchronous, persisted cache mapping `matrix_user_id -> display_name` for
/// accepted contacts, sourced from `GET /contacts`. Strangers only ever
/// resolve to their opaque Matrix ID via [label] until a contact request is
/// accepted and this cache is refreshed.
class ContactsCache {
  static const String storageKey = 'tw_contacts_cache';

  Map<String, String> _displayNames = {};

  String? displayName(String matrixUserId) => _displayNames[matrixUserId];

  /// Returns the cached display name for [matrixUserId], falling back to the
  /// Matrix ID itself when no accepted contact is known.
  String label(String matrixUserId) =>
      displayName(matrixUserId) ?? matrixUserId;

  void loadFromStore(SharedPreferences store) {
    final raw = store.getString(storageKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      _displayNames = decoded.map(
        (key, value) => MapEntry(key as String, value as String),
      );
    } catch (_) {
      // Ignore corrupt cache entries; refresh() will repopulate it.
    }
  }

  Future<void> refresh(SharedPreferences store) async {
    final contacts = await TrustworkApiService.instance.getContacts();
    _displayNames = {
      for (final c in contacts)
        if (c.matrixUserId != null) c.matrixUserId!: c.displayName,
    };
    await store.setString(storageKey, jsonEncode(_displayNames));
  }
}
