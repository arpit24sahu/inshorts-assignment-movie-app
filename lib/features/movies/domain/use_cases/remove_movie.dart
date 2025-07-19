import '../repositories/movie_repository.dart';

class RemoveMovie {
  final MovieRepository repository;

  RemoveMovie(this.repository);

  Future<void> call(int movieId) async {
    await repository.removeMovie(movieId);
  }
}