import 'package:flutter/material.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key});

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/clock.webp', width: 350, height: 350),

        Padding(
          padding: const EdgeInsets.only(top: 71.0),
          child: RotationTransition(
            alignment: Alignment.center,
          turns: _controller,
          child: Image.asset('assets/images/ding.webp', width: 140, height: 140),
        ),)

      ],
    );
  }
}
