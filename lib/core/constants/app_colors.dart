import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Modern Purple Palette
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color darkPurple = Color(0xFF5B21B6);
  static const Color lightPurple = Color(0xFF8B5CF6);
  static const Color accentPurple = Color(0xFFA855F7);
  
  // Secondary Colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryGreen = Color(0xFF10B981);
  static const Color primaryOrange = Color(0xFFF59E0B);
  static const Color primaryRed = Color(0xFFEF4444);
  
  // Light Theme Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F0F23);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCardBackground = Color(0xFF16213E);
  static const Color darkDivider = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);
  static const Color darkTextTertiary = Color(0xFF9CA3AF);
  
  // Shadow & Effects
  static const Color shadowColor = Color(0x0F000000);
  static const Color shadowColorDark = Color(0x1A000000);
  
  // Light Theme Gradients
  static const LinearGradient modernGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF5B21B6),
    ],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8FAFC),
    ],
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAFAFA),
      Color(0xFFF3F4F6),
    ],
  );
  
  // Dark Theme Gradients
  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1A2E),
      Color(0xFF16213E),
    ],
  );
  
  static const LinearGradient darkSubtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0F0F23),
      Color(0xFF1A1A2E),
    ],
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF1D4ED8),
    ],
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
    ],
  );
  
  // Dynamic color getters based on theme
  static Color getBackground(bool isDark) => isDark ? darkBackground : background;
  static Color getSurface(bool isDark) => isDark ? darkSurface : surface;
  static Color getCardBackground(bool isDark) => isDark ? darkCardBackground : cardBackground;
  static Color getDivider(bool isDark) => isDark ? darkDivider : divider;
  static Color getTextPrimary(bool isDark) => isDark ? darkTextPrimary : textPrimary;
  static Color getTextSecondary(bool isDark) => isDark ? darkTextSecondary : textSecondary;
  static Color getTextTertiary(bool isDark) => isDark ? darkTextTertiary : textTertiary;
  static LinearGradient getCardGradient(bool isDark) => isDark ? darkCardGradient : cardGradient;
  static LinearGradient getSubtleGradient(bool isDark) => isDark ? darkSubtleGradient : subtleGradient;
}