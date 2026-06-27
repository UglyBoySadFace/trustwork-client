import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/contacts/contacts_cache.dart';

/// Searches accepted contacts (from [ContactsCache]) by Matrix ID or display
/// name. Strangers are not searchable — invites and DMs are only possible
/// with accepted contacts.
List<Profile> restrictedUserSearch(
  ContactsCache contactsCache,
  String searchTerm,
) {
  if (searchTerm.isEmpty) return [];

  final normalized = searchTerm.toLowerCase();
  return contactsCache.entries
      .where(
        (entry) =>
            entry.key.toLowerCase().contains(normalized) ||
            entry.value.toLowerCase().contains(normalized),
      )
      .map((entry) => Profile(userId: entry.key, displayName: entry.value))
      .toList();
}
