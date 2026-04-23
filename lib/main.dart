// Dart imports:
import 'dart:isolate';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_vodozemac/flutter_vodozemac.dart' as vod;
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/notification_background_handler.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'config/setting_keys.dart';
import 'utils/background_push.dart';
import 'widgets/fluffy_chat_app.dart';

ReceivePort? mainIsolateReceivePort;

void main() async {
  // Must be first: initialises ServicesBinding which platform channels depend on.
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformInfos.isAndroid) {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'call_notification_channel',
        channelName: 'Active Call',
        channelDescription: 'Keeps the call active in the background',
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
      ),
    );
  }

  // Register the FCM MethodChannel handler synchronously before the first
  // await. FcmSharedIsolateService.onMessageReceived() posts the incoming
  // message to the Dart event loop; if no handler is registered at that point
  // the Flutter channel silently drops the message. By pre-initialising here
  // the handler is in place before ClientManager.getClients() (which can take
  // several seconds) runs, so killed-app call notifications are no longer lost.
  if (PlatformInfos.isAndroid) {
    BackgroundPush.preinitFcm();
  }

  if (PlatformInfos.isAndroid) {
    final port = mainIsolateReceivePort = ReceivePort();
    IsolateNameServer.removePortNameMapping(AppConfig.mainIsolatePortName);
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      AppConfig.mainIsolatePortName,
    );
    await waitForPushIsolateDone();
  }

  final store = await AppSettings.init();
  Logs().i('Welcome to ${AppSettings.applicationName.value} <3');

  await vod.init(wasmPath: './assets/assets/vodozemac/');

  Logs().nativeColors = !PlatformInfos.isIOS;
  final clients = await ClientManager.getClients(store: store);

  // If the app starts in detached mode, we assume that it is in
  // background fetch mode for processing push notifications. This is
  // currently only supported on Android.
  if (PlatformInfos.isAndroid &&
      AppLifecycleState.detached == WidgetsBinding.instance.lifecycleState) {
    // Do not send online presences when app is in background fetch mode.
    for (final client in clients) {
      client.backgroundSync = false;
      client.syncPresence = PresenceType.offline;
    }

    // In the background fetch mode we do not want to waste ressources with
    // starting the Flutter engine but process incoming push notifications.
    BackgroundPush.clientOnly(clients.first);
    // To start the flutter engine afterwards we add an custom observer.
    WidgetsBinding.instance.addObserver(AppStarter(clients, store));
    Logs().i(
      '${AppSettings.applicationName.value} started in background-fetch mode. No GUI will be created unless the app is no longer detached.',
    );
    return;
  }

  // Started in foreground mode.
  Logs().i(
    '${AppSettings.applicationName.value} started in foreground mode. Rendering GUI...',
  );
  await startGui(clients, store);
}

/// Fetch the pincode for the applock and start the flutter engine.
Future<void> startGui(List<Client> clients, SharedPreferences store) async {
  // Fetch the pin for the applock if existing for mobile applications.
  String? pin;
  if (PlatformInfos.isMobile) {
    try {
      pin = await const FlutterSecureStorage().read(
        key: 'chat.fluffy.app_lock',
      );
    } catch (e, s) {
      Logs().d('Unable to read PIN from Secure storage', e, s);
    }
  }

  // Preload first client
  final firstClient = clients.firstOrNull;
  await firstClient?.roomsLoading;
  await firstClient?.accountDataLoading;

  runApp(FluffyChatApp(clients: clients, pincode: pin, store: store));
}

/// Watches the lifecycle changes to start the application when it
/// is no longer detached.
class AppStarter with WidgetsBindingObserver {
  final List<Client> clients;
  final SharedPreferences store;
  bool guiStarted = false;

  AppStarter(this.clients, this.store);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (guiStarted) return;
    if (state == AppLifecycleState.detached) return;

    Logs().i(
      '${AppSettings.applicationName.value} switches from the detached background-fetch mode to ${state.name} mode. Rendering GUI...',
    );
    // Switching to foreground mode needs to reenable send online sync presence.
    for (final client in clients) {
      client.backgroundSync = true;
      client.syncPresence = PresenceType.online;
    }
    startGui(clients, store);
    // We must make sure that the GUI is only started once.
    guiStarted = true;
  }
}
