import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'home_screen.dart'; // Upewnij się, że import jest poprawny

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  Future<void> _requestLocationPermission(BuildContext context) async {

    LocationPermission permission = await Geolocator.checkPermission();


    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bez lokalizacji nie znajdziemy Żabki! 🐸')),
        );
        return;
      }
    }


    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Musisz włączyć lokalizację w ustawieniach telefonu.')),
      );
      return;
    }


    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(title: 'Where Is Frog'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 100, color: Colors.white),
              const SizedBox(height: 32),
              Text(
                'Potrzebujemy Twojej lokalizacji',
                style: textTheme.headlineSmall?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Aby kompas mógł wskazać Ci drogę do najbliższego zielonego sklepu, musisz udostępnić swój GPS.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => _requestLocationPermission(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('UDOSTĘPNIJ LOKALIZACJĘ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
