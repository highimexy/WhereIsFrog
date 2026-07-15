import 'package:geolocator/geolocator.dart';

/// Trzyma ostatnią znaną pozycję użytkownika, żeby zakładka kompasu mogła
/// ją odczytać niezależnie od tego, czy dotarła tam z ekranu uprawnień,
/// czy przez bezpośrednie otwarcie taba (np. po kolejnym uruchomieniu apki).
class LocationStore {
  LocationStore._();

  static final LocationStore instance = LocationStore._();

  Position? current;
}
