import 'package:flutter/foundation.dart';
import 'package:netflix_clone/data/models/media_deatail.dart';
import 'package:netflix_clone/data/models/media_model.dart';
import '../../data/repositories/media_repository.dart';

class DetailViewModel extends ChangeNotifier {
  final MediaRepository _repo;

  DetailViewModel(this._repo);

  MediaDetail? _detail;
  bool _isLoading = false;
  String _error = '';

  MediaDetail? get detail => _detail;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  // ✅ FIXED TRAILER LOGIC
  Video? get trailer {
    if (_detail == null || _detail!.videos.isEmpty) return null;

    try {
      // 🎯 Get proper YouTube Trailer
      return _detail!.videos.firstWhere(
        (v) => v.site == "YouTube" && v.type == "Trailer",
      );
    } catch (_) {
      try {
        // 🔁 fallback: any YouTube video
        return _detail!.videos.firstWhere(
          (v) => v.site == "YouTube",
        );
      } catch (_) {
        return null;
      }
    }
  }

  Future<void> loadDetail(int id, String mediaType) async {
    _isLoading = true;
    _error = '';
    _detail = null;
    notifyListeners();

    try {
      _detail = mediaType == 'movie'
          ? await _repo.getMovieDetail(id)
          : await _repo.getTvDetail(id);
    } catch (e) {
      _error = 'Failed to load details. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _detail = null;
    _error = '';
    notifyListeners();
  }
}