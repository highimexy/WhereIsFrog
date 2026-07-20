import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/core/age_gate.dart';
import 'package:where_is_frog/core/first_launch.dart';
import 'package:where_is_frog/theme/app_theme.dart';

/// Bramka wiekowa 18+ — Few Bears pokazuje treści związane z alkoholem,
/// więc musi to potwierdzić przy pierwszym uruchomieniu.
class AgeGateScreen extends StatefulWidget {
  const AgeGateScreen({super.key});

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  bool _blocked = false;

  Future<void> _confirmAdult() async {
    await AgeGate.confirm();
    if (!mounted) return;
    final isFirstLaunch = await FirstLaunch.isFirstLaunch();
    if (!mounted) return;
    context.go(isFirstLaunch ? '/onboarding' : '/compass');
  }

  void _declineUnderage() {
    setState(() => _blocked = true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (_blocked) {
      // SystemNavigator.pop() jest no-opem na iOS (Apple i tak nie akceptuje
      // przycisków "zamknij aplikację" w HIG) — tam pokazujemy sam komunikat.
      final canClose = defaultTargetPlatform == TargetPlatform.android;

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.block, size: 72, color: AppColors.accent),
                const SizedBox(height: 24),
                Text(
                  'Ta aplikacja jest dostępna tylko dla osób pełnoletnich.',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (canClose) ...[
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text('ZAMKNIJ APLIKACJĘ'),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_bar, size: 80, color: AppColors.primary),
              const SizedBox(height: 32),
              Text(
                'Zanim wpuścimy misie...',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Few Bears pokazuje miejsca sprzedające alkohol. Potwierdź, że masz '
                'ukończone 18 lat, żeby kontynuować.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _confirmAdult,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('MAM UKOŃCZONE 18 LAT'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _declineUnderage,
                child: const Text('Nie mam 18 lat'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.push('/privacy-policy'),
                child: Text(
                  'Polityka prywatności',
                  style: textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
