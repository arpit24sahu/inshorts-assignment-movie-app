import 'package:flutter_test/flutter_test.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';

void main() {
  group('Movie Entity', () {
    test('value equality (Equatable)', () {
      final a = Movie(
        id: 1,
        title: 'A',
        originalTitle: 'A',
        overview: '',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        releaseDate: '2024-02-01',
        voteAverage: 5.0,
        voteCount: 100,
        popularity: 123.4,
        adult: false,
        video: false,
        originalLanguage: 'en',
        genreIds: [1, 2],
      );
      final b = Movie(
        id: 1,
        title: 'A',
        originalTitle: 'A',
        overview: '',
        posterPath: '/poster.jpg',
        backdropPath: '/backdrop.jpg',
        releaseDate: '2024-02-01',
        voteAverage: 5.0,
        voteCount: 100,
        popularity: 123.4,
        adult: false,
        video: false,
        originalLanguage: 'en',
        genreIds: [1, 2],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test(
        'fullPosterPath returns properly formed URL when path is non-empty', () {
      final movie = Movie(
        id: 2,
        title: 'with poster',
        originalTitle: '',
        overview: '',
        posterPath: '/poster.png',
        backdropPath: '',
        releaseDate: '',
        voteAverage: 0.0,
        voteCount: 0,
        popularity: 0.0,
        adult: false,
        video: false,
        originalLanguage: '',
        genreIds: [],
      );
      expect(movie.fullPosterPath, contains('/poster.png'));
      expect(
          movie.fullPosterPath, startsWith('https://image.tmdb.org/t/p/w500'));
    });

    test('fullPosterPath returns empty string if path is null or blank', () {
      final movie1 = Movie(
          id: 3,
          title: '-',
          originalTitle: '',
          overview: '',
          posterPath: null,
          backdropPath: '',
          releaseDate: '',
          voteAverage: 0,
          voteCount: 0,
          popularity: 0,
          adult: false,
          video: false,
          originalLanguage: '',
          genreIds: []);
      final movie2 = Movie(
          id: 4,
          title: '-',
          originalTitle: '',
          overview: '',
          posterPath: '',
          backdropPath: '',
          releaseDate: '',
          voteAverage: 0,
          voteCount: 0,
          popularity: 0,
          adult: false,
          video: false,
          originalLanguage: '',
          genreIds: []);
      expect(movie1.fullPosterPath, '');
      expect(movie2.fullPosterPath, '');
    });

    test(
        'fullBackdropPath returns properly formed URL when path is non-empty', () {
      final movie = Movie(
        id: 5,
        title: 'with backdrop',
        originalTitle: '',
        overview: '',
        posterPath: '',
        backdropPath: '/bd.png',
        releaseDate: '',
        voteAverage: 0.0,
        voteCount: 0,
        popularity: 0.0,
        adult: false,
        video: false,
        originalLanguage: '',
        genreIds: [],
      );
      expect(movie.fullBackdropPath, contains('/bd.png'));
      expect(movie.fullBackdropPath,
          startsWith('https://image.tmdb.org/t/p/original'));
    });

    test('fullBackdropPath returns empty string if path is null or blank', () {
      final movie1 = Movie(
          id: 6,
          title: '-',
          originalTitle: '',
          overview: '',
          posterPath: '',
          backdropPath: null,
          releaseDate: '',
          voteAverage: 0,
          voteCount: 0,
          popularity: 0,
          adult: false,
          video: false,
          originalLanguage: '',
          genreIds: []);
      final movie2 = Movie(
          id: 7,
          title: '-',
          originalTitle: '',
          overview: '',
          posterPath: '',
          backdropPath: '',
          releaseDate: '',
          voteAverage: 0,
          voteCount: 0,
          popularity: 0,
          adult: false,
          video: false,
          originalLanguage: '',
          genreIds: []);
      expect(movie1.fullBackdropPath, '');
      expect(movie2.fullBackdropPath, '');
    });
  });
}
