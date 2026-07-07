import 'package:flutter/material.dart';

//Ekrany
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

//Widgety
import 'widgets/background.dart';

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
      builder: (context, child) => Background(child: child!),
      home: const SplashScreen(title: "Where is Frog"),
    );
  }
}
