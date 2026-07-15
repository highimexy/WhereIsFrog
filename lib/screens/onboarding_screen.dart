import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:where_is_frog/core/first_launch.dart';
import 'package:where_is_frog/theme/app_theme.dart';
import 'package:where_is_frog/widgets/bear_with_compass.dart';
import 'package:where_is_frog/widgets/staggered_reveal.dart';

class _Slide {
  const _Slide({required this.title, required this.description, required this.decoration});

  final String title;
  final String description;
  final Widget Function() decoration;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static final _slides = [
    _Slide(
      title: 'Few Bears',
      description: 'Kompas naszych misiów wskaże Ci najbliższe dobre piwo.\nBear necessities. 🐻🍺',
      decoration: () => const SizedBox.shrink(),
    ),
    _Slide(
      title: 'Namierz piwo',
      description: 'Zobacz, gdzie po drodze kupisz piwo — miś prowadzi Cię prosto tam.',
      decoration: () => const Positioned(
        right: 12,
        top: 24,
        child: _MapPinBadge(),
      ),
    ),
    _Slide(
      title: 'Zajrzyj do spiżarni',
      description: 'Sprawdź, co mają w środku — zanim jeszcze wyjdziesz z domu.',
      decoration: () => const Positioned(
        bottom: -8,
        child: _BottleShelfBadge(),
      ),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onCta() async {
    if (_page < _slides.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 380), curve: Curves.easeOutCubic);
      return;
    }
    await FirstLaunch.markOnboardingCompleted();
    if (!mounted) return;
    context.go('/permission');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        StaggeredReveal(
                          index: 0,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              const BearWithCompass(),
                              slide.decoration(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        StaggeredReveal(
                          index: 1,
                          child: Text(
                            slide.title,
                            style: textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StaggeredReveal(
                          index: 2,
                          child: Text(
                            slide.description,
                            style: textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _page ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _page
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _onCta,
              child: Text(isLast ? 'Szukaj' : 'Dalej'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MapPinBadge extends StatelessWidget {
  const _MapPinBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.roughCard,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: const Icon(Icons.location_pin, color: AppColors.accent, size: 28),
    );
  }
}

class _BottleShelfBadge extends StatelessWidget {
  const _BottleShelfBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 22,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.brassLight, width: 1.5),
          ),
        ),
      ),
    );
  }
}
