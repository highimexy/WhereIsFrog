import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:where_is_frog/theme/app_theme.dart';

/// Hero-grafika onboardingu: miś trzymający kompas.
///
/// [ASSET] Docelowo: assets/renders/bear.webp (render z Blendera, człowiek
/// dostarczy). Dopóki go nie ma, pokazujemy ciepły placeholder w kolorze
/// [AppColors.fur] z etykietą, żeby layout wciąż wyglądał skończenie.
class BearWithCompass extends StatelessWidget {
  const BearWithCompass({super.key, this.size = 300});

  final double size;

  static const _assetPath = 'assets/renders/bear.webp';

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: 10,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: _art(),
            ),
          ),
        ),
        _art(),
      ],
    );
  }

  Widget _art() {
    return Image.asset(
      _assetPath,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => _Placeholder(size: size),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.fur.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.fur, width: 3),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pets, size: 72, color: AppColors.fur),
          const SizedBox(height: 12),
          Text(
            'bear render',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.fur, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
