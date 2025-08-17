import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color darkPurple = Color(0xFF4A148C);
  static const Color lightPurple = Color(0xFF8E24AA);
  
  static const LinearGradient modernGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6A1B9A),
      Color(0xFF4A148C),
    ],
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFF1F5F9),
    ],
  );
  
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x1A000000);
  static const Color accentPurple = Color(0xFF9333EA);
}