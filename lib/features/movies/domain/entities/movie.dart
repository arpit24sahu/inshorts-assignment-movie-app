import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final bool adult;
  final bool video;
  final String originalLanguage;
  final List<int> genreIds;

  const Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.adult,
    required this.video,
    required this.originalLanguage,
    required this.genreIds,
  });

  String get fullPosterPath {
    if (posterPath == null || posterPath!.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String get fullBackdropPath {
    if (backdropPath == null || backdropPath!.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/original$backdropPath';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        originalTitle,
        overview,
        posterPath,
        backdropPath,
        releaseDate,
        voteAverage,
        voteCount,
        popularity,
        adult,
        video,
        originalLanguage,
        genreIds,
      ];
}