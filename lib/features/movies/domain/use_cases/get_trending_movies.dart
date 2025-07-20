import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetTrendingMoviesUseCase {
  final MovieRepository repository;

  GetTrendingMoviesUseCase(this.repository);

  Future<List<Movie>> call() async {
    return await repository.getTrendingMovies();
  }
}