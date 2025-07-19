import 'package:hive/hive.dart';

import '../../../../core/common/constants.dart';
import '../models/movie_model.dart';
import '../../domain/entities/movie.dart';

abstract class MovieLocalDataSource {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> getSavedMovies();
  Future<void> saveTrendingMovies(List<Movie> movies);
  Future<void> saveNowPlayingMovies(List<Movie> movies);
  Future<void> saveMovie(Movie movie);
  Future<void> removeMovie(int movieId);
  Future<bool> isMovieSaved(int movieId);
  bool isCacheValid(String key);
  void updateCacheTimestamp(String key);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box _moviesBox;
  final Box _savedMoviesBox;
  final Box _cacheBox;

  static const String _trendingKey = 'trending_movies';
  static const String _nowPlayingKey = 'now_playing_movies';
  static const String _trendingCacheKey = 'trending_cache_time';
  static const String _nowPlayingCacheKey = 'now_playing_cache_time';

  MovieLocalDataSourceImpl(
    this._moviesBox,
    this._savedMoviesBox,
    this._cacheBox,
  );

  @override
  Future<List<Movie>> getTrendingMovies() async {
    final movies = _moviesBox.get(_trendingKey);
    if (movies == null) return [];
    return List<MovieModel>.from(movies);
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    final movies = _moviesBox.get(_nowPlayingKey);
    if (movies == null) return [];
    return List<MovieModel>.from(movies);
  }

  @override
  Future<List<Movie>> getSavedMovies() async {
    final movies = _savedMoviesBox.values.toList();
    return List<MovieModel>.from(movies);
  }

  @override
  Future<void> saveTrendingMovies(List<Movie> movies) async {
    final movieModels = movies
        .map((movie) => movie is MovieModel 
            ? movie 
            : MovieModel(
                id: movie.id,
                title: movie.title,
                originalTitle: movie.originalTitle,
                overview: movie.overview,
                posterPath: movie.posterPath,
                backdropPath: movie.backdropPath,
                releaseDate: movie.releaseDate,
                voteAverage: movie.voteAverage,
                voteCount: movie.voteCount,
                popularity: movie.popularity,
                adult: movie.adult,
                video: movie.video,
                originalLanguage: movie.originalLanguage,
                genreIds: movie.genreIds,
              ))
        .toList();
    
    await _moviesBox.put(_trendingKey, movieModels);
    updateCacheTimestamp(_trendingCacheKey);
  }

  @override
  Future<void> saveNowPlayingMovies(List<Movie> movies) async {
    final movieModels = movies
        .map((movie) => movie is MovieModel 
            ? movie 
            : MovieModel(
                id: movie.id,
                title: movie.title,
                originalTitle: movie.originalTitle,
                overview: movie.overview,
                posterPath: movie.posterPath,
                backdropPath: movie.backdropPath,
                releaseDate: movie.releaseDate,
                voteAverage: movie.voteAverage,
                voteCount: movie.voteCount,
                popularity: movie.popularity,
                adult: movie.adult,
                video: movie.video,
                originalLanguage: movie.originalLanguage,
                genreIds: movie.genreIds,
              ))
        .toList();
    
    await _moviesBox.put(_nowPlayingKey, movieModels);
    updateCacheTimestamp(_nowPlayingCacheKey);
  }

  @override
  Future<void> saveMovie(Movie movie) async {
    final movieModel = movie is MovieModel 
        ? movie 
        : MovieModel(
            id: movie.id,
            title: movie.title,
            originalTitle: movie.originalTitle,
            overview: movie.overview,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            popularity: movie.popularity,
            adult: movie.adult,
            video: movie.video,
            originalLanguage: movie.originalLanguage,
            genreIds: movie.genreIds,
          );
    
    await _savedMoviesBox.put(movie.id, movieModel);
  }

  @override
  Future<void> removeMovie(int movieId) async {
    await _savedMoviesBox.delete(movieId);
  }

  @override
  Future<bool> isMovieSaved(int movieId) async {
    return _savedMoviesBox.containsKey(movieId);
  }

  @override
  bool isCacheValid(String key) {
    final timestamp = _cacheBox.get(key);
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    
    return difference < AppConstants.cacheValidityDuration;
  }

  @override
  void updateCacheTimestamp(String key) {
    _cacheBox.put(key, DateTime.now().millisecondsSinceEpoch);
  }
}