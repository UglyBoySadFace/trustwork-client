import 'dart:async';

import 'package:flutter/material.dart';

import 'package:api_client/api_client.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

enum _AdminLeaveChoice { transfer, delete }

/// Leaves [room], keeping Trustwork group membership and the underlying
/// Matrix room in sync. For a Trustwork group room, the Trustwork
/// `leaveGroup` API is called first and the Matrix room is only left once
/// that succeeds — Trustwork is the system that actually models "is this
/// person in the group." Non-group rooms fall back to a plain Matrix leave.
///
/// The backend rejects an admin's leave outright (409): a group whose admin
/// is gone can never gain a member again, so the admin must transfer the
/// role or delete the group first. If the current user is the group's
/// admin, this offers that choice instead of calling `leaveGroup`, which
/// would just 409.
///
/// Returns whether the leave (or delete) completed.
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
    return _handleAdminLeave(context, room, group);
  }

  final result = await showFutureLoadingDialog(
    context: context,
    future: () => TrustworkApiService.instance.leaveGroup(group.id),
  );
  if (result.error != null) return false;
  unawaited(GroupsService.instance.refresh().catchError((_) {}));
  unawaited(room.leave().catchError((_) {}));
  return true;
}

Future<bool> _handleAdminLeave(
  BuildContext context,
  Room room,
  GroupSummary group,
) async {
  final choice = await showModalActionPopup<_AdminLeaveChoice>(
    context: context,
    title: L10n.of(context).leaveGroup,
    message: L10n.of(context).adminMustTransferOrDeleteToLeave,
    cancelLabel: L10n.of(context).cancel,
    actions: [
      AdaptiveModalAction(
        value: _AdminLeaveChoice.transfer,
        label: L10n.of(context).transferAdminAndLeave,
      ),
      AdaptiveModalAction(
        value: _AdminLeaveChoice.delete,
        label: L10n.of(context).deleteGroupInstead,
        isDestructive: true,
      ),
    ],
  );
  if (choice == null) return false;
  if (choice == _AdminLeaveChoice.delete) {
    return deleteTrustworkGroup(context, group.id);
  }

  if (!context.mounted) return false;
  final detail = await _fetchGroupDetail(context, group.id);
  if (detail == null || !context.mounted) return false;
  final newAdminMxid = await _pickTransferTarget(
    context,
    detail,
    room.client.userID,
  );
  if (newAdminMxid == null) return false;

  if (!context.mounted) return false;
  final transferResult = await showFutureLoadingDialog(
    context: context,
    future: () =>
        TrustworkApiService.instance.transferAdmin(group.id, newAdminMxid),
  );
  if (transferResult.error != null) return false;
  unawaited(GroupsService.instance.refresh().catchError((_) {}));

  if (!context.mounted) return false;
  final leaveResult = await showFutureLoadingDialog(
    context: context,
    future: () => TrustworkApiService.instance.leaveGroup(group.id),
  );
  if (leaveResult.error != null) return false;
  unawaited(GroupsService.instance.refresh().catchError((_) {}));
  unawaited(room.leave().catchError((_) {}));
  return true;
}

Future<GroupDetail?> _fetchGroupDetail(
  BuildContext context,
  int groupId,
) async {
  final result = await showFutureLoadingDialog(
    context: context,
    future: () => TrustworkApiService.instance.getGroupDetail(groupId),
  );
  return result.result;
}

Future<String?> _pickTransferTarget(
  BuildContext context,
  GroupDetail detail,
  String? currentUserId,
) async {
  final candidates = detail.members
      .where((m) => m.status == 'joined' && m.matrixUserId != currentUserId)
      .toList();
  if (candidates.isEmpty) {
    await showOkAlertDialog(
      context: context,
      title: L10n.of(context).transferAdmin,
      message: L10n.of(context).noEligibleTransferTargets,
    );
    return null;
  }
  return showModalActionPopup<String>(
    context: context,
    title: L10n.of(context).transferAdmin,
    cancelLabel: L10n.of(context).cancel,
    actions: [
      for (final member in candidates)
        AdaptiveModalAction(
          value: member.matrixUserId!,
          label: member.displayName.isEmpty
              ? member.matrixUserId!
              : member.displayName,
        ),
    ],
  );
}

/// Deletes [groupId] after confirmation (admin only). No `room.leave()` call
/// needed afterward — the backend purges the Matrix room server-side via
/// the Admin API, forcing every member out; the client's room disappears on
/// the next sync.
Future<bool> deleteTrustworkGroup(BuildContext context, int groupId) async {
  final confirmed = await showOkCancelAlertDialog(
    context: context,
    title: L10n.of(context).deleteGroup,
    message: L10n.of(context).deleteGroupConfirmation,
    okLabel: L10n.of(context).delete,
    cancelLabel: L10n.of(context).cancel,
    isDestructive: true,
  );
  if (confirmed != OkCancelResult.ok) return false;
  if (!context.mounted) return false;
  final result = await showFutureLoadingDialog(
    context: context,
    future: () => TrustworkApiService.instance.deleteGroup(groupId),
  );
  if (result.error != null) return false;
  unawaited(GroupsService.instance.refresh().catchError((_) {}));
  return true;
}

/// Transfers admin of [detail]'s group to another joined member, chosen via
/// picker. Standalone action (not part of a leave flow) for
/// `GroupManagePage`.
Future<bool> transferTrustworkGroupAdmin(
  BuildContext context,
  GroupDetail detail,
  String? currentUserId,
) async {
  final newAdminMxid = await _pickTransferTarget(
    context,
    detail,
    currentUserId,
  );
  if (newAdminMxid == null || !context.mounted) return false;
  final result = await showFutureLoadingDialog(
    context: context,
    future: () =>
        TrustworkApiService.instance.transferAdmin(detail.id, newAdminMxid),
  );
  if (result.error != null) return false;
  unawaited(GroupsService.instance.refresh().catchError((_) {}));
  return true;
}
