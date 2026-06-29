import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/contacts/contacts_cache.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';

/// Returns the correct display title for [room], overriding SDK-generated names
/// for contact-request rooms where Matrix profiles are intentionally blank.
///
/// Rules:
/// - Pending CR room, I'm the sender   → "Pending request"
/// - Pending CR room, I'm the receiver → requester_display_name from event
/// - CR room, contact now accepted      → name from ContactsCache
/// - All other rooms                   → existing label / getLocalizedDisplayname
String contactRequestRoomTitle(Room room, ContactsCache cache, L10n l10n) {
  final crEvent = room.lastEvent?.type == 'com.trustwork.contact_request'
      ? room.lastEvent!
      : null;

  if (crEvent != null) {
    final myId = room.client.userID;
    final requesterMxid =
        crEvent.content.tryGet<String>('requester_matrix_id') ??
        crEvent.senderId;
    final targetMxid =
        crEvent.content.tryGet<String>('target_matrix_id') ?? '';
    final otherMxid = requesterMxid == myId ? targetMxid : requesterMxid;

    if (otherMxid.isNotEmpty && cache.isContact(otherMxid)) {
      return cache.label(otherMxid);
    }

    if (crEvent.senderId == myId) {
      return 'Pending request';
    }
    return crEvent.content.tryGet<String>('requester_display_name') ??
        requesterMxid;
  }

  final dmId = room.directChatMatrixID;
  return dmId != null
      ? cache.label(dmId)
      : room.getLocalizedDisplayname(MatrixLocals(l10n));
}
