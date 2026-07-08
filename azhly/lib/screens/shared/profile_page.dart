import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/azhly_logo.dart';
import '../auth_screen.dart';
import 'theme_settings_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _menuItem(AppColors colors, IconData icon, String label, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: colors.cardBorder))),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: AppPalette.purple.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Icon(icon, size: 15, color: colors.accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: colors.textMuted)),
              Text(value ?? '—', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary)),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, size: 16, color: colors.textMuted),
      ]),
    );
  }

  // Tappable list row used for Edit Profile / Change Password / Settings /
  // Theme — mirrors the reference profile screen's menu list.
  Widget _actionRow(BuildContext context, AppColors colors, IconData icon, String label, {bool isLast = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ??
          () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label — coming soon'), behavior: SnackBarBehavior.floating),
              ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: colors.cardBorder))),
        child: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: AppPalette.purple.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Icon(icon, size: 15, color: colors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary))),
          Icon(Icons.chevron_right_rounded, size: 16, color: colors.textMuted),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);
    final user = state.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(26), border: Border.all(color: colors.cardBorder)),
          child: Column(children: [
            Container(
              width: 76, height: 76,
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppPalette.purpleGradient),
              alignment: Alignment.center,
              child: Text(user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 10),
            Text(user?.name ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary)),
            Text('${roleLabel(user?.role ?? AppRole.student)} · ${user?.department ?? 'Computer Science'}',
                style: TextStyle(fontSize: 12, color: colors.textMuted)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(gradient: AppPalette.purpleGradient2, borderRadius: BorderRadius.circular(999)),
              child: Text(roleLabel(user?.role ?? AppRole.student), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _stat(colors, 'Requests', '${state.requests.length}'),
              const SizedBox(width: 26),
              _stat(colors, 'Notifications', '${state.notifications.length}'),
              const SizedBox(width: 26),
              _stat(colors, 'Unread', '${state.notifications.where((n) => !n.read).length}'),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Column(children: [
            _menuItem(colors, Icons.person_outline, 'Full Name', user?.name),
            _menuItem(colors, Icons.mail_outline, 'Email', user?.email),
            _menuItem(colors, Icons.shield_outlined, 'Role', roleLabel(user?.role ?? AppRole.student)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppPalette.purple.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Icon(Icons.apartment_outlined, size: 15, color: colors.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Department', style: TextStyle(fontSize: 11, color: colors.textMuted)),
                      Text(user?.department ?? 'Computer Science', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    ],
                  ),
                ),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Column(children: [
            _actionRow(context, colors, Icons.edit_outlined, 'Edit Profile'),
            _actionRow(context, colors, Icons.lock_outline_rounded, 'Change Password'),
            _actionRow(context, colors, Icons.settings_outlined, 'Settings'),
            _actionRow(
              context, colors, Icons.palette_outlined, 'Theme',
              isLast: true,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ThemeSettingsPage())),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: colors.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: colors.cardBorder)),
          child: Row(children: [
            AzhlyLogo(size: 40, isDark: state.isDarkMode),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AZHly v1.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary)),
                Text('Smart Room Booking & Management', style: TextStyle(fontSize: 11, color: colors.textMuted)),
              ],
            ),
          ]),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              state.logout();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppPalette.red,
              side: BorderSide(color: AppPalette.red.withOpacity(0.4)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.logout, size: 16),
              SizedBox(width: 8),
              Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _stat(AppColors colors, String label, String value) => Column(children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.accent)),
        Text(label, style: TextStyle(fontSize: 9, color: colors.textMuted)),
      ]);
}
