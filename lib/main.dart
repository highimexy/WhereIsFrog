import 'package:flutter/material.dart';

//Ekrany
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Where Is Frog',
      theme: AppTheme.dark,
      home: const SplashScreen(title: "Where is Frog"),
    );
  }
}
