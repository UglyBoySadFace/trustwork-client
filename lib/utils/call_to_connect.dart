import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Outcome of [startCallToConnect].
sealed class CallToConnectOutcome {
  const CallToConnectOutcome();
}

/// The call was placed; navigate to [roomId].
class CallToConnectStarted extends CallToConnectOutcome {
  const CallToConnectStarted(this.roomId);
  final String roomId;
}

/// The contact request was created but its DM room never synced, so no call
/// could be placed. The request still exists server-side.
class CallToConnectRoomUnavailable extends CallToConnectOutcome {
  const CallToConnectRoomUnavailable();
}

/// A call is already in progress; call-to-connect was not started.
class CallToConnectBusy extends CallToConnectOutcome {
  const CallToConnectBusy();
}

/// Shared call-to-connect flow used by both entry points (the new-private-chat
/// page and the user dialog): create the contact request, open the 1:1 DM
/// room, stamp it with the request id so the callee-side auto-accept can find
/// it, then place a voice call.
///
/// Returns a [CallToConnectOutcome] describing what happened. Throws
/// (`DioException` / other) on API or Matrix failures so each caller keeps its
/// own error handling — notably the 409 "already contacts / already pending"
/// branch that the two sites handle differently.
Future<CallToConnectOutcome> startCallToConnect({
  required MatrixState matrix,
  required String mxid,
  String? initialMessage,
}) async {
  final voip = matrix.voipPlugin;
  // Don't stack a second call on top of a live one. Bail before creating any
  // server-side state so a stray trigger during a call is a clean no-op.
  if (voip == null || voip.voip.currentCID != null) {
    return const CallToConnectBusy();
  }

  final client = matrix.client;
  final message = (initialMessage == null || initialMessage.isEmpty)
      ? null
      : initialMessage;
  final outgoing = await TrustworkApiService.instance.createContactRequest(
    mxid,
    initialMessage: message,
  );

  // The backend creates a contact-request room where the caller is not a
  // member, so use a 1:1 DM room for the call. startDirectChat already waits
  // for the room to appear in sync; waitForRoomInSync is a belt-and-braces
  // fallback in case it hasn't fully materialized yet.
  final callRoomId = await client.startDirectChat(mxid);
  var room = client.getRoomById(callRoomId);
  if (room == null) {
    try {
      await client.waitForRoomInSync(callRoomId, join: true);
    } catch (_) {}
    room = client.getRoomById(callRoomId);
  }
  if (room == null) return const CallToConnectRoomUnavailable();

  // Stamp the contact request ID so the callee-side auto-accept can find it.
  await room.sendEvent(
    {'request_id': outgoing.id},
    type: 'com.trustwork.contact_request',
  );

  // Re-check in case a call became live during the awaits above.
  if (voip.voip.currentCID != null) return const CallToConnectBusy();
  await voip.voip.inviteToCall(room, CallType.kVoice);
  return CallToConnectStarted(callRoomId);
}
