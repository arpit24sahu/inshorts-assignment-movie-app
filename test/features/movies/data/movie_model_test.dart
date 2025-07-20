import 'package:flutter_test/flutter_test.dart';
import 'package:movie/features/movies/data/models/movie_model.dart';

void main() {
  group('MovieModel', () {
    final tMovieModel = MovieModel(
      id: 1,
      title: 'test',
      originalTitle: 'orig',
      overview: 'desc',
      posterPath: '/poster.png',
      backdropPath: '/bd.png',
      releaseDate: '2020-01-01',
      voteAverage: 3.0,
      voteCount: 5,
      popularity: 10.2,
      adult: false,
      video: false,
      originalLanguage: 'en',
      genreIds: [1, 2, 3],
    );

    test('serializes/deserializes correctly', () {
      final json = tMovieModel.toJson();
      final fromJsonModel = MovieModel.fromJson(json);
      expect(fromJsonModel, tMovieModel);
    });

    test('props equality (equatable)', () {
      final a = tMovieModel;
      final b = MovieModel.fromJson(a.toJson());
      expect(a, equals(b));
      expect(a.props, equals(b.props));
    });
  });
}
