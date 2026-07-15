import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/core/first_launch.dart';
import 'package:where_is_frog/widgets/loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    final results = await Future.wait([
      FirstLaunch.isFirstLaunch(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    if (!mounted) return;

    final isFirstLaunch = results[0] as bool;
    context.go(isFirstLaunch ? '/onboarding' : '/compass');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CustomLoading(),
      ),
    );
  }
}
