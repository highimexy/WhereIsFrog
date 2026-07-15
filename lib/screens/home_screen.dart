import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:where_is_frog/core/location_store.dart';
import 'package:where_is_frog/services/store_locator_service.dart';
import 'package:where_is_frog/widgets/bear_paws.dart';
import 'package:where_is_frog/widgets/pirate_compass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.startingPosition});

  final Position? startingPosition;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _SearchStatus { loading, found, notFound, error }

class _HomeScreenState extends State<HomeScreen> {
  final _locator = StoreLocatorService();

  _SearchStatus _status = _SearchStatus.loading;
  NearestStore? _store;
  double _bearingToStore = 0;
  Position? _position;

  @override
  void initState() {
    super.initState();
    _resolvePosition();
  }

  Future<void> _resolvePosition() async {
    try {
      final position = widget.startingPosition ??
          LocationStore.instance.current ??
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
          );
      if (!mounted) return;
      _position = position;
      LocationStore.instance.current = position;
      await _search();
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = _SearchStatus.error);
    }
  }

  Future<void> _search() async {
    if (_position == null) return;
    setState(() => _status = _SearchStatus.loading);

    try {
      final store = await _locator.findNearestAlcoholShop(_position!);
      if (!mounted) return;

      if (store == null) {
        setState(() => _status = _SearchStatus.notFound);
        return;
      }

      final bearing = Geolocator.bearingBetween(
        _position!.latitude,
        _position!.longitude,
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

  Future<void> _retry() async {
    if (_position == null) {
      await _resolvePosition();
    } else {
      await _search();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Few Bears'),
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
            Text('Misie węszą najbliższe piwo...', style: textTheme.bodyLarge),
          ],
        );

      case _SearchStatus.notFound:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'W pobliżu żadnego piwa. Misie są smutne. 🐻',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _retry, child: const Text('SZUKAJ PONOWNIE')),
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
                'Misie zgubiły sygnał. Sprawdź internet.',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _retry, child: const Text('SPRÓBUJ PONOWNIE')),
            ],
          ),
        );

      case _SearchStatus.found:
        final store = _store!;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PirateCompass(bearingToTarget: _bearingToStore),
                Transform.translate(
                  offset: const Offset(0, 28),
                  child: const BearPaws(width: 260),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(store.name, style: textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '${_formatDistance(store.distanceMeters)} do najbliższego piwa',
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
