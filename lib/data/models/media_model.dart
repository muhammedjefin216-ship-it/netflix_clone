import 'package:netflix_clone/core/constants/api_constants.dart';

class Media {
  final int id;
  final String? title;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final String? firstAirDate;
  final String mediaType;
  final List<int> genreIds;
  final bool adult;
  final double popularity;

  const Media({
    required this.id,
    this.title,
    this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.releaseDate,
    this.firstAirDate,
    this.mediaType = 'movie',
    this.genreIds = const [],
    this.adult = false,
    this.popularity = 0.0,
  });

  String get displayTitle => title ?? name ?? 'Unknown';
  String get displayDate => releaseDate ?? firstAirDate ?? '';
  bool get isMovie => mediaType == 'movie';

  String get year => displayDate.length >= 4 ? displayDate.substring(0, 4) : '';

  String get ratingFormatted => voteAverage.toStringAsFixed(1);

  String? get posterUrl =>
      posterPath != null ? '${ApiConstants.imageW500}$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? '${ApiConstants.imageW780}$backdropPath' : null;

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? 0,
      title: json['title'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'],
      firstAirDate: json['first_air_date'],
      mediaType: json['media_type'] ?? 'movie',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      adult: json['adult'] ?? false,
      popularity: (json['popularity'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'name': name,
    'overview': overview,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'release_date': releaseDate,
    'first_air_date': firstAirDate,
    'media_type': mediaType,
    'genre_ids': genreIds,
    'adult': adult,
    'popularity': popularity,
  };
}

class Genre {
  final int id;
  final String name;
  const Genre({required this.id, required this.name});
  factory Genre.fromJson(Map<String, dynamic> json) =>
      Genre(id: json['id'], name: json['name']);
}

class Cast {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  const Cast({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  String? get profileUrl =>
      profilePath != null ? '${ApiConstants.imageW300}$profilePath' : null;

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
    id: json['id'],
    name: json['name'],
    character: json['character'],
    profilePath: json['profile_path'],
  );
}

class Video {
  final String id;
  final String name;
  final String key;
  final String site;
  final String type;
  const Video({
    required this.id,
    required this.name,
    required this.key,
    required this.site,
    required this.type,
  });

  bool get isYouTubeTrailer => site == 'YouTube' && type == 'Trailer';
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
  String get youtubeThumbnail =>
      'https://img.youtube.com/vi/$key/hqdefault.jpg';

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json['id'],
    name: json['name'],
    key: json['key'],
    site: json['site'],
    type: json['type'],
  );
}
