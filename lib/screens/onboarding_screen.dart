import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:where_is_frog/screens/permission_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.title});

  final String title;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                Text(
                  'Witaj w aplikacji',
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      top: 10,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            'assets/images/frog.webp',
                            width: 350,
                            height: 350,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/frog.webp',
                      width: 350,
                      height: 350,
                    ),
                    Text(
                      'Where Is Frog!?',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'Znajdź drogę do najbliższego monopolowego\nza pomocą pirackiego kompasu!\nPoczuj się jak prawdziwy żabi wędrowiec.',
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => const PermissionScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: const Text('Szukaj'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
