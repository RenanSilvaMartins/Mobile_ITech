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
  
  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE5E7EB);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  // Shadow & Effects
  static const Color shadowColor = Color(0x0F000000);
  static const Color shadowColorDark = Color(0x1A000000);
  
  // Gradients
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
}