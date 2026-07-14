import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:app_links/app_links.dart';
import 'package:collection/collection.dart';
import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/onboarding/onboarding_flow_coordinator.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/contacts/contacts_cache.dart';
import 'package:fluffychat/utils/data_sharing/data_sharing_service.dart';
import 'package:fluffychat/utils/full_screen_intent_helper.dart';
import 'package:fluffychat/utils/groups/groups_service.dart';
import 'package:fluffychat/utils/init_with_restore.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_file_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/trustwork_api_service.dart';
import 'package:fluffychat/utils/uia_request_manager.dart';
import 'package:fluffychat/utils/voip_plugin.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../config/setting_keys.dart';
import '../pages/key_verification/key_verification_dialog.dart';
import '../utils/account_bundles.dart';
import '../utils/background_push.dart';
import 'local_notifications_extension.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Matrix extends StatefulWidget {
  final Widget? child;

  final List<Client> clients;

  final Map<String, String>? queryParameters;

  final SharedPreferences store;

  const Matrix({
    this.child,
    required this.clients,
    required this.store,
    this.queryParameters,
    super.key,
  });

  @override
  MatrixState createState() => MatrixState();

  /// Returns the (nearest) Client instance of your application.
  static MatrixState of(BuildContext context) =>
      Provider.of<MatrixState>(context, listen: false);
}

class MatrixState extends State<Matrix> with WidgetsBindingObserver {
  int _activeClient = -1;
  String? activeBundle;

  SharedPreferences get store => widget.store;

  XFile? loginAvatar;
  String? loginUsername;
  bool? loginRegistrationSupported;

  BackgroundPush? backgroundPush;

  Client get client {
    if (_activeClient < 0 || _activeClient >= widget.clients.length) {
      return currentBundle!.first!;
    }
    return widget.clients[_activeClient];
  }

  VoipPlugin? voipPlugin;

  bool get isMultiAccount => widget.clients.length > 1;

  int getClientIndexByMatrixId(String matrixId) =>
      widget.clients.indexWhere((client) => client.userID == matrixId);

  late String currentClientSecret;
  RequestTokenResponse? currentThreepidCreds;

  void setActiveClient(Client? cl) {
    final i = widget.clients.indexWhere((c) => c == cl);
    if (i != -1) {
      _activeClient = i;
      // TODO: Multi-client VoiP support
      createVoipPlugin();
    } else {
      Logs().w('Tried to set an unknown client ${cl!.userID} as active');
    }
  }

  List<Client?>? get currentBundle {
    if (!hasComplexBundles) {
      return List.from(widget.clients);
    }
    final bundles = accountBundles;
    if (bundles.containsKey(activeBundle)) {
      return bundles[activeBundle];
    }
    return bundles.values.first;
  }

  Map<String?, List<Client?>> get accountBundles {
    final resBundles = <String?, List<_AccountBundleWithClient>>{};
    for (var i = 0; i < widget.clients.length; i++) {
      final bundles = widget.clients[i].accountBundles;
      for (final bundle in bundles) {
        if (bundle.name == null) {
          continue;
        }
        resBundles[bundle.name] ??= [];
        resBundles[bundle.name]!.add(
          _AccountBundleWithClient(client: widget.clients[i], bundle: bundle),
        );
      }
    }
    for (final b in resBundles.values) {
      b.sort(
        (a, b) => a.bundle!.priority == null
            ? 1
            : b.bundle!.priority == null
            ? -1
            : a.bundle!.priority!.compareTo(b.bundle!.priority!),
      );
    }
    return resBundles.map(
      (k, v) => MapEntry(k, v.map((vv) => vv.client).toList()),
    );
  }

  bool get hasComplexBundles => accountBundles.values.any((v) => v.length > 1);

  Client? _loginClientCandidate;

  AudioPlayer? audioPlayer;
  final ValueNotifier<String?> voiceMessageEventId = ValueNotifier(null);

  Future<Client> getLoginClient() async {
    if (widget.clients.isNotEmpty && !client.isLogged()) {
      return client;
    }
    final candidate = _loginClientCandidate ??=
        await ClientManager.createClient(
            '${AppSettings.applicationName.value}-${DateTime.now().millisecondsSinceEpoch}',
            store,
          )
          ..onLoginStateChanged.stream
              .where((l) => l == LoginState.loggedIn)
              .first
              .then((_) {
                if (!widget.clients.contains(_loginClientCandidate)) {
                  widget.clients.add(_loginClientCandidate!);
                }
                ClientManager.addClientNameToStore(
                  _loginClientCandidate!.clientName,
                  store,
                );
                _registerSubs(_loginClientCandidate!.clientName);
                _loginClientCandidate = null;
                FluffyChatApp.router.go('/backup');
              });
    if (widget.clients.isEmpty) widget.clients.add(candidate);
    return candidate;
  }

