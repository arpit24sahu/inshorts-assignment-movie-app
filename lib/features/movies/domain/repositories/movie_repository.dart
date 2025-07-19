import '../../data/models/movie_model.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getNowPlayingMovies();
  Future<List<Movie>> searchMovies(String query);
  Future<List<Movie>> getSavedMovies();
  Future<void> saveMovie(Movie movie);
  Future<void> removeMovie(int movieId);
  Future<bool> isMovieSaved(int movieId);
}