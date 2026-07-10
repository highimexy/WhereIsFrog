import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'loading.dart';

class Compass extends StatelessWidget {
  const Compass({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CustomLoading();
        }

        final double? heading = snapshot.data?.heading;

        return Text(
          'Kierunek: ${heading?.toStringAsFixed(1)}°',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}
