import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/data/models/beer.dart';
import 'package:where_is_frog/data/repositories/beer_repository.dart';
import 'package:where_is_frog/features/storage/beer_detail_screen.dart';
import 'package:where_is_frog/features/storage/storage_screen.dart';
import 'package:where_is_frog/screens/age_gate_screen.dart';
import 'package:where_is_frog/screens/home_screen.dart';
import 'package:where_is_frog/screens/onboarding_screen.dart';
import 'package:where_is_frog/screens/permission_screen.dart';
import 'package:where_is_frog/screens/privacy_policy_screen.dart';
import 'package:where_is_frog/screens/splash_screen.dart';
import 'package:where_is_frog/widgets/main_shell.dart';

/// Slide/push — nowy ekran wjeżdża z prawej, poprzedni ekran robi lekki
/// parallax w lewo i przygasza (typowy natywny push), ~320ms.
CustomTransitionPage<void> _slidePushPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final incoming = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final outgoing = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic);

      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(incoming),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset.zero, end: const Offset(-0.25, 0)).animate(outgoing),
          child: FadeTransition(
            opacity: Tween<double>(begin: 1, end: 0.6).animate(outgoing),
            child: child,
          ),
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _slidePushPage(context, state, const SplashScreen()),
    ),
    GoRoute(
      path: '/age-gate',
      pageBuilder: (context, state) => _slidePushPage(context, state, const AgeGateScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _slidePushPage(context, state, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/permission',
      pageBuilder: (context, state) => _slidePushPage(context, state, const PermissionScreen()),
    ),
    GoRoute(
      path: '/privacy-policy',
      pageBuilder: (context, state) =>
          _slidePushPage(context, state, const PrivacyPolicyScreen()),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/compass',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/storage',
              builder: (context, state) => const StorageScreen(),
              routes: [
                GoRoute(
                  path: 'beer/:id',
                  builder: (context, state) {
                    final beer = state.extra as Beer? ??
                        MockBeerRepository.all
                            .firstWhere((b) => b.id == state.pathParameters['id']);
                    return BeerDetailScreen(beer: beer);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
