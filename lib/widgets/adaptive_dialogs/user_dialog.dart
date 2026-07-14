import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dio/dio.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/presence_builder.dart';
import '../../utils/url_launcher.dart';
import '../future_loading_dialog.dart';
import '../hover_builder.dart';
import '../matrix.dart';
import '../mxc_image_viewer.dart';

class UserDialog extends StatelessWidget {
  static Future<void> show({
    required BuildContext context,
    required Profile profile,
    bool noProfileWarning = false,
  }) => showAdaptiveDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) =>
        UserDialog(profile, noProfileWarning: noProfileWarning),
  );

  final Profile profile;
  final bool noProfileWarning;

  const UserDialog(this.profile, {this.noProfileWarning = false, super.key});

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final dmRoomId = client.getDirectChatFromUserId(profile.userId);
    final displayname = Matrix.of(context).contactsCache.label(
      profile.userId,
    );
    var copied = false;
    final theme = Theme.of(context);
    final avatar = profile.avatarUrl;
    return AlertDialog.adaptive(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256),
        child: Center(child: Text(displayname, textAlign: TextAlign.center)),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 256, maxHeight: 256),
        child: PresenceBuilder(
          userId: profile.userId,
          client: Matrix.of(context).client,
          builder: (context, presence) {
            if (presence == null) return const SizedBox.shrink();
            final statusMsg = presence.statusMsg;
            final lastActiveTimestamp = presence.lastActiveTimestamp;
            final presenceText = presence.currentlyActive == true
                ? L10n.of(context).currentlyActive
                : lastActiveTimestamp != null
                ? L10n.of(context).lastActiveAgo(
                    lastActiveTimestamp.localizedTimeShort(context),
                  )
                : null;
            return SingleChildScrollView(
              child: Column(
                spacing: 8,
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                children: [
                  Center(
                    child: Avatar(
                      mxContent: avatar,
                      name: displayname,
                      size: Avatar.defaultSize * 2,
                      onTap: avatar != null
                          ? () => showDialog(
                              context: context,
                              builder: (_) => MxcImageViewer(avatar),
                            )
                          : null,
                    ),
                  ),
                  HoverBuilder(
                    builder: (context, hovered) => StatefulBuilder(
                      builder: (context, setState) => MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: profile.userId),
                            );
                            setState(() {
                              copied = true;
                            });
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: AnimatedScale(
                                      duration: FluffyThemes.animationDuration,
                                      curve: FluffyThemes.animationCurve,
                                      scale: hovered
                                          ? 1.33
                                          : copied
                                          ? 1.25
                                          : 1.0,
                                      child: Icon(
                                        copied
                                            ? Icons.check_circle
                                            : Icons.copy,
                                        size: 12,
                                        color: copied ? Colors.green : null,
                                      ),
                                    ),
                                  ),
                                ),
                                TextSpan(text: profile.userId),
                              ],
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (presenceText != null)
                    Text(
                      presenceText,
                      style: const TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  if (statusMsg != null)
                    SelectableLinkify(
                      text: statusMsg,
                      textScaleFactor: MediaQuery.textScalerOf(
                        context,
                      ).scale(1),
                      textAlign: TextAlign.center,
                      options: const LinkifyOptions(humanize: false),
                      linkStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.colorScheme.primary,
                      ),
                      onOpen: (url) =>
                          UrlLauncher(context, url.url).launchUrl(),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        if (client.userID != profile.userId) ...[
          if (Matrix.of(context).contactsCache.isContact(profile.userId))
            AdaptiveDialogAction(
              borderRadius: AdaptiveDialogAction.topRadius,
              bigButtons: true,
              onPressed: () async {
                final router = GoRouter.of(context);
                final roomIdResult = await showFutureLoadingDialog(
                  context: context,
                  future: () => client.startDirectChat(profile.userId),
                );
                final roomId = roomIdResult.result;
                if (roomId == null) return;
                if (context.mounted) Navigator.of(context).pop();
                router.go('/rooms/$roomId');
              },
              child: Text(
                dmRoomId == null
                    ? L10n.of(context).startConversation
                    : L10n.of(context).sendAMessage,
              ),
            )
          else ...[
            _SendRequestAction(userId: profile.userId),
            _CallToConnectAction(userId: profile.userId),
          ],
          AdaptiveDialogAction(
            bigButtons: true,
            borderRadius: AdaptiveDialogAction.centerRadius,
            onPressed: () {
              final router = GoRouter.of(context);
              Navigator.of(context).pop();
              router.go(
                '/rooms/settings/security/ignorelist',
                extra: profile.userId,
              );
            },
            child: Text(
              L10n.of(context).ignoreUser,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
        AdaptiveDialogAction(
          bigButtons: true,
          borderRadius: AdaptiveDialogAction.bottomRadius,
          onPressed: Navigator.of(context).pop,
          child: Text(L10n.of(context).close),
        ),
      ],
    );
  }
}

/// Shows a bottom sheet asking for an optional greeting message.
/// Returns the trimmed text, or null if the user skipped/dismissed.
Future<String?> _askForInitialMessage(BuildContext context) async {
  final l10n = L10n.of(context);
  final msgCtrl = TextEditingController();
  final result = await showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(ctx).bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.addAMessage,
              style: Theme.of(ctx).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: msgCtrl,
              autofocus: true,
              maxLength: 2000,
              maxLines: 4,
              minLines: 2,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: l10n.initialMessageHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(l10n.skip),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(ctx).pop(msgCtrl.text.trim()),
                    child: Text(l10n.sendContactRequest),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
  return result;
}

String? _findNewRoom(
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

class _SendRequestAction extends StatefulWidget {
  final String userId;

  const _SendRequestAction({required this.userId});

  @override
  State<_SendRequestAction> createState() => _SendRequestActionState();
}

class _SendRequestActionState extends State<_SendRequestAction> {
  bool _sending = false;

  Future<void> _send() async {
    final message = await _askForInitialMessage(context);
    if (!mounted) return;
    final router = GoRouter.of(context);
    setState(() => _sending = true);
    try {
      final matrixClient = Matrix.of(context).client;
      final knownRoomIds = matrixClient.rooms.map((r) => r.id).toSet();
      await TrustworkApiService.instance.createContactRequest(
        widget.userId,
        initialMessage: (message == null || message.isEmpty) ? null : message,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      await _navigateToRequestRoom(router, matrixClient, widget.userId, knownRoomIds);
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 409) {
        // Already contacts or a request is already pending — the local cache
        // may be stale (e.g. contacts created by a group join). Refresh it
        // and tell the user instead of failing silently.
        final matrix = Matrix.of(context);
        await matrix.refreshContactsAndGroups().catchError((_) {});
        if (!mounted) return;
        Navigator.of(context).pop();
        if (matrix.contactsCache.isContact(widget.userId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are already connected with this user.'),
            ),
          );
        } else {
          router.go('/rooms/contacts/requests');
        }
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TrustworkApiService.friendlyError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _navigateToRequestRoom(
    GoRouter router,
    Client matrixClient,
    String targetMxid,
    Set<String> knownRoomIds,
  ) async {
    if (!mounted) return;
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
    if (roomId != null) {
      router.go('/rooms/$roomId');
    } else {
      router.go('/rooms');
    }
  }

  @override
  Widget build(BuildContext context) => AdaptiveDialogAction(
    borderRadius: AdaptiveDialogAction.topRadius,
    bigButtons: true,
    onPressed: _sending ? null : _send,
    child: _sending
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          )
        : Text(L10n.of(context).sendContactRequest),
  );
}

class _CallToConnectAction extends StatefulWidget {
  final String userId;

  const _CallToConnectAction({required this.userId});

  @override
  State<_CallToConnectAction> createState() => _CallToConnectActionState();
}

class _CallToConnectActionState extends State<_CallToConnectAction> {
  bool _calling = false;

  Future<void> _call() async {
    final message = await _askForInitialMessage(context);
    if (!mounted) return;
    final router = GoRouter.of(context);
    setState(() => _calling = true);
    try {
      final matrixClient = Matrix.of(context).client;
      final outgoing = await TrustworkApiService.instance.createContactRequest(
        widget.userId,
        initialMessage: (message == null || message.isEmpty) ? null : message,
      );
      if (!mounted) return;
      // The backend creates a contact-request room where the caller is not a
      // member. Use a 1:1 DM room for the call instead.
      final callRoomId = await matrixClient.startDirectChat(widget.userId);
      if (!mounted) return;
      var room = matrixClient.getRoomById(callRoomId);
      if (room == null) {
        await for (final _ in matrixClient.onSync.stream.timeout(
          const Duration(seconds: 10),
          onTimeout: (sink) => sink.close(),
        )) {
          room = matrixClient.getRoomById(callRoomId);
          if (room != null) break;
        }
      }
      if (!mounted) return;
      if (room == null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room not available — request sent.')),
        );
        return;
      }
      // Stamp the contact request ID so the callee-side auto-accept can find it.
      await room.sendEvent(
        {'request_id': outgoing.id},
        type: 'com.trustwork.contact_request',
      );
      if (!mounted) return;
      final voipPlugin = Matrix.of(context).voipPlugin;
      if (voipPlugin == null) {
        Navigator.of(context).pop();
        return;
      }
      await voipPlugin.voip.inviteToCall(room, CallType.kVoice);
      if (!mounted) return;
      Navigator.of(context).pop();
      router.go('/rooms/$callRoomId');
    } on DioException catch (e) {
      if (!mounted) return;
      if (e.response?.statusCode == 409) {
        // Already contacts or a request is already pending — the local cache
        // may be stale (e.g. contacts created by a group join). Refresh it
        // and tell the user instead of failing silently.
        final matrix = Matrix.of(context);
        await matrix.refreshContactsAndGroups().catchError((_) {});
        if (!mounted) return;
        Navigator.of(context).pop();
        if (matrix.contactsCache.isContact(widget.userId)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are already connected with this user.'),
            ),
          );
        } else {
          router.go('/rooms/contacts/requests');
        }
        return;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(TrustworkApiService.friendlyError(e))),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _calling = false);
    }
  }

  @override
  Widget build(BuildContext context) => AdaptiveDialogAction(
    borderRadius: AdaptiveDialogAction.centerRadius,
    bigButtons: true,
    onPressed: _calling ? null : _call,
    child: _calling
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
          )
        : Text(L10n.of(context).callToConnect),
  );
}
