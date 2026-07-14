import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/groups/groups_service.dart';

/// Leaves and forgets every room shared 1:1 with [mxid] after unfriending.
///
/// Two kinds of rooms qualify:
/// - rooms whose participants are exactly {me, mxid} — the call-to-connect
///   DM and any plain DM, whether or not they carry an m.direct mapping;
/// - rooms containing [mxid] that hold a com.trustwork.contact_request stamp
///   involving them — the backend-created request-delivery room, which may
///   hold an extra service member and so fails the two-member check.
///
/// Trustwork group rooms are never touched: group membership is managed by
/// the backend and survives unfriending.
///
/// Per-room failures are logged and skipped so one dead room can't block the
/// rest of the cleanup. `Room.leave()` also removes the m.direct mapping.
Future<void> leaveSharedContactRooms(Client client, String mxid) async {
  final myId = client.userID;
  if (myId == null) return;
  for (final room in List<Room>.of(client.rooms)) {
    if (room.isSpace) continue;
    if (GroupsService.instance.findByMatrixRoomId(room.id) != null) continue;
    final ids = room.getParticipants().map((u) => u.id).toSet();
    if (!ids.contains(mxid) || !ids.contains(myId)) continue;
    if (ids.length != 2 &&
        !await hasContactRequestStampFor(client, room, mxid)) {
      continue;
    }
    try {
      await room.leave();
      await room.forget();
    } catch (e) {
      Logs().w(
        '[CONTACTS] cleanup of shared room ${room.id} with $mxid failed: $e',
      );
    }
  }
}

/// Scans the room's recent DB timeline for a com.trustwork.contact_request
/// stamp involving [mxid]. The room may be E2EE, so encrypted events get a
/// decryption retry before matching (same approach as the call-connect scan
/// in VoipPlugin).
Future<bool> hasContactRequestStampFor(
  Client client,
  Room room,
  String mxid,
) async {
  final events = await client.database.getEventList(room, limit: 30);
  for (var event in events) {
    if (event.type == EventTypes.Encrypted) {
      try {
        event =
            await client.encryption?.decryptRoomEvent(event, store: true) ??
                event;
      } catch (e) {
        Logs().w('[CONTACTS] decrypt during stamp scan failed: $e');
      }
      if (event.type == EventTypes.Encrypted) continue;
    }
    if (event.type != 'com.trustwork.contact_request') continue;
    if (event.senderId == mxid ||
        event.content.tryGet<String>('requester_matrix_id') == mxid ||
        event.content.tryGet<String>('target_matrix_id') == mxid) {
      return true;
    }
  }
  return false;
}
