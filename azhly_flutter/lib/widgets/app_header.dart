import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'azhly_logo.dart';
import 'theme_toggle.dart';
import 'notification_panel.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  bool showNotifs = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final unread = state.notifications.where((n) => !n.read).length;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 44, 16, 12),
          child: Row(
            children: [
              AzhlyLogo(size: 38, isDark: state.isDarkMode),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AZHly', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.accent)),
                  Text(
                    '${roleLabel(state.currentUser?.role ?? AppRole.student)} Portal',
                    style: TextStyle(fontSize: 11, color: colors.textMuted),
                  ),
                ],
              ),
              const Spacer(),
              const ThemeToggleButton(),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => showNotifs = !showNotifs),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.purple.withOpacity(state.isDarkMode ? 0.2 : 0.12),
                      ),
                      child: Icon(Icons.notifications_none_rounded, size: 18, color: colors.accent),
                    ),
                    if (unread > 0)
                      Positioned(
                        top: -2, right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppPalette.pink),
                          alignment: Alignment.center,
                          child: Text(unread > 9 ? '9+' : '$unread',
                              style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppPalette.purpleGradient),
                alignment: Alignment.center,
                child: Text(
                  (state.currentUser?.name.isNotEmpty == true) ? state.currentUser!.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        if (showNotifs) NotificationPanel(onClose: () => setState(() => showNotifs = false)),
      ],
    );
  }
}
