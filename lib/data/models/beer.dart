class Beer {
  const Beer({
    required this.id,
    required this.name,
    required this.style,
    required this.brewery,
    required this.abv,
    this.rating,
    this.imageAsset,
    this.venueNames = const [],
  });

  final String id;
  final String name;
  final String style;
  final String brewery;
  final double abv;
  final double? rating;

  /// [ASSET] Render butelki z Blendera (assets/renders/bottles/*.webp).
  /// Gdy null lub plik nie istnieje, UI pokazuje placeholder.
  final String? imageAsset;

  /// Nazwy pobliskich sklepów, w których piwo jest dostępne.
  final List<String> venueNames;
}
