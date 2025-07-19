import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';
import '../../domain/use_cases/get_trending_movies.dart';
import '../../domain/use_cases/get_now_playing_movies.dart';
import '../../domain/use_cases/get_saved_movies.dart';
import '../../domain/use_cases/save_movie.dart';
import '../../domain/use_cases/remove_movie.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetTrendingMovies getTrendingMovies;
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetSavedMovies getSavedMovies;
  final SaveMovie saveMovie;
  final RemoveMovie removeMovie;

  MoviesBloc({
    required this.getTrendingMovies,
    required this.getNowPlayingMovies,
    required this.getSavedMovies,
    required this.saveMovie,
    required this.removeMovie,
  }) : super(const MoviesState()) {
    on<LoadTrendingMovies>(_onLoadTrendingMovies);
    on<LoadNowPlayingMovies>(_onLoadNowPlayingMovies);
    on<LoadSavedMovies>(_onLoadSavedMovies);
    on<SaveMovieEvent>(_onSaveMovie);
    on<RemoveMovieEvent>(_onRemoveMovie);
    on<LoadAllMovies>(_onLoadAllMovies);
  }

  Future<void> _onLoadTrendingMovies(LoadTrendingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(isLoadingTrending: true));
    try {
      final movies = await getTrendingMovies();
      emit(state.copyWith(
        trendingMovies: movies,
        isLoadingTrending: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingTrending: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadNowPlayingMovies(LoadNowPlayingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(isLoadingNowPlaying: true));
    try {
      final movies = await getNowPlayingMovies();
      emit(state.copyWith(
        nowPlayingMovies: movies,
        isLoadingNowPlaying: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingNowPlaying: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadSavedMovies(LoadSavedMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(isLoadingSaved: true));
    try {
      final movies = await getSavedMovies();
      emit(state.copyWith(
        savedMovies: movies,
        isLoadingSaved: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingSaved: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSaveMovie(SaveMovieEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      await saveMovie(event.movie);
      final savedMovies = await getSavedMovies();
      emit(state.copyWith(savedMovies: savedMovies, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRemoveMovie(RemoveMovieEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      await removeMovie(event.movieId);
      final savedMovies = await getSavedMovies();
      emit(state.copyWith(savedMovies: savedMovies, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadAllMovies(LoadAllMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingTrending: true,
      isLoadingNowPlaying: true,
      isLoadingSaved: true,
    ));

    try {
      final futures = await Future.wait([
        getTrendingMovies(),
        getNowPlayingMovies(),
        getSavedMovies(),
      ]);

      emit(state.copyWith(
        trendingMovies: futures[0] as List<Movie>,
        nowPlayingMovies: futures[1] as List<Movie>,
        savedMovies: futures[2] as List<Movie>,
        isLoadingTrending: false,
        isLoadingNowPlaying: false,
        isLoadingSaved: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingTrending: false,
        isLoadingNowPlaying: false,
        isLoadingSaved: false,
        error: e.toString(),
      ));
    }
  }
}