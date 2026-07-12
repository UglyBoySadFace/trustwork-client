import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/new_group/new_group_view.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/matrix.dart';

class NewGroup extends StatefulWidget {
  final CreateGroupType createGroupType;
  const NewGroup({this.createGroupType = CreateGroupType.group, super.key});

  @override
  NewGroupController createState() => NewGroupController();
}

class NewGroupController extends State<NewGroup> {
  TextEditingController nameController = TextEditingController();

  // Space path only — Trustwork groups have no avatar or public toggle.
  bool publicGroup = false;
  bool groupCanBeFound = false;

  Uint8List? avatar;

  Uri? avatarUrl;

  Object? error;

  bool loading = false;

  /// Accepted contacts as `mxid -> display name`, sorted by name.
  late final List<MapEntry<String, String>> contacts;

  final Set<String> selectedMxids = {};

  CreateGroupType get createGroupType =>
      _createGroupType ?? widget.createGroupType;

  CreateGroupType? _createGroupType;

  @override
  void initState() {
    super.initState();
    contacts = Matrix.of(context).contactsCache.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
  }

  void setCreateGroupType(Set<CreateGroupType> b) =>
      setState(() => _createGroupType = b.single);

  void setPublicGroup(bool b) =>
      setState(() => publicGroup = groupCanBeFound = b);

  void setGroupCanBeFound(bool b) => setState(() => groupCanBeFound = b);

  void toggleContact(String mxid) => setState(() {
    if (!selectedMxids.remove(mxid)) selectedMxids.add(mxid);
  });

  void selectPhoto() async {
    final photo = await selectFiles(
      context,
      type: FileType.image,
      allowMultiple: false,
    );
    final bytes = await photo.singleOrNull?.readAsBytes();

    setState(() {
      avatarUrl = null;
      avatar = bytes;
    });
  }

  Future<void> _createGroup() async {
    final detail = await TrustworkApiService.instance.createGroup(
      nameController.text.trim(),
      selectedMxids.toList(),
    );
    unawaited(GroupsService.instance.refresh().catchError((_) {}));
    if (!mounted) return;
    final roomId = detail.matrixRoomId;
    if (roomId != null) {
      context.go('/rooms/$roomId');
    } else {
      // Matrix room not propagated yet — the group will appear once synced.
      context.go('/rooms');
    }
  }

  Future<void> _createSpace() async {
    if (!mounted) return;
    final spaceId = await Matrix.of(context).client.createRoom(
      preset: publicGroup
          ? sdk.CreateRoomPreset.publicChat
          : sdk.CreateRoomPreset.privateChat,
      creationContent: {'type': RoomCreationTypes.mSpace},
      visibility: publicGroup ? sdk.Visibility.public : null,
      roomAliasName: publicGroup
          ? nameController.text.trim().toLowerCase().replaceAll(' ', '_')
          : null,
      name: nameController.text.trim(),
      powerLevelContentOverride: {'events_default': 100},
      initialState: [
        if (avatar != null)
          sdk.StateEvent(
            type: sdk.EventTypes.RoomAvatar,
            content: {'url': avatarUrl.toString()},
          ),
      ],
    );
    if (!mounted) return;
    context.pop<String>(spaceId);
  }

  void submitAction([_]) async {
    final client = Matrix.of(context).client;

    try {
      if (nameController.text.trim().isEmpty) {
        setState(() => error = L10n.of(context).pleaseFillOut);
        return;
      }
      if (createGroupType == CreateGroupType.group &&
          selectedMxids.isEmpty) {
        setState(() => error = L10n.of(context).selectAtLeastOneContact);
        return;
      }

      setState(() {
        loading = true;
        error = null;
      });

      switch (createGroupType) {
        case CreateGroupType.group:
          await _createGroup();
        case CreateGroupType.space:
          final avatar = this.avatar;
          avatarUrl ??= avatar == null
              ? null
              : await client.uploadContent(avatar);
          if (!mounted) return;
          await _createSpace();
      }
    } on DioException catch (e) {
      setState(() {
        error = TrustworkApiService.friendlyError(e);
        loading = false;
      });
    } catch (e, s) {
      sdk.Logs().d('Unable to create group', e, s);
      setState(() {
        error = e;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => NewGroupView(this);
}

enum CreateGroupType { group, space }
