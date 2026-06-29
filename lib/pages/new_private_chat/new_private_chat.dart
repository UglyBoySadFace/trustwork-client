import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_private_chat/new_private_chat_view.dart';
import 'package:fluffychat/pages/new_private_chat/qr_scanner_modal.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/restricted_user_search.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../widgets/adaptive_dialogs/user_dialog.dart';

class NewPrivateChat extends StatefulWidget {
  const NewPrivateChat({super.key});

  @override
  NewPrivateChatController createState() => NewPrivateChatController();
}

class NewPrivateChatController extends State<NewPrivateChat> {
  final TextEditingController controller = TextEditingController();
  final FocusNode textFieldFocus = FocusNode();

  Future<List<Profile>>? searchResponse;
  bool isSendingRequest = false;
  // 'pending' | 'accepted' | null
  String? sendRequestStatus;
  String? sendRequestError;

  Timer? _searchCoolDown;

  static const Duration _coolDown = Duration(milliseconds: 500);

  bool get looksLikeMxid {
    final text = controller.text.trim();
    return text.startsWith('@') && text.contains(':') && text.length > 4;
  }

  void searchUsers([String? input]) async {
    final searchTerm = input ?? controller.text;
    if (searchTerm.isEmpty) {
      _searchCoolDown?.cancel();
      setState(() {
        searchResponse = _searchCoolDown = null;
        sendRequestStatus = null;
        sendRequestError = null;
      });
      return;
    }

    setState(() {
      sendRequestStatus = null;
      sendRequestError = null;
    });
    _searchCoolDown?.cancel();
    _searchCoolDown = Timer(_coolDown, () {
      setState(() {
        searchResponse = _searchUser(searchTerm);
      });
    });
  }

  Future<void> sendContactRequest() async {
    if (!looksLikeMxid) {
      setState(() => sendRequestError = L10n.of(context).invalidMxid);
      return;
    }
    final mxid = controller.text.trim();
    setState(() {
      isSendingRequest = true;
      sendRequestError = null;
      sendRequestStatus = null;
    });
    try {
      final matrixClient = Matrix.of(context).client;
      final knownRoomIds = matrixClient.rooms.map((r) => r.id).toSet();
      await TrustworkApiService.instance.createContactRequest(mxid);
      if (!mounted) return;
      setState(() => isSendingRequest = false);
      await _navigateToRequestRoom(matrixClient, mxid, knownRoomIds);
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 409) {
        context.go('/rooms/contacts/requests');
        return;
      }
      setState(() {
        sendRequestError = TrustworkApiService.friendlyError(e);
        isSendingRequest = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        sendRequestError = e.toString();
        isSendingRequest = false;
      });
    }
  }

  // Waits up to 10s for the backend-created room to appear in the Matrix
  // client, then navigates there. Snapshots known rooms before the API call
  // so only genuinely new rooms are considered.
  Future<void> _navigateToRequestRoom(
    Client matrixClient,
    String targetMxid,
    Set<String> knownRoomIds,
  ) async {
    var roomId = _findNewRoom(matrixClient, targetMxid, knownRoomIds);
    if (roomId == null) {
      await for (final _ in matrixClient.onSync.stream.timeout(
        const Duration(seconds: 10),
        onTimeout: (sink) => sink.close(),
      )) {
        roomId = _findNewRoom(matrixClient, targetMxid, knownRoomIds);
        if (roomId != null) break;
      }
    }
    if (!mounted) return;
    if (roomId != null) {
      context.go('/rooms/$roomId');
    } else {
      context.go('/rooms');
    }
  }

  // Finds a room that (a) wasn't there before the API call and (b) has the
  // target as a member. Doesn't rely on lastEvent or m.direct.
  static String? _findNewRoom(
    Client client,
    String targetMxid,
    Set<String> knownRoomIds,
  ) {
    for (final room in client.rooms) {
      if (knownRoomIds.contains(room.id)) continue;
      if (room.getParticipants().any((m) => m.id == targetMxid)) {
        return room.id;
      }
    }
    return null;
  }

  Future<List<Profile>> _searchUser(String searchTerm) => Future.value(
    restrictedUserSearch(Matrix.of(context).contactsCache, searchTerm),
  );

  void inviteAction() => FluffyShare.shareInviteLink(context);

  void openScannerAction() async {
    if (PlatformInfos.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt < 21) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).unsupportedAndroidVersionLong),
          ),
        );
        return;
      }
    }
    await showAdaptiveBottomSheet(
      context: context,
      builder: (_) => QrScannerModal(
        onScan: (link) => UrlLauncher(context, link).openMatrixToUrl(),
      ),
    );
  }

  void copyUserId() async {
    await Clipboard.setData(
      ClipboardData(text: Matrix.of(context).client.userID!),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(L10n.of(context).copiedToClipboard)));
  }

  void openUserModal(Profile profile) =>
      UserDialog.show(context: context, profile: profile);

  @override
  Widget build(BuildContext context) => NewPrivateChatView(this);
}
