import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class _NavItem {
  final String id, label;
  final IconData icon;
  const _NavItem(this.id, this.label, this.icon);
}

const _teacherTabs = [
  _NavItem('dashboard', 'Dashboard', Icons.dashboard_rounded),
  _NavItem('room-finder', 'Rooms', Icons.search_rounded),
  _NavItem('timetable', 'Timetable', Icons.calendar_month_rounded),
  _NavItem('manage', 'My Schedule', Icons.event_note_rounded),
  _NavItem('profile', 'Profile', Icons.person_rounded),
];

const _crTabs = [
  _NavItem('dashboard', 'Dashboard', Icons.dashboard_rounded),
  _NavItem('room-finder', 'Rooms', Icons.search_rounded),
  _NavItem('timetable', 'Timetable', Icons.calendar_month_rounded),
  _NavItem('my-classes', 'My Classes', Icons.menu_book_rounded),
  _NavItem('profile', 'Profile', Icons.person_rounded),
];

const _studentTabs = [
  _NavItem('dashboard', 'Dashboard', Icons.dashboard_rounded),
  _NavItem('suggest', 'Suggest', Icons.lightbulb_rounded),
  _NavItem('timetable', 'Timetable', Icons.calendar_month_rounded),
  _NavItem('my-classes', 'My Classes', Icons.menu_book_rounded),
  _NavItem('profile', 'Profile', Icons.person_rounded),
];

const _adminTabs = [
  _NavItem('dashboard', 'Dashboard', Icons.dashboard_rounded),
  _NavItem('profile', 'Profile', Icons.person_rounded),
];

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final role = state.currentUser?.role ?? AppRole.student;
    final tabs = role == AppRole.teacher
        ? _teacherTabs
        : role == AppRole.cr
            ? _crTabs
            : role == AppRole.student
                ? _studentTabs
                : _adminTabs;

    return Container(
      decoration: BoxDecoration(
        color: colors.navBg,
        border: Border(top: BorderSide(color: colors.navBorder)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tabs.map((tab) {
            final isActive = state.currentTab == tab.id;
            return GestureDetector(
              onTap: () => state.setTab(tab.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? AppPalette.purple.withOpacity(state.isDarkMode ? 0.2 : 0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(tab.icon, size: 20, color: isActive ? colors.accent : colors.navInactive),
                    const SizedBox(height: 2),
                    Text(tab.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isActive ? colors.accent : colors.navInactive,
                        )),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
