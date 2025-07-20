import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SaveMovieUseCase {
  final MovieRepository repository;

  SaveMovieUseCase(this.repository);

  Future<void> call(Movie movie) async {
    await repository.saveMovie(movie);
  }
}