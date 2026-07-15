import 'package:flutter/material.dart';

/// Wjazd elementu: translate + fade razem (nigdy sama opacity), z opóźnieniem
/// zależnym od [index] — do listy butelek, tekstu onboardingu itp.
class StaggeredReveal extends StatelessWidget {
  const StaggeredReveal({
    super.key,
    required this.index,
    required this.child,
    this.delayPerItem = const Duration(milliseconds: 50),
    this.offset = const Offset(0, 24),
  });

  final int index;
  final Widget child;
  final Duration delayPerItem;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(index),
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delayPerItem.inMilliseconds * index),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        // Element pojawia się dopiero po swoim opóźnieniu, więc "kompresujemy"
        // pierwszą część animacji w wyczekiwanie na starcie krzywej.
        final delayFraction = (delayPerItem.inMilliseconds * index) /
            (400 + delayPerItem.inMilliseconds * index);
        final localT = ((t - delayFraction) / (1 - delayFraction)).clamp(0.0, 1.0);
        return Opacity(
          opacity: localT,
          child: Transform.translate(
            offset: offset * (1 - localT),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
