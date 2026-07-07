import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        image: DecorationImage(
          image: const AssetImage('assets/images/background.webp'),
          fit: BoxFit.fitWidth,
          repeat: ImageRepeat.repeat,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: child,
    );
  }
}
