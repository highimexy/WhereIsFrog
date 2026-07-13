import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_is_frog/services/store_locator_service.dart';
import 'package:where_is_frog/widgets/pirate_compass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
    required this.startingPosition,
  });

  final String title;
  final Position startingPosition;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _SearchStatus { loading, found, notFound, error }

class _HomeScreenState extends State<HomeScreen> {
  final _locator = StoreLocatorService();

  _SearchStatus _status = _SearchStatus.loading;
  NearestStore? _store;
  double _bearingToStore = 0;

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() => _status = _SearchStatus.loading);

    try {
      final store = await _locator.findNearestAlcoholShop(widget.startingPosition);
      if (!mounted) return;

      if (store == null) {
        setState(() => _status = _SearchStatus.notFound);
        return;
      }

      final bearing = Geolocator.bearingBetween(
        widget.startingPosition.latitude,
        widget.startingPosition.longitude,
        store.latitude,
        store.longitude,
      );

      setState(() {
        _store = store;
        _bearingToStore = bearing;
        _status = _SearchStatus.found;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _SearchStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    switch (_status) {
      case _SearchStatus.loading:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text('Szukam najbliższego skarbu...', style: textTheme.bodyLarge),
          ],
        );

      case _SearchStatus.notFound:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'W pobliżu nie znaleziono żadnego monopolowego. 🏝️',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _search, child: const Text('SZUKAJ PONOWNIE')),
            ],
          ),
        );

      case _SearchStatus.error:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nie udało się połączyć z mapą skarbów. Sprawdź internet.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _search, child: const Text('SPRÓBUJ PONOWNIE')),
            ],
          ),
        );

      case _SearchStatus.found:
        final store = _store!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PirateCompass(bearingToTarget: _bearingToStore),
            const SizedBox(height: 32),
            Text(store.name, style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '${_formatDistance(store.distanceMeters)} stąd',
              style: textTheme.bodyLarge,
            ),
            if (store.openingHours != null) ...[
              const SizedBox(height: 4),
              Text(store.openingHours!, style: textTheme.bodySmall),
            ],
          ],
        );
    }
  }

  String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}
