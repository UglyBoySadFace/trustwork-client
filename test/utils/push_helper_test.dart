import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/push_helper.dart';
import 'test_client.dart';

const roomId = '!1234:fakeServer.notExisting';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Client client;
  late Room room;

  setUpAll(() async {
    client = await prepareTestClient(loggedIn: true);
    room = Room(id: roomId, client: client);
  });

  Event buildGroupInviteEvent({String? inviteeMatrixId = '@bob:server'}) =>
      Event(
        content: <String, dynamic>{
          'group_id': 5,
          'group_name': 'Hikers',
          'admin_matrix_id': '@admin:server',
          'admin_display_name': 'Admin',
          'invitee_matrix_id': ?inviteeMatrixId,
          'status': 'invited',
        },
        type: 'com.trustwork.group_invite',
        eventId: '\$invite5',
        senderId: '@trustwork-bot:server',
        originServerTs: DateTime.now(),
        room: room,
      );

  group('isGroupInviteForOtherUser', () {
    test('suppresses the notification for the inviting admin', () {
      final event = buildGroupInviteEvent(inviteeMatrixId: '@bob:server');
      expect(
        isGroupInviteForOtherUser(event, client.userID),
        isTrue,
        reason:
            'client.userID (${client.userID}) is not the invitee, so the '
            'admin should not be notified about their own invite.',
      );
    });

    test('does not suppress the notification for the actual invitee', () {
      final event = buildGroupInviteEvent(inviteeMatrixId: client.userID);
      expect(isGroupInviteForOtherUser(event, client.userID), isFalse);
    });

    test('fails open when invitee_matrix_id is missing', () {
      final event = buildGroupInviteEvent(inviteeMatrixId: null);
      expect(isGroupInviteForOtherUser(event, client.userID), isFalse);
    });

    test('ignores events of a different type', () {
      final event = Event(
        content: const <String, dynamic>{'body': 'hi'},
        type: 'm.room.message',
        eventId: '\$msg1',
        senderId: '@admin:server',
        originServerTs: DateTime.now(),
        room: room,
      );
      expect(isGroupInviteForOtherUser(event, client.userID), isFalse);
    });
  });
}
