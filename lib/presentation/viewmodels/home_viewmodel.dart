import 'package:flutter/foundation.dart';
import '../../data/models/media_model.dart';
import '../../data/repositories/media_repository.dart';

// ── View States ───────────────────────────────────────────
enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final MediaRepository _repo;

  HomeViewModel(this._repo);

  // ── State ─────────────────────────────────────────────
  ViewState _state        = ViewState.idle;
  String    _errorMessage = '';

  ViewState get state        => _state;
  String    get errorMessage => _errorMessage;
  bool      get isLoading    => _state == ViewState.loading;
  bool      get hasError     => _state == ViewState.error;
  bool      get hasData      => _popularMovies.isNotEmpty;

  // ── Content Lists ──────────────────────────────────────
  List<Media> _trending      = [];
  List<Media> _popularMovies = [];
  List<Media> _topRated      = [];
  List<Media> _popularTv     = [];
  List<Media> _upcoming      = [];

  List<Media> get trending      => _trending;
  List<Media> get popularMovies => _popularMovies;
  List<Media> get topRated      => _topRated;
  List<Media> get popularTv     => _popularTv;
  List<Media> get upcoming      => _upcoming;

  // Featured item for Hero Banner (first trending item)
  Media? get featuredMedia =>
      _trending.isNotEmpty ? _trending.first : null;

  // ── Load All Home Data ─────────────────────────────────
  Future<void> loadHomeData() async {
    // Prevent duplicate calls
    if (_state == ViewState.loading) return;

    _setState(ViewState.loading);

    try {
      // Fetch all in parallel for speed
      final results = await Future.wait([
        _repo.getTrending(),
        _repo.getPopularMovies(),
        _repo.getTopRatedMovies(),
        _repo.getPopularTvShows(),
        _repo.getUpcomingMovies(),
      ]);

      _trending      = results[0];
      _popularMovies = results[1];
      _topRated      = results[2];
      _popularTv     = results[3];
      _upcoming      = results[4];

      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = _parseError(e);
      _setState(ViewState.error);
    }
  }

  // ── Refresh ───────────────────────────────────────────
  Future<void> refresh() => loadHomeData();

  // ── Helpers ───────────────────────────────────────────
  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is Exception) {
      return e.toString().replaceAll('Exception: ', '');
    }
    return 'Something went wrong. Please try again.';
  }
}