import 'package:dio/dio.dart';
import 'package:netflix_clone/data/models/media_deatail.dart';
import '../models/media_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';

class MediaRepository {
  final Dio _dio = ApiClient.instance.dio;

  // ── Home Screen ───────────────────────────────────────
  Future<List<Media>> getTrending() async {
    final res = await _dio.get(ApiConstants.trendingAll);
    return _parseMediaList(res.data['results']);
  }

  Future<List<Media>> getPopularMovies() async {
    final res = await _dio.get(ApiConstants.popularMovies);
    return _parseMediaList(res.data['results'], defaultType: 'movie');
  }

  Future<List<Media>> getTopRatedMovies() async {
    final res = await _dio.get(ApiConstants.topRatedMovies);
    return _parseMediaList(res.data['results'], defaultType: 'movie');
  }

  Future<List<Media>> getUpcomingMovies() async {
    final res = await _dio.get(ApiConstants.upcomingMovies);
    return _parseMediaList(res.data['results'], defaultType: 'movie');
  }

  Future<List<Media>> getPopularTvShows() async {
    final res = await _dio.get(ApiConstants.popularTv);
    return _parseMediaList(res.data['results'], defaultType: 'tv');
  }

  Future<List<Media>> getTrendingMovies() async {
    final res = await _dio.get(ApiConstants.trendingMovies);
    return _parseMediaList(res.data['results'], defaultType: 'movie');
  }

  Future<List<Media>> getTrendingTv() async {
    final res = await _dio.get(ApiConstants.trendingTv);
    return _parseMediaList(res.data['results'], defaultType: 'tv');
  }

  // ── Detail Screen ─────────────────────────────────────
  Future<MediaDetail> getMovieDetail(int id) async {
    final res = await _dio.get('${ApiConstants.movieDetails}/$id');
    final detail = MediaDetail.fromJson(res.data, 'movie');

    final futures = await Future.wait([
      _getCredits('${ApiConstants.movieDetails}/$id'),
      _getVideos('${ApiConstants.movieDetails}/$id'),
      _getSimilar('${ApiConstants.movieDetails}/$id', 'movie'),
    ]);

    return detail.copyWith(
      cast:    futures[0] as List<Cast>,
      videos:  futures[1] as List<Video>,
      similar: futures[2] as List<Media>,
    );
  }

  Future<MediaDetail> getTvDetail(int id) async {
    final res = await _dio.get('${ApiConstants.tvDetails}/$id');
    final detail = MediaDetail.fromJson(res.data, 'tv');

    final futures = await Future.wait([
      _getCredits('${ApiConstants.tvDetails}/$id'),
      _getVideos('${ApiConstants.tvDetails}/$id'),
      _getSimilar('${ApiConstants.tvDetails}/$id', 'tv'),
    ]);

    return detail.copyWith(
      cast:    futures[0] as List<Cast>,
      videos:  futures[1] as List<Video>,
      similar: futures[2] as List<Media>,
    );
  }

  // ── Search ────────────────────────────────────────────
  Future<List<Media>> searchMulti(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    final res = await _dio.get(
      ApiConstants.searchMulti,
      queryParameters: {
        'query':          query,
        'page':           page,
        'include_adult':  false,
      },
    );
    final results = (res.data['results'] as List)
        .where((item) => item['media_type'] != 'person')
        .toList();
    return _parseMediaList(results);
  }

  // ── Private Helpers ───────────────────────────────────
  List<Media> _parseMediaList(
    List<dynamic> results, {
    String defaultType = '',
  }) {
    return results.map((json) {
      if (defaultType.isNotEmpty && json['media_type'] == null) {
        json['media_type'] = defaultType;
      }
      return Media.fromJson(json);
    })
    .where((m) => m.posterPath != null || m.backdropPath != null)
    .toList();
  }

  Future<List<Cast>> _getCredits(String basePath) async {
    try {
      final res = await _dio.get('$basePath/credits');
      final cast = res.data['cast'] as List? ?? [];
      return cast.take(15).map((c) => Cast.fromJson(c)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Video>> _getVideos(String basePath) async {
    try {
      final res = await _dio.get('$basePath/videos');
      final videos = res.data['results'] as List? ?? [];
      return videos.map((v) => Video.fromJson(v)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Media>> _getSimilar(String basePath, String type) async {
    try {
      final res = await _dio.get('$basePath/similar');
      return _parseMediaList(res.data['results'], defaultType: type);
    } catch (_) {
      return [];
    }
  }
}