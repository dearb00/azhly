import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/bubble_background.dart';
import '../widgets/azhly_logo.dart';
import '../widgets/theme_toggle.dart';
import 'main_app_screen.dart';

class _RoleOpt {
  final AppRole id;
  final String label, desc;
  final IconData icon;
  final Gradient gradient;
  const _RoleOpt(this.id, this.label, this.desc, this.icon, this.gradient);
}

const _roles = [
  _RoleOpt(AppRole.teacher, 'Teacher', 'Manage classes & approve bookings', Icons.school_rounded,
      LinearGradient(colors: [AppPalette.purple, AppPalette.purple2])),
  _RoleOpt(AppRole.cr, 'CR / GR', 'Class rep — forward & manage requests', Icons.groups_rounded,
      LinearGradient(colors: [AppPalette.purple2, AppPalette.pink])),
  _RoleOpt(AppRole.student, 'Student', 'Suggest rooms through your CR', Icons.person_rounded,
      LinearGradient(colors: [AppPalette.pink, AppPalette.orange])),
  _RoleOpt(AppRole.admin, 'Admin', 'View reports & analytics only', Icons.shield_rounded,
      LinearGradient(colors: [AppPalette.blue, AppPalette.purple])),
];

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    void select(AppRole role) {
      state.setRole(role);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainAppScreen()));
    }

    return Scaffold(
      body: BubbleBackground(
        isDark: state.isDarkMode,
        child: SafeArea(
          child: Column(
            children: [
              const Align(alignment: Alignment.topRight, child: Padding(padding: EdgeInsets.all(16), child: ThemeToggleButton())),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Column(
                      children: [
                        AzhlyLogo(size: 60, isDark: state.isDarkMode),
                        const SizedBox(height: 14),
                        Text('Welcome, ${state.currentUser?.name.split(' ').first ?? ''}!',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Select your role to continue', style: TextStyle(fontSize: 13, color: colors.textMuted)),
                        const SizedBox(height: 26),
                        ..._roles.map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => select(r.id),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: colors.cardBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: colors.cardBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 54, height: 54,
                                        decoration: BoxDecoration(gradient: r.gradient, borderRadius: BorderRadius.circular(16)),
                                        alignment: Alignment.center,
                                        child: Icon(r.icon, color: Colors.white, size: 26),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(r.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colors.textPrimary)),
                                            const SizedBox(height: 2),
                                            Text(r.desc, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.chevron_right_rounded, color: colors.accent),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
