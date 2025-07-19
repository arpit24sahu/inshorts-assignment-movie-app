

import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

class MoviesState extends Equatable {
  final List<Movie> trendingMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> savedMovies;
  final bool isLoadingTrending;
  final bool isLoadingNowPlaying;
  final bool isLoadingSaved;
  final String? error;

  const MoviesState({
    this.trendingMovies = const [],
    this.nowPlayingMovies = const [],
    this.savedMovies = const [],
    this.isLoadingTrending = false,
    this.isLoadingNowPlaying = false,
    this.isLoadingSaved = false,
    this.error,
  });

  MoviesState copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? savedMovies,
    bool? isLoadingTrending,
    bool? isLoadingNowPlaying,
    bool? isLoadingSaved,
    String? error,
  }) {
    return MoviesState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      savedMovies: savedMovies ?? this.savedMovies,
      isLoadingTrending: isLoadingTrending ?? this.isLoadingTrending,
      isLoadingNowPlaying: isLoadingNowPlaying ?? this.isLoadingNowPlaying,
      isLoadingSaved: isLoadingSaved ?? this.isLoadingSaved,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [
        trendingMovies,
        nowPlayingMovies,
        savedMovies,
        isLoadingTrending,
        isLoadingNowPlaying,
        isLoadingSaved,
        error
      ];
}
