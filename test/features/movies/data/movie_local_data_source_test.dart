import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/features/movies/data/data_sources/movie_local_data_source.dart';
import 'package:movie/features/movies/data/models/movie_model.dart';

class MockBox extends Mock implements Box{}

void main() {
  late MockBox moviesBox;
  late MockBox savedMoviesBox;
  late MockBox cacheBox;
  late MovieLocalDataSourceImpl dataSource;
  final MovieModel movie = MovieModel(
    id: 1,
    title: 'title',
    originalTitle: 'original',
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
    genreIds: [],
  );

  setUp(() {
    moviesBox = MockBox();
    savedMoviesBox = MockBox();
    cacheBox = MockBox();
    dataSource = MovieLocalDataSourceImpl(
        moviesBox,
        savedMoviesBox,
        cacheBox
    );
  });

  group('CRUD for trending/now playing/saved', () {
    test('getTrendingMovies returns list from box', () async {
      when(() => moviesBox.get(any())).thenReturn([movie]);
      final res = await dataSource.getTrendingMovies();
      expect(res, [movie]);
    });

    test('getNowPlayingMovies returns list from box', () async {
      when(() => moviesBox.get(any())).thenReturn([movie]);
      final res = await dataSource.getNowPlayingMovies();
      expect(res, [movie]);
    });

    test('getSavedMovies returns all values', () async {
      when(() => savedMoviesBox.values).thenReturn([movie]);
      // when(() => savedMoviesBox.values).thenAnswer((_)=>[movie]);
      final res = await dataSource.getSavedMovies();
      expect(res, [movie]);
    });

    test('saveTrendingMovies stores as MovieModel and updates cache', () async {
      when(() => moviesBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => cacheBox.put(any(), any())).thenAnswer((_) async {});
      await dataSource.saveTrendingMovies([movie]);
      verify(() => moviesBox.put(any(), any())).called(1);
      verify(() => cacheBox.put(any(), any())).called(1);
    });

    test(
        'saveNowPlayingMovies stores as MovieModel and updates cache', () async {
      when(() => moviesBox.put(any(), any())).thenAnswer((_) async => {});
      when(() => cacheBox.put(any(), any())).thenAnswer((_) async {});
      await dataSource.saveNowPlayingMovies([movie]);
      verify(() => moviesBox.put(any(), any())).called(1);
      verify(() => cacheBox.put(any(), any())).called(1);
    });

    test('saveMovie puts in savedMoviesBox', () async {
      when(() => savedMoviesBox.put(any(), any())).thenAnswer((_) async => {});
      await dataSource.saveMovie(movie);
      verify (() => savedMoviesBox.put((movie.id), movie)).called(1);
    });

    test('removeMovie deletes from savedMoviesBox', () async {
      when(() => savedMoviesBox.delete(any())).thenAnswer((_) async => {});
      await dataSource.removeMovie(1);
      verify(() => savedMoviesBox.delete(1)).called(1);
    });

    test('isMovieSaved returns correct value', () async {
      when(() => savedMoviesBox.containsKey(1)).thenReturn(true);
      expect(await dataSource.isMovieSaved(1), true);
      when(() => savedMoviesBox.containsKey(42)).thenReturn(false);
      expect(await dataSource.isMovieSaved(42), false);
    });
  });

  group('Cache validation logic', () {
    test('isCacheValid returns true if cache age is under limit', () {
      final now = DateTime.now();
      when(() => cacheBox.get('some_key'))
          .thenReturn(now
          .subtract(Duration(hours: 2))
          .millisecondsSinceEpoch);
      expect(dataSource.isCacheValid('some_key'), true);
    });

    test('isCacheValid returns false if cache age is old', () {
      final now = DateTime.now();
      when(() => cacheBox.get('expired_key')).thenReturn(now
          .subtract(Duration(days: 2))
          .millisecondsSinceEpoch);
      expect(dataSource.isCacheValid('expired_key'), false);
    });

    test('isCacheValid returns false if cache key is null', () {
      when(() => cacheBox.get('foo')).thenReturn(null);
      expect(dataSource.isCacheValid('foo'), false);
    });

    test('updateCacheTimestamp stores with current time', () {
      when(() => cacheBox.put(any(), any())).thenAnswer((_) async {});
      dataSource.updateCacheTimestamp('bar');
      verify(() => cacheBox.put('bar', any(that: isA<int>()))).called(1);
    });
  });

  group('Edge cases', () {
    test('getTrendingMovies returns empty if null', () async {
      when(() => moviesBox.get(any())).thenReturn(null);
      final res = await dataSource.getTrendingMovies();
      expect(res, []);
    });
    test('getNowPlayingMovies returns empty if null', () async {
      when(() => moviesBox.get(any())).thenReturn(null);
      final res = await dataSource.getNowPlayingMovies();
      expect(res, []);
    });
    test('getSavedMovies returns empty list if box empty', () async {
      when(() => savedMoviesBox.values).thenReturn([]);
      final res = await dataSource.getSavedMovies();
      expect(res, isEmpty);
    });
  });
}
