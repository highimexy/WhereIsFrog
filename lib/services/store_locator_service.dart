import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class NearestStore {
  const NearestStore({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    this.openingHours,
  });

  final String name;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final String? openingHours;
}

/// Znajduje najbliższy sklep monopolowy (OSM `shop=alcohol`) przez darmowe
/// Overpass API, poszerzając promień wyszukiwania aż coś znajdzie.
class StoreLocatorService {
  StoreLocatorService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _endpoint = 'https://overpass-api.de/api/interpreter';
  static const _searchRadiiMeters = [1000, 3000, 8000, 20000];

  Future<NearestStore?> findNearestAlcoholShop(Position from) async {
    for (final radius in _searchRadiiMeters) {
      final stores = await _query(from, radius);
      if (stores.isNotEmpty) {
        stores.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
        return stores.first;
      }
    }
    return null;
  }

  Future<List<NearestStore>> _query(Position from, int radiusMeters) async {
    final query = '''
[out:json][timeout:20];
node(around:$radiusMeters,${from.latitude},${from.longitude})[shop=alcohol];
out body;
''';

    final response = await _client
        .post(Uri.parse(_endpoint), body: {'data': query})
        .timeout(const Duration(seconds: 25));

    if (response.statusCode != 200) {
      throw StoreLocatorException(
        'Overpass API zwróciło błąd (${response.statusCode}).',
      );
    }

    final Map<String, dynamic> json = jsonDecode(response.body);
    final elements = (json['elements'] as List?) ?? const [];

    return elements.map<NearestStore>((element) {
      final lat = (element['lat'] as num).toDouble();
      final lon = (element['lon'] as num).toDouble();
      final tags = (element['tags'] as Map?) ?? const {};

      final distance = Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        lat,
        lon,
      );

      return NearestStore(
        name: tags['name'] as String? ?? 'Sklep monopolowy',
        latitude: lat,
        longitude: lon,
        distanceMeters: distance,
        openingHours: tags['opening_hours'] as String?,
      );
    }).toList();
  }
}

class StoreLocatorException implements Exception {
  StoreLocatorException(this.message);
  final String message;

  @override
  String toString() => message;
}
