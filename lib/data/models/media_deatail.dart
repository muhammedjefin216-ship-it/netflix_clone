  
  import 'package:netflix_clone/data/models/media_model.dart';

class MediaDetail extends Media {
  final int? runtime;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final String? status;
  final String? tagline;
  final List<Genre> genres;
  final List<Cast> cast;
  final List<Video> videos;
  final List<Media> similar;

  const MediaDetail({
    required super.id,
    super.title,
    super.name,
    super.overview,
    super.posterPath,
    super.backdropPath,
    super.voteAverage,
    super.voteCount,
    super.releaseDate,
    super.firstAirDate,
    super.mediaType,
    super.genreIds,
    super.adult,
    super.popularity,
    this.runtime,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.status,
    this.tagline,
    this.genres = const [],
    this.cast = const [],
    this.videos = const [],
    this.similar = const [],
  });

  String get runtimeFormatted {
    if (runtime == null) return '';
    final h = runtime! ~/ 60;
    final m = runtime! % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  factory MediaDetail.fromJson(Map<String, dynamic> json, String type) {
    return MediaDetail(
      id:               json['id'] ?? 0,
      title:            json['title'],
      name:             json['name'],
      overview:         json['overview'],
      posterPath:       json['poster_path'],
      backdropPath:     json['backdrop_path'],
      voteAverage:      (json['vote_average'] ?? 0.0).toDouble(),
      voteCount:        json['vote_count'] ?? 0,
      releaseDate:      json['release_date'],
      firstAirDate:     json['first_air_date'],
      mediaType:        type,
      genreIds:         (json['genres'] as List?)
                            ?.map((g) => g['id'] as int).toList() ?? [],
      adult:            json['adult'] ?? false,
      popularity:       (json['popularity'] ?? 0.0).toDouble(),
      runtime:          json['runtime'],
      numberOfSeasons:  json['number_of_seasons'],
      numberOfEpisodes: json['number_of_episodes'],
      status:           json['status'],
      tagline:          json['tagline'],
      genres:           (json['genres'] as List?)
                            ?.map((g) => Genre.fromJson(g)).toList() ?? [],
    );
  }

  MediaDetail copyWith({
    List<Cast>?  cast,
    List<Video>? videos,
    List<Media>? similar,
  }) {
    return MediaDetail(
      id:               id,
      title:            title,
      name:             name,
      overview:         overview,
      posterPath:       posterPath,
      backdropPath:     backdropPath,
      voteAverage:      voteAverage,
      voteCount:        voteCount,
      releaseDate:      releaseDate,
      firstAirDate:     firstAirDate,
      mediaType:        mediaType,
      genreIds:         genreIds,
      adult:            adult,
      popularity:       popularity,
      runtime:          runtime,
      numberOfSeasons:  numberOfSeasons,
      numberOfEpisodes: numberOfEpisodes,
      status:           status,
      tagline:          tagline,
      genres:           genres,
      cast:             cast    ?? this.cast,
      videos:           videos  ?? this.videos,
      similar:          similar ?? this.similar,
    );
  }
}