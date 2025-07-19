import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetSavedMovies {
  final MovieRepository repository;

  GetSavedMovies(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getSavedMovies();
  }
}