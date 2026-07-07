import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../data/mock_data.dart';
import '../utils/conflict_resolution.dart';

enum SmartEngineResult { none, approved, conflict }

enum AppThemeMode { dark, light, auto }

AppThemeMode themeModeFromString(String s) {
  switch (s) {
    case 'light':
      return AppThemeMode.light;
    case 'auto':
      return AppThemeMode.auto;
    default:
      return AppThemeMode.dark;
  }
}

String themeModeToString(AppThemeMode m) {
  switch (m) {
    case AppThemeMode.light:
      return 'light';
    case AppThemeMode.auto:
      return 'auto';
    case AppThemeMode.dark:
      return 'dark';
  }
}

/// AppState is the single source of truth for the whole app — this is the
/// Flutter/Provider equivalent of the original `useAppStore` (Zustand) store.
class AppState extends ChangeNotifier with WidgetsBindingObserver {
  AppUser? currentUser;
  bool isAuthenticated = false;
  AppThemeMode themeMode = AppThemeMode.dark;
  String currentTab = 'dashboard';

  /// Resolved dark/light flag — follows the device setting when
  /// [themeMode] is [AppThemeMode.auto].
  bool get isDarkMode {
    switch (themeMode) {
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.light:
        return false;
      case AppThemeMode.auto:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
  }

  List<Room> rooms = buildMockRooms();
  List<BookingRequest> requests = buildMockRequests();
  List<AppNotification> notifications = buildMockNotifications();

  bool smartEngineActive = false;
  int smartEngineProgress = 0;
  String smartEngineStep = '';
  SmartEngineResult smartEngineResult = SmartEngineResult.none;

  Timer? _engineTimer;

  AppState() {
    WidgetsBinding.instance.addObserver(this);
    _restore();
  }

  // Re-render whenever the OS theme changes, so "Auto (System)" mode
  // reacts live instead of only on the next app launch.
  @override
  void didChangePlatformBrightness() {
    if (themeMode == AppThemeMode.auto) notifyListeners();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final storedMode = prefs.getString('azhly_theme_mode');
    if (storedMode != null) {
      themeMode = themeModeFromString(storedMode);
    } else {
      // Fall back to the legacy bool flag from earlier app versions.
      final legacyDark = prefs.getBool('azhly_dark');
      themeMode = legacyDark == false ? AppThemeMode.light : AppThemeMode.dark;
    }
    final userJson = prefs.getString('azhly_user');
    if (userJson != null) {
      try {
        currentUser = AppUser.fromJson(jsonDecode(userJson));
        isAuthenticated = true;
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('azhly_theme_mode', themeModeToString(themeMode));
    if (currentUser != null) {
      await prefs.setString('azhly_user', jsonEncode(currentUser!.toJson()));
    } else {
      await prefs.remove('azhly_user');
    }
  }

  // ---- Auth ----
  void login(String name, String email, AppRole role) {
    currentUser = AppUser(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name.isEmpty ? 'Alex User' : name,
      email: email,
      role: role,
    );
    isAuthenticated = true;
    currentTab = 'dashboard';
    _persist();
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    isAuthenticated = false;
    currentTab = 'dashboard';
    _persist();
    notifyListeners();
  }

  void setRole(AppRole role) {
    if (currentUser != null) {
      currentUser = currentUser!.copyWith(role: role);
      _persist();
      notifyListeners();
    }
  }

  void toggleTheme() {
    setThemeMode(isDarkMode ? AppThemeMode.light : AppThemeMode.dark);
  }

  void setThemeMode(AppThemeMode mode) {
    themeMode = mode;
    _persist();
    notifyListeners();
  }

  void setTab(String tab) {
    currentTab = tab;
    notifyListeners();
  }

  // ---- Booking / Smart Engine ----
  void submitRequest({
    required String roomId,
    required String roomName,
    required String requesterId,
    required String requesterName,
    required AppRole requesterRole,
    required String date,
    required String startTime,
    required String endTime,
    required String purpose,
    String? forwardedFrom,
  }) {
    final hasConflict = checkTimeConflict(
      requests,
      roomId: roomId,
      date: date,
      startTime: startTime,
      endTime: endTime,
    );

    final newReq = BookingRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      roomId: roomId,
      roomName: roomName,
      requesterId: requesterId,
      requesterName: requesterName,
      requesterRole: requesterRole,
      date: date,
      startTime: startTime,
      endTime: endTime,
      purpose: purpose,
      status: RequestStatus.pending,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      forwardedFrom: forwardedFrom,
    );

    smartEngineActive = true;
    smartEngineProgress = 0;
    smartEngineStep = 'Fetching Timetable...';
    smartEngineResult = SmartEngineResult.none;
    notifyListeners();

    final steps = [
      {'label': 'Fetching Timetable...', 'progress': 25},
      {'label': 'Checking Conflicts...', 'progress': 55},
      {'label': 'Allocating Room...', 'progress': 80},
      {'label': 'Completed!', 'progress': 100},
    ];

    var i = 0;
    _engineTimer?.cancel();
    _engineTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (i < steps.length) {
        smartEngineStep = steps[i]['label'] as String;
        smartEngineProgress = steps[i]['progress'] as int;
        notifyListeners();
        i++;
      } else {
        timer.cancel();
        final allRequests = [...requests, newReq];
        final resolved = resolveConflicts(allRequests);
        final result = resolved.firstWhere((r) => r.id == newReq.id, orElse: () => newReq);
        final isConflict = hasConflict || result.status == RequestStatus.rejected;

        final notification = isConflict
            ? AppNotification(
                id: 'n_${DateTime.now().millisecondsSinceEpoch}',
                title: '⚡ Conflict Alert',
                message: 'Room $roomName conflict! Request rejected via FCFS policy.',
                type: NotificationType.conflict,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              )
            : AppNotification(
                id: 'n_${DateTime.now().millisecondsSinceEpoch}',
                title: '✅ Room Allocated',
                message: '$roomName successfully allocated for $date $startTime.',
                type: NotificationType.success,
                timestamp: DateTime.now().millisecondsSinceEpoch,
              );

        requests = resolved;
        notifications = [notification, ...notifications];
        smartEngineResult = isConflict ? SmartEngineResult.conflict : SmartEngineResult.approved;
        if (!isConflict) {
          final roomIdx = rooms.indexWhere((r) => r.id == roomId);
          if (roomIdx != -1) rooms[roomIdx].status = RoomStatus.occupied;
        }
        notifyListeners();

        Future.delayed(const Duration(milliseconds: 3000), () {
          dismissSmartEngine();
        });
      }
    });
  }

  void approveRequest(String id) {
    final idx = requests.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    requests[idx] = requests[idx].copyWith(status: RequestStatus.approved, approvedBy: currentUser?.name);
    notifications = [
      AppNotification(
        id: 'n_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Request Approved',
        message: 'Room booking approved by ${currentUser?.name}',
        type: NotificationType.success,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
      ...notifications,
    ];
    notifyListeners();
  }

  void rejectRequest(String id, String reason) {
    final idx = requests.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    requests[idx] = requests[idx].copyWith(status: RequestStatus.rejected, rejectionReason: reason);
    notifyListeners();
  }

  void markAllRead() {
    for (final n in notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void dismissSmartEngine() {
    smartEngineActive = false;
    smartEngineResult = SmartEngineResult.none;
    notifyListeners();
  }

  @override
  void dispose() {
    _engineTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
