import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/media_model.dart';

class WatchlistViewModel extends ChangeNotifier {
  static const String _key = 'watchlist';

  List<Media> _items = [];

  List<Media> get items => _items;
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  bool isInList(int id) => _items.any((m) => m.id == id);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_key) ?? [];

      _items = raw
          .map((s) => Media.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (_) {
      _items = [];
    }
  }

  Future<void> toggle(Media media) async {
    if (isInList(media.id)) {
      _items.removeWhere((m) => m.id == media.id);
    } else {
      _items.insert(0, media);
    }

    notifyListeners();
    await _save();
  }

  Future<void> remove(int id) async {
    _items.removeWhere((m) => m.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> clearAll() async {
    _items = [];
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _key,
        _items.map((m) => jsonEncode(m.toJson())).toList(),
      );
    } catch (_) {}
  }
}
