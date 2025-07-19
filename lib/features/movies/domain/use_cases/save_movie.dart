import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SaveMovie {
  final MovieRepository repository;

  SaveMovie(this.repository);

  Future<void> call(Movie movie) async {
    await repository.saveMovie(movie);
  }
}