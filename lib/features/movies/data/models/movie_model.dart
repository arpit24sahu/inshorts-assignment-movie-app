import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/movie.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class MovieModel extends Movie with EquatableMixin {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @JsonKey(name: 'original_title')
  @override
  final String originalTitle;

  @HiveField(3)
  @override
  final String overview;

  @HiveField(4)
  @JsonKey(name: 'poster_path')
  @override
  final String? posterPath;

  @HiveField(5)
  @JsonKey(name: 'backdrop_path')
  @override
  final String? backdropPath;

  @HiveField(6)
  @JsonKey(name: 'release_date')
  @override
  final String releaseDate;

  @HiveField(7)
  @JsonKey(name: 'vote_average')
  @override
  final double voteAverage;

  @HiveField(8)
  @JsonKey(name: 'vote_count')
  @override
  final int voteCount;

  @HiveField(9)
  @override
  final double popularity;

  @HiveField(10)
  @override
  final bool adult;

  @HiveField(11)
  @override
  final bool video;

  @HiveField(12)
  @JsonKey(name: 'original_language')
  @override
  final String originalLanguage;

  @HiveField(13)
  @JsonKey(name: 'genre_ids')
  @override
  final List<int> genreIds;

  const MovieModel({
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
  }) : super(
         id: id,
         title: title,
         originalTitle: originalTitle,
         overview: overview,
         posterPath: posterPath,
         backdropPath: backdropPath,
         releaseDate: releaseDate,
         voteAverage: voteAverage,
         voteCount: voteCount,
         popularity: popularity,
         adult: adult,
         video: video,
         originalLanguage: originalLanguage,
         genreIds: genreIds,
       );

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);

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

@JsonSerializable()
class MoviesResponse extends Equatable {
  final int page;
  final List<MovieModel> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  const MoviesResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$MoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesResponseToJson(this);

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}