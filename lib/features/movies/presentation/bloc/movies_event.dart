
import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrendingMovies extends MoviesEvent {}

class LoadNowPlayingMovies extends MoviesEvent {}

class LoadSavedMovies extends MoviesEvent {}

class SaveMovieEvent extends MoviesEvent {
  final Movie movie;

  const SaveMovieEvent(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveMovieEvent extends MoviesEvent {
  final int movieId;

  const RemoveMovieEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class LoadAllMovies extends MoviesEvent {}
