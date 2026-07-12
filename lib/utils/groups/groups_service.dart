import 'package:api_client/api_client.dart';

import 'package:fluffychat/utils/trustwork_api_service.dart';

/// In-memory cache of the user's Trustwork groups, refreshed alongside the
/// contacts cache. Provides fast lookup of a group by its Matrix room ID so
/// UI code can tell whether a room is a Trustwork group.
class GroupsService {
  static final instance = GroupsService._();
  GroupsService._();

  List<GroupSummary> _groups = [];
  Map<String, GroupSummary> _byMatrixRoomId = {};

  List<GroupSummary> get all => List.unmodifiable(_groups);

  GroupSummary? findByMatrixRoomId(String matrixRoomId) =>
      _byMatrixRoomId[matrixRoomId];

  GroupSummary? findById(int id) {
    for (final g in _groups) {
      if (g.id == id) return g;
    }
    return null;
  }

  Future<void> refresh() async {
    final fetched = await TrustworkApiService.instance.listGroups();
    _groups = fetched.toList();
    _byMatrixRoomId = {
      for (final g in _groups)
        if (g.matrixRoomId != null) g.matrixRoomId!: g,
    };
  }
}
