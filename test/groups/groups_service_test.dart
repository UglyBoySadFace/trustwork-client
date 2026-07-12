import 'package:flutter_test/flutter_test.dart';

import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import '../utils/trustwork_test_helpers.dart';

Map<String, dynamic> groupJson({
  int id = 1,
  String name = 'Hikers',
  String? matrixRoomId = '!room:server',
  String myStatus = 'joined',
  int memberCount = 3,
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'admin': <String, dynamic>{
    'matrix_user_id': '@admin:server',
    'display_name': 'Admin',
  },
  'matrix_room_id': matrixRoomId,
  'my_status': myStatus,
  'member_count': memberCount,
};

Map<String, dynamic> groupDetailJson({
  int id = 1,
  String name = 'Hikers',
  String? matrixRoomId = '!room:server',
}) => <String, dynamic>{
  'id': id,
  'name': name,
  'admin': <String, dynamic>{
    'matrix_user_id': '@admin:server',
    'display_name': 'Admin',
  },
  'matrix_room_id': matrixRoomId,
  'my_status': 'joined',
  'members': <Object>[
    <String, dynamic>{
      'matrix_user_id': '@admin:server',
      'display_name': 'Admin',
      'status': 'joined',
      'is_admin': true,
    },
  ],
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    mockSecureStorage();
  });

  test('refresh populates the list and room-id lookup', () async {
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'GET' && options.path.endsWith('/groups')) {
        return jsonBody(200, <Object>[
          groupJson(id: 1, matrixRoomId: '!a:server'),
          // A group whose Matrix room hasn't propagated yet must still be
          // listed, just not resolvable by room ID.
          groupJson(id: 2, name: 'Pending', matrixRoomId: null),
        ]);
      }
      return jsonBody(404, <String, dynamic>{});
    });

    await GroupsService.instance.refresh();

    expect(GroupsService.instance.all.length, 2);
    expect(GroupsService.instance.findByMatrixRoomId('!a:server')?.id, 1);
    expect(GroupsService.instance.findById(2)?.name, 'Pending');
    expect(GroupsService.instance.findByMatrixRoomId('!missing:server'), null);
  });

  test('refresh replaces stale entries instead of merging', () async {
    var call = 0;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      call++;
      return jsonBody(200, <Object>[
        if (call == 1) groupJson(id: 1, matrixRoomId: '!a:server'),
        if (call > 1) groupJson(id: 9, matrixRoomId: '!b:server'),
      ]);
    });

    await GroupsService.instance.refresh();
    await GroupsService.instance.refresh();

    expect(GroupsService.instance.findById(1), null);
    expect(GroupsService.instance.findByMatrixRoomId('!a:server'), null);
    expect(GroupsService.instance.findByMatrixRoomId('!b:server')?.id, 9);
  });

  test('createGroup posts name and member list, parses the detail', () async {
    Map<String, dynamic>? posted;
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      if (options.method == 'POST' && options.path.endsWith('/groups')) {
        posted = decodeRequestBody(options.data);
        return jsonBody(201, groupDetailJson(matrixRoomId: '!new:server'));
      }
      return jsonBody(404, <String, dynamic>{});
    });

    final detail = await TrustworkApiService.instance.createGroup(
      'Hikers',
      <String>['@a:server', '@b:server'],
    );

    expect(posted?['name'], 'Hikers');
    expect(posted?['member_matrix_ids'], <String>['@a:server', '@b:server']);
    expect(detail.matrixRoomId, '!new:server');
    expect(detail.members.single.isAdmin, isTrue);
  });

  test('suggestMember omits a null message and sends a provided one',
      () async {
    final bodies = <Map<String, dynamic>>[];
    TrustworkApiService.instance.dio.httpClientAdapter = MockAdapter((
      options,
    ) async {
      bodies.add(decodeRequestBody(options.data));
      return jsonBody(201, <String, dynamic>{
        'id': 11,
        'status': 'pending',
        'created_at': '2026-07-01T12:00:00Z',
        'suggester': <String, dynamic>{
          'matrix_user_id': '@me:server',
          'display_name': 'Me',
        },
        'suggested_matrix_id': '@cand:server',
        'admin_knows_suggested': false,
      });
    });

    await TrustworkApiService.instance.suggestMember(7, '@cand:server');
    await TrustworkApiService.instance.suggestMember(
      7,
      '@cand:server',
      message: 'trust me',
    );

    expect(bodies[0]['suggested_matrix_id'], '@cand:server');
    expect(bodies[0].containsKey('message'), isFalse);
    expect(bodies[1]['message'], 'trust me');
  });
}
