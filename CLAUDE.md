# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a fork of FluffyChat — a Flutter-based Matrix protocol chat client. The goal is to rebrand it as a Trustwork app, replacing the FluffyChat UI with custom onboarding flows and adding special interactions during call accept events, hooked up to a Trustwork middleware.

**Requirements:** Flutter SDK (>=3.10.0) and Rust (for `flutter_vodozemac`, the Olm/Megolm encryption library).

## Common Commands

```bash
# Run the app
flutter run

# Build targets
flutter build apk              # Android
flutter build ios              # iOS (Mac + Xcode required)
flutter build web --release    # Web (run scripts/prepare-web.sh first)
flutter build linux --release
flutter build windows --release
flutter build macos --release

# Lint
flutter analyze

# Unit tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Sort imports (enforced by linter)
dart run import_sorter:main

# Generate l10n files after editing .arb files
flutter gen-l10n
```

## Architecture

### Widget Tree Entry Points

`lib/main.dart` → `FluffyChatApp` (`lib/widgets/fluffy_chat_app.dart`) → `AppLockWidget` → `Matrix` widget → router child

- **`Matrix` widget** (`lib/widgets/matrix.dart`): The central state container. Accessed throughout the app via `Matrix.of(context)`. Holds the list of `Client` instances, the active client, `VoipPlugin`, `BackgroundPush`, and audio player state. Manages Matrix SDK event subscriptions (key verification, login state changes, notifications).

- **`FluffyChatApp`** (`lib/widgets/fluffy_chat_app.dart`): Owns the static `GoRouter` instance. Wraps with `ThemeBuilder`, `AppLockWidget`, and `Matrix`.

### Routing

All routes are defined in `lib/config/routes.dart` (`AppRoutes.routes`). Uses `go_router`. Key paths:
- `/home` → `IntroPage` (unauthenticated entry, currently contains "login / sign up" buttons)
- `/home/sign_in` and `/home/sign_up` → `SignInPage` (homeserver picker + login flow)
- `/home/login` → `Login` (direct Matrix ID login)
- `/rooms` → `ChatList` (main chat list; uses `TwoColumnLayout` on wide screens)
- `/rooms/:roomid` → `ChatPage`
- `/backup` → `BootstrapDialog` (E2E key backup setup, shown after login)

### Page Pattern

Most pages use one of two patterns:

1. **Controller/View split** (older pattern): `chat.dart` holds the `StatefulWidget` controller logic, `chat_view.dart` holds the `Widget build`. The controller is accessed in the view via `widget` or passed down.

2. **ViewModelBuilder pattern** (newer pattern, used in `sign_in`): `ViewModelBuilder<T>` (`lib/widgets/view_model_builder.dart`) wraps a `ValueNotifier`-based view model. The view model extends `ValueNotifier<SomeState>` and rebuilds via `ValueListenableBuilder`. See `lib/pages/sign_in/view_model/sign_in_view_model.dart` for reference.

### Configuration

- **`AppConfig`** (`lib/config/app_config.dart`): Compile-time constants (colors, URLs, deep link prefixes, push channel IDs). Update these when rebranding.
- **`AppSettings`** (`lib/config/setting_keys.dart`): Runtime settings backed by `SharedPreferences`. Uses a typed enum pattern with extensions for typed get/set (e.g., `AppSettings.applicationName.value`). The app name is controlled by `AppSettings.applicationName` (key: `chat.fluffy.application_name`, default: `'FluffyChat'`).

### VoIP / Call Handling

- **`VoipPlugin`** (`lib/utils/voip_plugin.dart`): Implements `WebRTCDelegate` from the `matrix` SDK. Handles incoming/outgoing call lifecycle. Key method: `handleNewCall(CallSession call)` — this is where the call UI is shown (`Calling` widget via overlay or dialog). This is the primary hook point for adding custom accept-call interactions.
- **`Calling` widget** (`lib/pages/dialer/dialer.dart`): The call screen. `_answerCall()` calls `call.answer()`. To intercept the accept event, modify `_answerCall()` or `VoipPlugin.handleNewCall`.
- `VoipPlugin` is created by `MatrixState.createVoipPlugin()` and stored as `Matrix.of(context).voipPlugin`.

### Localization

Strings are in `.arb` files under `lib/l10n/`. English source: `lib/l10n/intl_en.arb`. After editing, run `flutter gen-l10n` (configured in `l10n.yaml`). Access strings via `L10n.of(context).someKey`.

### Database / Encryption

The Matrix SDK database uses SQLCipher (`sqlcipher_flutter_libs`) for encrypted local storage. Builder is at `lib/utils/matrix_sdk_extensions/flutter_matrix_dart_sdk_database/builder.dart`. Vodozemac (Rust-based Olm) is initialized in `main()` before the client is created.

## Key Files for Trustwork Customization

| Goal | File |
|---|---|
| App name / branding constants | `lib/config/app_config.dart` |
| Runtime app name setting | `lib/config/setting_keys.dart` (`AppSettings.applicationName`) |
| Entry / onboarding screen | `lib/pages/intro/intro_page.dart` |
| Sign-in / homeserver selection | `lib/pages/sign_in/` |
| Call accept interaction hook | `lib/utils/voip_plugin.dart` (`handleNewCall`) |
| Call screen UI | `lib/pages/dialer/dialer.dart` |
| Route definitions | `lib/config/routes.dart` |
| Theme | `lib/config/themes.dart` |

## Linting

Enforces `prefer_single_quotes`, `require_trailing_commas`, `sort_pub_dependencies`, `omit_local_variable_types`, and several `dart_code_linter` rules (see `analysis_options.yaml`). Run `flutter analyze` before committing. The `l10n` generated files are excluded from analysis.