  Client? getClientByName(String name) =>
      widget.clients.firstWhereOrNull((c) => c.clientName == name);

  final onRoomKeyRequestSub = <String, StreamSubscription>{};
  final onKeyVerificationRequestSub = <String, StreamSubscription>{};
  final onNotification = <String, StreamSubscription>{};
  final onLoginStateChanged = <String, StreamSubscription<LoginState>>{};
  final onUiaRequest = <String, StreamSubscription<UiaRequest>>{};
  final dataSharingServices = <String, DataSharingService>{};
  final _incomingDataReqSubs =
      <String, StreamSubscription<IncomingDataRequest>>{};
  final _roomLeaveSubs = <String, StreamSubscription>{};
  final _contactAcceptedSubs = <String, StreamSubscription>{};
  final _groupMemberJoinSubs = <String, StreamSubscription>{};
  Timer? _groupJoinRefreshDebounce;
  final contactsCache = ContactsCache();
  final incomingContactRequestCount = ValueNotifier<int>(0);
  /// Display name sourced from the Trustwork middleware (BankID). Populated on
  /// startup and after login. Use this instead of the Matrix profile which may
  /// be absent when the homeserver rejects profile writes.
  String? trustworkDisplayName;
  StreamSubscription<void>? _twAuthExpiredSub;
  StreamSubscription<Uri>? _verifyLinkSub;
  DataSharingService? get dataSharingService =>
      dataSharingServices[client.clientName];

  String? _cachedPassword;
  Timer? _cachedPasswordClearTimer;

  String? get cachedPassword => _cachedPassword;

  set cachedPassword(String? p) {
    Logs().d('Password cached');
    _cachedPasswordClearTimer?.cancel();
    _cachedPassword = p;
    _cachedPasswordClearTimer = Timer(const Duration(minutes: 10), () {
      _cachedPassword = null;
      Logs().d('Cached Password cleared');
    });
  }

  String? get activeRoomId {
    final route = FluffyChatApp.router.routeInformationProvider.value.uri.path;
    if (!route.startsWith('/rooms/')) return null;
    return route.split('/')[2];
  }

  final linuxNotifications = PlatformInfos.isLinux
      ? NotificationsClient()
      : null;
  final Map<String, int> linuxNotificationIds = {};

