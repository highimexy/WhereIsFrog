import 'package:flutter/material.dart';

//Router
import 'core/router/app_router.dart';
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
    return MaterialApp.router(
      title: 'Few Bears',
      theme: AppTheme.dark,
      builder: (context, child) => Background(child: child!),
      routerConfig: appRouter,
    );
  }
}
