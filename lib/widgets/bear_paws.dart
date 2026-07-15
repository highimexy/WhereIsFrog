import 'package:flutter/material.dart';
import 'package:where_is_frog/theme/app_theme.dart';

/// Łapki misia trzymające kompas od dołu.
///
/// [ASSET] Docelowo: assets/renders/compass/paws.webp (render z Blendera,
/// człowiek dostarczy). Dopóki go nie ma, rysujemy prosty placeholder w
/// kolorze [AppColors.fur], żeby kompas wyglądał na „trzymany".
class BearPaws extends StatelessWidget {
  const BearPaws({super.key, this.width = 300});

  final double width;

  static const _assetPath = 'assets/renders/compass/paws.webp';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width * 0.28,
      child: Image.asset(
        _assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _PawsPlaceholder(width: width),
      ),
    );
  }
}

class _PawsPlaceholder extends StatelessWidget {
  const _PawsPlaceholder({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final pawWidth = width * 0.34;
    final pawHeight = width * 0.24;

    Widget paw() => Container(
          width: pawWidth,
          height: pawHeight,
          decoration: BoxDecoration(
            color: AppColors.fur,
            borderRadius: BorderRadius.circular(pawHeight * 0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: pawHeight * 0.18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: pawWidth * 0.12,
                      height: pawWidth * 0.12,
                      decoration: BoxDecoration(
                        color: AppColors.fur.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Transform.rotate(angle: -0.15, child: paw()),
        Transform.rotate(angle: 0.15, child: paw()),
      ],
    );
  }
}
