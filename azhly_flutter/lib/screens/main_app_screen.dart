import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../widgets/bubble_background.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/smart_engine_modal.dart';

import 'teacher/teacher_dashboard.dart';
import 'teacher/teacher_schedule.dart';
import 'cr/cr_dashboard.dart';
import 'student/student_dashboard.dart';
import 'student/suggest_room.dart';
import 'admin/admin_dashboard.dart';
import 'shared/room_finder_page.dart';
import 'shared/timetable_page.dart';
import 'shared/my_classes_page.dart';
import 'shared/profile_page.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  Widget _content(AppState state) {
    final role = state.currentUser?.role ?? AppRole.student;
    final tab = state.currentTab;

    if (tab == 'profile') return const ProfilePage();
    if (tab == 'timetable') return const TimetablePage();
    if (tab == 'my-classes') return const MyClassesPage();

    if (role == AppRole.teacher) {
      if (tab == 'dashboard') return const TeacherDashboard();
      if (tab == 'room-finder') return const RoomFinderPage();
      if (tab == 'manage') return const TeacherSchedulePage();
    }
    if (role == AppRole.cr) {
      if (tab == 'dashboard') return const CrDashboard();
      if (tab == 'room-finder') return const RoomFinderPage();
    }
    if (role == AppRole.student) {
      if (tab == 'dashboard') return const StudentDashboard();
      if (tab == 'suggest') return const SuggestRoomPage();
    }
    if (role == AppRole.admin) {
      return const AdminDashboard();
    }
    return const TeacherDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      body: BubbleBackground(
        isDark: state.isDarkMode,
        child: Stack(
          children: [
            Column(
              children: [
                const AppHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: _content(state),
                  ),
                ),
              ],
            ),
            const SmartEngineModal(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
