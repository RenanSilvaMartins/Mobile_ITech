import 'package:flutter/material.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/technicians_screen.dart';
import 'data/models/service_model.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mobile ITech',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeController().isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/technicians':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => TechniciansScreen(
                selectedService: args?['selectedService'] as ServiceModel?,
              ),
            );
          default:
            return null;
        }
      },
        );
      },
    );
  }
}