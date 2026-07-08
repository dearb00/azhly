import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bubble_background.dart';

class _ThemeOpt {
  final AppThemeMode mode;
  final String title, subtitle;
  final IconData icon;
  const _ThemeOpt(this.mode, this.title, this.subtitle, this.icon);
}

const _options = [
  _ThemeOpt(AppThemeMode.dark, 'Dark Mode', 'Navy background with purple accents', Icons.nightlight_round),
  _ThemeOpt(AppThemeMode.light, 'Light Mode', 'Clean white with soft purple tones', Icons.wb_sunny_rounded),
  _ThemeOpt(AppThemeMode.auto, 'Auto (System)', 'Adjusts automatically based on your device settings.', Icons.desktop_windows_rounded),
];

/// Full-screen theme picker — mirrors the reference "Theme" settings screen:
/// a back button + title, three selectable rows (Dark / Light / Auto), and
/// two live bubbly preview cards at the bottom. Both previews (and every
/// selection indicator) always use the same purple accent, in both modes.
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colors = AppColors(state.isDarkMode);

    return Scaffold(
      body: BubbleBackground(
        isDark: state.isDarkMode,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: colors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text('Theme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colors.textPrimary)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: colors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.cardBorder),
                        ),
                        child: Column(
                          children: _options.asMap().entries.map((e) {
                            final opt = e.value;
                            final isLast = e.key == _options.length - 1;
                            final selected = state.themeMode == opt.mode;
                            return GestureDetector(
                              onTap: () => state.setThemeMode(opt.mode),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  border: isLast ? null : Border(bottom: BorderSide(color: colors.cardBorder)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40, height: 40,
                                      decoration: BoxDecoration(color: AppPalette.purple.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                                      alignment: Alignment.center,
                                      child: Icon(opt.icon, size: 18, color: colors.accent),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(opt.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                                          const SizedBox(height: 2),
                                          Text(opt.subtitle, style: TextStyle(fontSize: 11, color: colors.textMuted)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 24, height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selected ? AppPalette.purple : Colors.transparent,
                                        border: Border.all(color: AppPalette.purple, width: 2),
                                      ),
                                      alignment: Alignment.center,
                                      child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text('Preview', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.textMuted)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _PreviewCard(isDark: true, label: 'Dark Mode')),
                          const SizedBox(width: 12),
                          Expanded(child: _PreviewCard(isDark: false, label: 'Light Mode')),
                        ],
                      ),
                    ],
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

class _PreviewCard extends StatelessWidget {
  final bool isDark;
  final String label;
  const _PreviewCard({required this.isDark, required this.label});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 120,
        child: BubbleBackground(
          isDark: isDark,
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: AppPalette.purple.withOpacity(0.25))),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppPalette.purple,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
