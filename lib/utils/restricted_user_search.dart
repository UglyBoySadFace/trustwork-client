// Package imports:
import 'package:matrix/matrix.dart';

/// Searches for users with restricted discovery:
/// - Non-Matrix-ID terms only search through existing direct-chat contacts
///   (client-side, no server call).
/// - A valid Matrix ID (@user:server) performs a direct profile lookup for
///   strangers while still matching known contacts by partial ID.
///
/// "Known contacts" = users who already share a direct chat room.
Future<List<Profile>> restrictedUserSearch(
  Client client,
  String searchTerm,
) async {
  if (searchTerm.isEmpty) return [];

  final known = _knownContactProfiles(client);
  final normalized = searchTerm.toLowerCase();
  final isMatrixId = searchTerm.isValidMatrixId && searchTerm.sigil == '@';

  if (!isMatrixId) {
    return known
        .where(
          (p) =>
              p.userId.toLowerCase().contains(normalized) ||
              (p.displayName?.toLowerCase().contains(normalized) ?? false),
        )
        .toList();
  }

  // Exact / partial Matrix ID — filter known contacts first.
  final results = known
      .where((p) => p.userId.toLowerCase().contains(normalized))
      .toList();

  // Look up the exact ID on the server if not already in results.
  if (!results.any((p) => p.userId == searchTerm)) {
    try {
      final info = await client.getProfileFromUserId(searchTerm);
      results.add(
        Profile(
          userId: searchTerm,
          displayName: info.displayName,
          avatarUrl: info.avatarUrl,
        ),
      );
    } catch (_) {
      // User not found or homeserver unreachable — still surface the typed ID.
      results.add(Profile(userId: searchTerm));
    }
  }

  return results;
}

List<Profile> _knownContactProfiles(Client client) {
  final seen = <String>{};
  final profiles = <Profile>[];
  for (final r in client.rooms) {
    final userId = r.directChatMatrixID;
    if (!r.isDirectChat || userId == null) continue;
    if (!seen.add(userId)) continue; // skip duplicate DM rooms for same user
    final user = r.unsafeGetUserFromMemoryOrFallback(userId);
    profiles.add(
      Profile(
        userId: userId,
        displayName: user.displayName,
        avatarUrl: user.avatarUrl,
      ),
    );
  }
  return profiles;
}
