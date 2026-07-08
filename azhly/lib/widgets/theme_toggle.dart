import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isDark = state.isDarkMode;
    return GestureDetector(
      onTap: state.toggleTheme,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? AppPalette.purple.withValues(alpha: 0.25) : AppPalette.purple.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppPalette.purple.withValues(alpha: isDark ? 0.4 : 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                size: 14, color: isDark ? AppPalette.purpleLight : AppPalette.purple),
            const SizedBox(width: 6),
            Text(
              isDark ? 'Light' : 'Dark',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppPalette.purpleLight : AppPalette.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
