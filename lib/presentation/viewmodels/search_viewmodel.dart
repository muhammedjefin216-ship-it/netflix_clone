import 'package:flutter/foundation.dart';
import '../../data/models/media_model.dart';
import '../../data/repositories/media_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final MediaRepository _repo;

  SearchViewModel(this._repo);

  // ── State ─────────────────────────────────────────────
  List<Media> _results = [];
  List<Media> _trending = [];
  bool _isLoading = false;
  String _query = '';
  String _error = '';

  List<Media> get results => _results;
  List<Media> get trending => _trending;
  bool get isLoading => _isLoading;
  String get query => _query;
  String get error => _error;

  bool get hasResults => _results.isNotEmpty;
  bool get isSearching => _query.isNotEmpty;
  bool get hasError => _error.isNotEmpty;

  Future<void> loadTrending() async {
    try {
      _trending = await _repo.getTrending();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> search(String query) async {
    _query = query;
    _error = '';

    if (query.trim().isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _results = await _repo.searchMulti(query);
    } catch (e) {
      _error = 'Search failed. Please try again.';
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _query = '';
    _results = [];
    _error = '';
    notifyListeners();
  }
}
