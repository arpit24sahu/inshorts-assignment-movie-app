import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetSavedMoviesUseCase {
  final MovieRepository repository;

  GetSavedMoviesUseCase(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getSavedMovies();
  }
}