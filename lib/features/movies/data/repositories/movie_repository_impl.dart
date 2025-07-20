import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../data_sources/movie_local_data_source.dart';
import '../data_sources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource _remoteDataSource;
  final MovieLocalDataSource _localDataSource;

  MovieRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      if (_localDataSource.isCacheValid('trending_cache_time')) {
        final cachedMovies = await _localDataSource.getTrendingMovies();
        if (cachedMovies.isNotEmpty) return cachedMovies;
      }

      final remoteMovies = await _remoteDataSource.getTrendingMovies();

      await _localDataSource.saveTrendingMovies(remoteMovies);
      
      return remoteMovies;
    } catch (e) {
      return await _localDataSource.getTrendingMovies();
    }
  }

  @override
  Future<List<Movie>> getNowPlayingMovies() async {
    try {
      if (_localDataSource.isCacheValid('now_playing_cache_time')) {
        final cachedMovies = await _localDataSource.getNowPlayingMovies();
        if (cachedMovies.isNotEmpty) return cachedMovies;
      }

      final remoteMovies = await _remoteDataSource.getNowPlayingMovies();

      await _localDataSource.saveNowPlayingMovies(remoteMovies);
      
      return remoteMovies;
    } catch (e) {
      return await _localDataSource.getNowPlayingMovies();
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await _remoteDataSource.searchMovies(query);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Movie>> getSavedMovies() async {
    return await _localDataSource.getSavedMovies();
  }

  @override
  Future<void> saveMovie(Movie movie) async {
    await _localDataSource.saveMovie(movie);
  }

  @override
  Future<void> removeMovie(int movieId) async {
    await _localDataSource.removeMovie(movieId);
  }

  @override
  Future<bool> isMovieSaved(int movieId) async {
    return await _localDataSource.isMovieSaved(movieId);
  }
}