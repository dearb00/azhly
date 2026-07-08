import 'package:flutter/material.dart';

/// Central place for the AZHly color palette & the small helper class
/// [AppColors] that returns the right shade depending on light/dark mode —
/// mirrors the inline `theme === 'dark' ? … : …` pattern from the original
/// React source.
class AppPalette {
  static const purple = Color(0xFF7C3AED);
  static const purple2 = Color(0xFFA855F7);
  static const purpleLight = Color(0xFFC084FC);
  static const pink = Color(0xFFEC4899);
  static const orange = Color(0xFFF97316);
  static const green = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const blue = Color(0xFF3B82F6);

  // Dark mode background: navy (hsl(230,50%,8%))
  static const navyBg = Color(0xFF0A0E1F);
  // Light mode gradient stops (soft purple/pink/lavender)
  static const lightBgTop = Color(0xFFEFE6F7);
  static const lightBgMid = Color(0xFFF1E6F3);
  static const lightBgBottom = Color(0xFFE9E1F3);

  static const purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, pink],
  );

  static const purpleGradient2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [purple, purple2],
  );
}

class AppColors {
  final bool isDark;
  const AppColors(this.isDark);

  Color get accent => isDark ? AppPalette.purpleLight : AppPalette.purple;

  Color get cardBg => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.65);
  Color get cardBorder => isDark ? AppPalette.purple.withValues(alpha: 0.25) : AppPalette.purple.withValues(alpha: 0.18);

  Color get inputBg => isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.7);
  Color get inputBorder => isDark ? AppPalette.purple.withValues(alpha: 0.3) : AppPalette.purple.withValues(alpha: 0.25);

  Color get chipBg => isDark ? AppPalette.purple.withValues(alpha: 0.12) : AppPalette.purple.withValues(alpha: 0.08);

  Color get textPrimary => isDark ? Colors.white : const Color(0xFF1A0A3D);
  Color get textMuted => isDark ? const Color(0xB3B4A0D6) : const Color(0x991A0A3D);

  Color get navBg => isDark ? const Color(0xD9140C32) : Colors.white.withValues(alpha: 0.85);
  Color get navBorder => isDark ? AppPalette.purple.withValues(alpha: 0.2) : AppPalette.purple.withValues(alpha: 0.15);
  Color get navInactive => isDark ? const Color(0x99B4A0DC) : const Color(0x8A644B96);

  Color get modalBg => isDark ? const Color(0xF2120A2D) : Colors.white.withValues(alpha: 0.97);

  Color statusColor(String status) {
    switch (status) {
      case 'free':
        return AppPalette.green;
      case 'occupied':
        return AppPalette.pink;
      case 'regular':
        return AppPalette.amber;
      case 'pending':
        return AppPalette.amber;
      case 'approved':
        return AppPalette.green;
      case 'rejected':
        return AppPalette.red;
      case 'conflict':
        return AppPalette.pink;
      default:
        return AppPalette.purple;
    }
  }
}
