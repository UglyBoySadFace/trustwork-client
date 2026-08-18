import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

/// Leaves [room], keeping Trustwork group membership and the underlying
/// Matrix room in sync. For a Trustwork group room, the Trustwork
/// `leaveGroup` API is called first and the Matrix room is only left once
/// that succeeds — Trustwork is the system that actually models "is this
/// person in the group." Non-group rooms fall back to a plain Matrix leave.
///
/// If the current user is the group's admin, an extra warning is shown
/// first: the middleware has no group-delete or admin-transfer endpoint yet,
/// so an admin leave today is functionally a normal member leave (the group
/// persists with no admin) — the warning exists so the admin isn't
/// surprised by that once real deletion ships.
///
/// Returns whether the leave completed.
Future<bool> leaveTrustworkGroupOrRoom(BuildContext context, Room room) async {
  final group = GroupsService.instance.findByMatrixRoomId(room.id);
  if (group == null) {
    final result = await showFutureLoadingDialog(
      context: context,
      future: () => room.leave(),
    );
    return result.error == null;
  }

  if (group.admin.matrixUserId == room.client.userID) {
    if (!context.mounted) return false;
    final confirmed = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).leaveGroup,
      message: L10n.of(context).adminLeaveDeletesGroupWarning,
      okLabel: L10n.of(context).leave,
      cancelLabel: L10n.of(context).cancel,
      isDestructive: true,
    );
    if (confirmed != OkCancelResult.ok) return false;
  }

  if (!context.mounted) return false;
  final result = await showFutureLoadingDialog(
    context: context,
    future: () => TrustworkApiService.instance.leaveGroup(group.id),
  );
  if (result.error != null) return false;
  unawaited(GroupsService.instance.refresh().catchError((_) {}));
  unawaited(room.leave().catchError((_) {}));
  return true;
}
