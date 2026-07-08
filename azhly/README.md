# AZHly — Flutter App

This is the Dart/Flutter port of the AZHly React (TSX) app: splash → login/signup →
role selection (Teacher / CR-GR / Student / Admin) → role-based dashboards with an
automated "Smart Engine" that fetches the timetable, allocates rooms, and resolves
booking conflicts via First-Come-First-Served — all without admin involvement.

Only `lib/`, `pubspec.yaml`, and `web/index.html` are included here (the platform
folders `android/`, `ios/`, `web/` icons etc. must be generated locally with the
Flutter SDK — they're large, machine-specific, and not something safe to hand-write).

## Setup (one-time)

1. Install the Flutter SDK if you haven't: https://docs.flutter.dev/get-started/install
2. Create a fresh scaffold project **in an empty folder** so Flutter generates the
   android/ios/web platform folders:
   ```bash
   flutter create azhly_scaffold
   ```
3. Copy the contents of **this** project into that scaffold, overwriting the
   generated `lib/`, `pubspec.yaml`, and `web/index.html`:
   ```bash
   cp -r azhly_flutter/lib/*        azhly_scaffold/lib/
   cp    azhly_flutter/pubspec.yaml azhly_scaffold/pubspec.yaml
   cp    azhly_flutter/web/index.html azhly_scaffold/web/index.html
   ```
4. Inside `azhly_scaffold/`:
   ```bash
   flutter pub get
   ```

## Run

- **Android Studio**: open the `azhly_scaffold` folder as a Flutter project, pick an
  emulator/device from the device dropdown, and hit Run (▶).
- **Chrome / any online Flutter playground**:
  ```bash
  flutter run -d chrome
  ```
  The custom `web/index.html` wraps the app in a phone-sized frame (max-width 430px,
  rounded corners, shadow) so it visually looks like a mobile app even in a wide
  browser window.

## Project structure

```
lib/
  main.dart                  – app entry point
  theme/app_theme.dart       – color palette (purple/pink accents, navy dark bg)
  models/models.dart         – User, Room, BookingRequest, Notification, TimetableEntry
  data/mock_data.dart        – demo data (rooms, requests, notifications, timetable)
  state/app_state.dart       – app-wide state (Provider/ChangeNotifier) incl. the
                                Smart Engine timer + FCFS conflict resolution
  utils/conflict_resolution.dart
  widgets/                   – reusable pieces: bubble background, logo, header,
                                bottom nav, room/request cards, notification panel,
                                smart-engine loading modal, theme toggle
  screens/
    splash_screen.dart
    auth_screen.dart
    role_selection_screen.dart
    main_app_screen.dart     – shell: header + tab router + bottom nav
    teacher/  cr/  student/  admin/  shared/   – role dashboards & shared pages
```

## Notes

- State management: `provider` (ChangeNotifier), a direct port of the original
  Zustand store — `login`, `logout`, `setRole`, `toggleTheme`, `setTab`,
  `submitRequest` (drives the Smart Engine), `approveRequest`, `rejectRequest`,
  `markAllRead`, `dismissSmartEngine`.
- Theme + logged-in user persist across restarts via `shared_preferences`.
- Charts on the Admin dashboard use `fl_chart` (bar chart + donut chart).
- The AZHly logo (clock + colour grid + cloud) is drawn with a `CustomPainter`
  (`widgets/azhly_logo.dart`) instead of shipping image assets, so it automatically
  recolors for light vs. dark mode exactly like the original.
- This sandbox has no Flutter SDK / internet access, so the code could not be
  compiled or run here — please run `flutter analyze` after `pub get` on your
  machine and let me know if anything needs fixing.