  Future<void> _syncDisplayName() async {
    final c = client;
    if (!c.isLogged() || c.userID == null) return;

    // Resolve the display name from our middleware (BankID source of truth).
    // Fall back to the MXID localpart so the Synapse profile row is at least
    // created even when the Trustwork API is temporarily unavailable.
    String displayName;
    try {
      final profile = await TrustworkApiService.instance.getMe();
      displayName = profile.displayName;
    } catch (e) {
      Logs().w('[TW] getMe failed during display name sync, using localpart: $e');
      displayName = c.userID!.localpart ?? c.userID!;
    }

    trustworkDisplayName = displayName;

    try {
      await c.setProfileField(
        c.userID!,
        'displayname',
        {'displayname': displayName},
      );
    } catch (e) {
      Logs().w('[TW] setProfileField failed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    contactsCache.loadFromStore(store);
    if (widget.clients.any((c) => c.isLogged())) {
      unawaited(_refreshContactsAndMarkDms(client));
      unawaited(_syncDisplayName());
    }
    initMatrix();
    _twAuthExpiredSub =
        TrustworkApiService.instance.onAuthExpired.listen((_) {
      // Don't tear down an active call — data sharing will just show an error.
      // Tokens are already cleared, so the next Trustwork request after the
      // call ends will re-fire this event and trigger the redirect then.
      if (voipPlugin?.overlayEntry != null) return;
      final loggedIn = widget.clients.where((c) => c.isLogged()).toList();
      if (loggedIn.isEmpty) {
        FluffyChatApp.router.go('/');
        return;
      }
      for (final c in loggedIn) {
        unawaited(
          c.logout().catchError((_) => FluffyChatApp.router.go('/')),
        );
      }
      // Navigation is handled by onLoginStateChanged → '/'.
    });
    unawaited(
      TrustworkApiService.instance.checkAuthOnStartup(
        requireAuth: AppSettings.hasSeenOnboarding.value,
      ),
    );
    _wireVerifyDeepLinks();
  }

  void _registerSubs(String name) {
    final c = getClientByName(name);
    if (c == null) {
      Logs().w(
        'Attempted to register subscriptions for non-existing client $name',
      );
      return;
    }
    onRoomKeyRequestSub[name] ??= c.onRoomKeyRequest.stream.listen((
      RoomKeyRequest request,
    ) async {
      if (widget.clients.any(
        ((cl) =>
            cl.userID == request.requestingDevice.userId &&
            cl.identityKey == request.requestingDevice.curve25519Key),
      )) {
        Logs().i(
          '[Key Request] Request is from one of our own clients, forwarding the key...',
        );
        await request.forwardKey();
      }
    });
    onKeyVerificationRequestSub[name] ??= c.onKeyVerificationRequest.stream
        .listen((KeyVerification request) async {
          var hidPopup = false;
          request.onUpdate = () {
            if (!hidPopup &&
                {
                  KeyVerificationState.done,
                  KeyVerificationState.error,
                }.contains(request.state)) {
              FluffyChatApp.router.pop('dialog');
            }
            hidPopup = true;
          };
          request.onUpdate = null;
          hidPopup = true;
          await KeyVerificationDialog(request: request).show(
            FluffyChatApp.router.routerDelegate.navigatorKey.currentContext ??
                context,
          );
        });
    onLoginStateChanged[name] ??= c.onLoginStateChanged.stream.listen((state) {
      if (state == LoginState.loggedIn) {
        unawaited(_refreshContactsAndMarkDms(c));
      }
      final loggedInWithMultipleClients = widget.clients.length > 1;
      if (state == LoginState.loggedOut) {
        _cancelSubs(c.clientName);
        widget.clients.remove(c);
        ClientManager.removeClientNameFromStore(c.clientName, store);
        InitWithRestoreExtension.deleteSessionBackup(name);
      }
      if (loggedInWithMultipleClients && state != LoginState.loggedIn) {
        ScaffoldMessenger.of(
          FluffyChatApp.router.routerDelegate.navigatorKey.currentContext ??
              context,
        ).showSnackBar(
          SnackBar(content: Text(L10n.of(context).oneClientLoggedOut)),
        );

        if (state != LoginState.loggedIn) {
          FluffyChatApp.router.go('/rooms');
        }
      } else {
        FluffyChatApp.router.go(
          state == LoginState.loggedIn ? '/backup' : '/',
        );
      }
    });
    onUiaRequest[name] ??= c.onUiaRequest.stream.listen(uiaRequestHandler);
    dataSharingServices[name] ??= DataSharingService(c);
    _incomingDataReqSubs[name] ??= dataSharingServices[name]!
        .incomingRequests
        .listen((req) => _autoApproveDataRequest(name, req));
    _roomLeaveSubs[name] ??= c.onRoomState.stream
        .where(
          (update) =>
              update.state.stateKey == c.userID &&
              update.state.content['membership'] == 'leave',
        )
        .listen((_) => unawaited(_refreshContactsAndMarkDms(c)));
    _contactAcceptedSubs[name] ??= c.onTimelineEvent.stream
        .where((e) => e.type == 'com.trustwork.contact_accepted')
        .listen((_) => unawaited(_refreshContactsAndMarkDms(c)));
    // Someone new joining a Trustwork group means the middleware just
    // created a contact between them and every member — refresh so their
    // real name replaces the raw Matrix ID without waiting for app resume.
    _groupMemberJoinSubs[name] ??= c.onRoomState.stream
        .where(
          (update) =>
              update.state.content['membership'] == 'join' &&
              update.state.stateKey != c.userID &&
              !contactsCache.isContact(update.state.stateKey ?? '') &&
              GroupsService.instance.findByMatrixRoomId(update.roomId) !=
                  null,
        )
        .listen((_) => _scheduleGroupContactsRefresh(c));
    if (PlatformInfos.isWeb || PlatformInfos.isLinux) {
      c.onSync.stream.first.then((s) {
        html.Notification.requestPermission();
        onNotification[name] ??= c.onNotification.stream.listen(
          showLocalNotification,
        );
      });
    }
  }

  void _cancelSubs(String name) {
    onRoomKeyRequestSub[name]?.cancel();
    onRoomKeyRequestSub.remove(name);
    onKeyVerificationRequestSub[name]?.cancel();
    onKeyVerificationRequestSub.remove(name);
    onLoginStateChanged[name]?.cancel();
    onLoginStateChanged.remove(name);
    onNotification[name]?.cancel();
    onNotification.remove(name);
    _incomingDataReqSubs[name]?.cancel();
    _incomingDataReqSubs.remove(name);
    _roomLeaveSubs[name]?.cancel();
    _roomLeaveSubs.remove(name);
    _contactAcceptedSubs[name]?.cancel();
    _contactAcceptedSubs.remove(name);
    _groupMemberJoinSubs[name]?.cancel();
    _groupMemberJoinSubs.remove(name);
    dataSharingServices[name]?.dispose();
    dataSharingServices.remove(name);
  }

  void _wireVerifyDeepLinks() {
    final appLinks = AppLinks();
    _verifyLinkSub = appLinks.uriLinkStream.listen(_handleAuthSuccessUri);
    unawaited(
      appLinks.getInitialLink().then(
        _handleAuthSuccessUri,
        onError: (_) {},
      ),
    );
  }

  void _handleAuthSuccessUri(Uri? uri) {
    if (uri == null) return;
    if (uri.scheme != AppConfig.appOpenUrlScheme || uri.host != 'auth-success') {
      return;
    }
    if (widget.clients.any((c) => c.isLogged())) return;
    unawaited(_loginFromAuthSuccess(uri.queryParameters));
  }

  Future<void> _loginFromAuthSuccess(Map<String, String> params) async {
    final accessToken = params['access_token'];
    final refreshToken = params['refresh_token'];
    final matrixUserId = params['matrix_user_id'];
    final matrixAccessToken = params['login_token'];
    final matrixDeviceId = params['matrix_device_id'];
    final matrixPassword = params['matrix_password'];

    if (accessToken == null || refreshToken == null) return;
    await TrustworkApiService.instance.saveTokens(accessToken, refreshToken);
    if (matrixPassword != null) {
      await TrustworkApiService.instance.saveMatrixPassword(matrixPassword);
    }
    if (matrixUserId == null ||
        matrixAccessToken == null ||
        matrixDeviceId == null) {
      return;
    }
    final loginClient = await getLoginClient();
    await loginClient.init(
      newToken: matrixAccessToken,
      newUserID: matrixUserId,
      newDeviceID: matrixDeviceId,
      newHomeserver: Uri.parse(AppConfig.matrixHomeserver),
      waitForFirstSync: false,
    );
    OnboardingFlowCoordinator.instance.reset();
    // onLoginStateChanged listener navigates to /backup on LoginState.loggedIn
  }

  void initMatrix() {
    for (final c in widget.clients) {
      _registerSubs(c.clientName);
    }

    if (PlatformInfos.isMobile) {
      backgroundPush = BackgroundPush(
        this,
        onFcmError: (errorMsg, {Uri? link}) async {
          final result = await showOkCancelAlertDialog(
            context:
                FluffyChatApp
                    .router
                    .routerDelegate
                    .navigatorKey
                    .currentContext ??
                context,
            title: L10n.of(context).pushNotificationsNotAvailable,
            message: errorMsg,
            okLabel: link == null
                ? L10n.of(context).ok
                : L10n.of(context).learnMore,
            cancelLabel: L10n.of(context).doNotShowAgain,
          );
          if (result == OkCancelResult.ok && link != null) {
            launchUrlString(
              link.toString(),
              mode: LaunchMode.externalApplication,
            );
          }
          if (result == OkCancelResult.cancel) {
            await AppSettings.showNoGoogle.setItem(true);
          }
        },
      );
    }

    createVoipPlugin();

    if (PlatformInfos.isAndroid) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final ctx =
            FluffyChatApp
                .router
                .routerDelegate
                .navigatorKey
                .currentContext ??
            context;
        await checkAndPromptFullScreenIntent(ctx);
      });
    }
  }

  // If there is an active call with the requester, the dialer UI handles the
  // prompt. Otherwise, ChatController handles it when the user opens the room.
  // DataSharingService buffers lastIncomingRequest for late subscribers.
  void _autoApproveDataRequest(String clientName, IncomingDataRequest req) {
    final c = getClientByName(clientName);
    if (c == null) return;
    final hasCallWithRequester = voipPlugin?.voip.calls.keys.any((key) {
      final room = c.getRoomById(key.roomId);
      return room?.directChatMatrixID == req.fromMatrixId;
    }) ?? false;
    if (hasCallWithRequester) return;
    // Non-call case: ChatController handles it when the user opens the room.
  }

  void createVoipPlugin() {
    voipPlugin?.dispose();
    voipPlugin = VoipPlugin(this);
  }

  Future<void> _refreshContactsAndMarkDms(Client c) async {
    // Best-effort: the groups list is refetched on the next trigger anyway
    // (login, resume, room leave, contact accepted).
    unawaited(GroupsService.instance.refresh().catchError((_) {}));
    await contactsCache.refresh(store);
    _markContactRoomsAsDm(c);
  }

  /// Refreshes the groups list and the contacts cache, awaiting both, so
  /// callers that just changed contact state server-side (e.g. joining a
  /// group creates contacts with every member) can show fresh names
  /// immediately.
  Future<void> refreshContactsAndGroups() async {
    await GroupsService.instance.refresh().catchError((_) {});
    await contactsCache.refresh(store);
    _markContactRoomsAsDm(client);
  }

  /// Debounced contacts refresh for group-member joins: entering a group
  /// replays one join state per member, so coalesce them into one request.
  void _scheduleGroupContactsRefresh(Client c) {
    _groupJoinRefreshDebounce?.cancel();
    _groupJoinRefreshDebounce = Timer(const Duration(seconds: 2), () {
      unawaited(_refreshContactsAndMarkDms(c));
    });
  }

  /// After refreshing the contacts cache, mark any 1:1 rooms with accepted
  /// contacts as DM rooms on this client too (handles the requester's side
  /// not calling addToDirectChat at acceptance time).
  void _markContactRoomsAsDm(Client c) {
    for (final room in c.rooms) {
      if (room.isDirectChat) continue;
      final participants = room.getParticipants();
      if (participants.length != 2) continue;
      final otherId = participants
          .where((m) => m.id != c.userID)
          .map((m) => m.id)
          .firstOrNull;
      if (otherId == null) continue;
      if (contactsCache.isContact(otherId)) {
        unawaited(room.addToDirectChat(otherId));
      }
    }
  }

  Future<void> refreshIncomingRequestCount() async {
    try {
      final requests =
          await TrustworkApiService.instance.getIncomingContactRequests();
      incomingContactRequestCount.value = requests.length;
    } catch (_) {
      // Best-effort — badge stays stale on error.
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground =
        state != AppLifecycleState.inactive &&
        state != AppLifecycleState.paused;
    for (final c in widget.clients) {
      c.syncPresence = state == AppLifecycleState.resumed
          ? null
          : PresenceType.unavailable;
      if (PlatformInfos.isMobile) {
        c.backgroundSync = foreground;
        c.requestHistoryOnLimitedTimeline = !foreground;
        Logs().v('Set background sync to', foreground);
      }
    }
    if (state == AppLifecycleState.resumed) {
      unawaited(_refreshContactsAndMarkDms(client));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _twAuthExpiredSub?.cancel();
    _verifyLinkSub?.cancel();

    onRoomKeyRequestSub.values.map((s) => s.cancel());
    onKeyVerificationRequestSub.values.map((s) => s.cancel());
    onLoginStateChanged.values.map((s) => s.cancel());
    onNotification.values.map((s) => s.cancel());
    for (final s in _incomingDataReqSubs.values) {
      s.cancel();
    }
    _incomingDataReqSubs.clear();
    for (final s in dataSharingServices.values) {
      s.dispose();
    }
    dataSharingServices.clear();
    _groupJoinRefreshDebounce?.cancel();
    for (final s in _groupMemberJoinSubs.values) {
      s.cancel();
    }
    _groupMemberJoinSubs.clear();
    incomingContactRequestCount.dispose();
    client.httpClient.close();

    linuxNotifications?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(create: (_) => this, child: widget.child);
  }

  Future<void> dehydrateAction(BuildContext context) async {
    final response = await showOkCancelAlertDialog(
      context: context,
      isDestructive: true,
      title: L10n.of(context).dehydrate,
      message: L10n.of(context).dehydrateWarning,
    );
    if (response != OkCancelResult.ok) {
      return;
    }
    final result = await showFutureLoadingDialog(
      context: context,
      future: client.exportDump,
    );
    final export = result.result;
    if (export == null) return;

    final exportBytes = Uint8List.fromList(const Utf8Codec().encode(export));

    final exportFileName =
        'fluffychat-export-${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}.fluffybackup';

    final file = MatrixFile(bytes: exportBytes, name: exportFileName);
    file.save(context);
  }
}

class _AccountBundleWithClient {
  final Client? client;
  final AccountBundle? bundle;

  _AccountBundleWithClient({this.client, this.bundle});
}
