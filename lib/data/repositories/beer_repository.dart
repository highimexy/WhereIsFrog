import 'package:where_is_frog/data/models/beer.dart';

abstract class BeerRepository {
  Future<List<Beer>> nearbyBeers();
}

// Uwaga architektoniczna: Overpass API (store_locator_service.dart) daje nam
// lokalizacje sklepów, ale nie ich asortyment. Realna „spiżarnia" wymagałaby
// własnego backendu z bazą piw per-sklep albo płatnej integracji zewnętrznej
// (np. Untappd). Na tym etapie to świadomy mock, nie brakująca funkcja.
class MockBeerRepository implements BeerRepository {
  const MockBeerRepository();

  static const _beers = [
    Beer(
      id: 'b1',
      name: 'Grizzly IPA',
      style: 'IPA',
      brewery: 'Leśny Browar',
      abv: 6.2,
      rating: 4.3,
      venueNames: ['Monopolowy Pod Lipą', 'Sklep U Krzyśka'],
    ),
    Beer(
      id: 'b2',
      name: 'Miodowy Brąz',
      style: 'Brown Ale',
      brewery: 'Browar Kniejowy',
      abv: 5.4,
      rating: 4.1,
      venueNames: ['Monopolowy Pod Lipą'],
    ),
    Beer(
      id: 'b3',
      name: 'Nocny Stout',
      style: 'Stout',
      brewery: 'Ciemna Gawra',
      abv: 7.8,
      rating: 4.6,
      venueNames: ['Sklep U Krzyśka', 'Alko-Kącik'],
    ),
    Beer(
      id: 'b4',
      name: 'Polana Lager',
      style: 'Lager',
      brewery: 'Browar Kniejowy',
      abv: 4.8,
      rating: 3.9,
      venueNames: ['Alko-Kącik'],
    ),
    Beer(
      id: 'b5',
      name: 'Pszeniczny Miś',
      style: 'Pszeniczne',
      brewery: 'Leśny Browar',
      abv: 5.0,
      rating: 4.0,
      venueNames: ['Monopolowy Pod Lipą', 'Alko-Kącik'],
    ),
    Beer(
      id: 'b6',
      name: 'Bursztynowy Pazur',
      style: 'APA',
      brewery: 'Ciemna Gawra',
      abv: 5.6,
      rating: 4.2,
      venueNames: ['Sklep U Krzyśka'],
    ),
    Beer(
      id: 'b7',
      name: 'Sosnowa Sesja',
      style: 'Session IPA',
      brewery: 'Leśny Browar',
      abv: 4.2,
      rating: 3.8,
      venueNames: ['Monopolowy Pod Lipą'],
    ),
    Beer(
      id: 'b8',
      name: 'Podwójny Bury',
      style: 'Double IPA',
      brewery: 'Browar Kniejowy',
      abv: 8.4,
      rating: 4.5,
      venueNames: ['Alko-Kącik'],
    ),
    Beer(
      id: 'b9',
      name: 'Karmelowy Ryk',
      style: 'Scotch Ale',
      brewery: 'Ciemna Gawra',
      abv: 6.8,
      rating: 4.0,
      venueNames: ['Sklep U Krzyśka', 'Monopolowy Pod Lipą'],
    ),
    Beer(
      id: 'b10',
      name: 'Leniwe Lato',
      style: 'Witbier',
      brewery: 'Leśny Browar',
      abv: 4.5,
      rating: 3.7,
      venueNames: ['Alko-Kącik'],
    ),
  ];

  static const List<Beer> all = _beers;

  @override
  Future<List<Beer>> nearbyBeers() async {
    // TODO: docelowo dociągnąć asortyment per-sklep z realnego backendu.
    await Future.delayed(const Duration(milliseconds: 300));
    return _beers;
  }
}
