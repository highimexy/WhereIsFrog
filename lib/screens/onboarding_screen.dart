import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';

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
                            color: Colors.black.withOpacity(0.8),
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
                  'Znajdź drogę do zielonego sklepu\nza pomocą kompasu!\nPoczuj się jak prawdziwy zabi wedrowca.',
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(title: 'Where Is Frog'),
                      ),
                    );
                  },
                  child: const Text('START'),
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
