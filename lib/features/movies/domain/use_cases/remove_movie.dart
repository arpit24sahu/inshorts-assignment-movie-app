import '../repositories/movie_repository.dart';

class RemoveMovieUseCase {
  final MovieRepository repository;

  RemoveMovieUseCase(this.repository);

  Future<void> call(int movieId) async {
    await repository.removeMovie(movieId);
  }
}