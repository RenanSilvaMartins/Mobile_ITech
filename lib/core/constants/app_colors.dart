import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF5b3a7e);
  static const Color darkPurple = Color(0xFF2c0e4d);
  static const Color lightPurple = Color(0xFFA626A6);
  
  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topCenter,
    colors: [
      Color(0xFF6A1B9A),
      Color(0xFFBA68C8),
    ],
  );
  
  static const RadialGradient splashGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.7,
    colors: [
      Color(0xFF5b3a7e),
      Color(0xFF2c0e4d),
    ],
  );
}