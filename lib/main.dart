import 'package:flutter/material.dart';
import 'presentation/screens/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile ITech',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}