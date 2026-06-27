import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/invitation_selection/invitation_selection_view.dart';
import 'package:fluffychat/utils/restricted_user_search.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class InvitationSelection extends StatefulWidget {
  final String roomId;
  const InvitationSelection({super.key, required this.roomId});

  @override
  InvitationSelectionController createState() =>
      InvitationSelectionController();
}

class InvitationSelectionController extends State<InvitationSelection> {
  TextEditingController controller = TextEditingController();
  late String currentSearchTerm;
  List<Profile> foundProfiles = [];
  Timer? coolDown;

  String? get roomId => widget.roomId;

  Future<List<User>> getContacts(BuildContext context) async {
    final client = Matrix.of(context).client;
    final room = client.getRoomById(roomId!)!;
    final contactsCache = Matrix.of(context).contactsCache;

    final participants = (room.summary.mJoinedMemberCount ?? 0) > 100
        ? room.getParticipants()
        : await room.requestParticipants();
    participants.removeWhere(
      (u) => ![Membership.join, Membership.invite].contains(u.membership),
    );
    final contacts = client.rooms
        .where((r) => r.isDirectChat)
        .map((r) => r.unsafeGetUserFromMemoryOrFallback(r.directChatMatrixID!))
        .toList();
    contacts.sort(
      (a, b) => contactsCache.label(a.id).toLowerCase().compareTo(
        contactsCache.label(b.id).toLowerCase(),
      ),
    );
    return contacts;
  }

  void inviteAction(BuildContext context, String id, String displayname) async {
    final room = Matrix.of(context).client.getRoomById(roomId!)!;
    final mustConnectFirst = L10n.of(context).mustBeContactFirst;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () async {
        try {
          return await room.invite(id);
        } on MatrixException catch (e) {
          if (e.error == MatrixError.M_FORBIDDEN) {
            throw Exception(mustConnectFirst);
          }
          rethrow;
        }
      },
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L10n.of(context).contactHasBeenInvitedToTheGroup),
        ),
      );
    }
  }

  void searchUserWithCoolDown(String text) {
    coolDown?.cancel();
    coolDown = Timer(
      const Duration(milliseconds: 500),
      () => searchUser(context, text),
    );
  }

  void searchUser(BuildContext context, String text) {
    coolDown?.cancel();
    if (text.isEmpty) {
      setState(() => foundProfiles = []);
      return;
    }
    currentSearchTerm = text;
    setState(
      () => foundProfiles = restrictedUserSearch(
        Matrix.of(context).contactsCache,
        text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => InvitationSelectionView(this);
}
