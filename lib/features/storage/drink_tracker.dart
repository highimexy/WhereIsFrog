import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Śledzi wyzwanie "wypij każde piwo z Żabki": ile razy wypito każde piwo
/// (beerId -> liczba), trwale w [SharedPreferences]. Singleton w tym samym
/// stylu co [LocationStore]/[FirstLaunch] w lib/core/.
class DrinkTracker extends ChangeNotifier {
  DrinkTracker._();

  static final DrinkTracker instance = DrinkTracker._();

  static const _key = 'few_bears_drink_counts';

  final Map<String, int> _counts = {};
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _counts.addAll(decoded.map((id, count) => MapEntry(id, count as int)));
    }
    _loaded = true;
    notifyListeners();
  }

  int countFor(String beerId) => _counts[beerId] ?? 0;

  int get triedCount => _counts.values.where((count) => count > 0).length;

  Future<void> increment(String beerId) async {
    _counts[beerId] = countFor(beerId) + 1;
    notifyListeners();
    await _persist();
  }

  Future<void> decrement(String beerId) async {
    final next = countFor(beerId) - 1;
    if (next <= 0) {
      _counts.remove(beerId);
    } else {
      _counts[beerId] = next;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_counts));
  }
}
