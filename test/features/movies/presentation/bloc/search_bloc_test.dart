import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movie/features/movies/presentation/bloc/search_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/search_event.dart';
import 'package:movie/features/movies/presentation/bloc/search_state.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';
import 'package:movie/features/movies/domain/use_cases/search_movies.dart';

class MockSearchMovies extends Mock implements SearchMoviesUseCase {}

final mockMovie = Movie(
  id: 5,
  title: 'Search Movie',
  originalTitle: 'Original Search Movie',
  overview: 'This is a test overview.',
  posterPath: '/poster.jpg',
  backdropPath: '/backdrop.jpg',
  releaseDate: '2023-01-01',
  voteAverage: 7.3,
  voteCount: 952,
  popularity: 88.6,
  adult: false,
  video: false,
  originalLanguage: 'en',
  genreIds: [18, 35],
);

void main() {
  final getIt = GetIt.I;
  late MockSearchMovies mockSearchMovies;
  late SearchBloc bloc;

  setUpAll(() {
    registerFallbackValue('test-query');
    registerFallbackValue(Movie(id: 1,
        title: 'title',
        originalTitle: 'original title',
        overview: '',
        posterPath: '',
        backdropPath: '',
        releaseDate: '',
        voteAverage: 0.0,
        voteCount: 0,
        popularity: 0.0,
        adult: false,
        video: false,
        originalLanguage: '',
        genreIds: []));
  });

  setUp(() {
    getIt.reset();
    mockSearchMovies = MockSearchMovies();
    getIt.registerSingleton<SearchMoviesUseCase>(mockSearchMovies);
    bloc = SearchBloc(searchMovies: mockSearchMovies);
  });

  tearDown(() async {
    await getIt.reset();
    bloc.close();
  });

  group('SearchBloc', () {
    test('initial state is SearchState()', () {
      expect(bloc.state, equals(const SearchState()));
    });

    blocTest<SearchBloc, SearchState>(
      'emits [loading, loaded] when SearchMoviesEvent (non-empty) is added and SearchMoviesUseCase succeeds',
      build: () {
        when(() => mockSearchMovies('marvel')).thenAnswer((_) async =>
        [
          mockMovie
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchMoviesEvent('marvel')),
      wait: const Duration(milliseconds: 1100),
      expect: () =>
      [
        const SearchState(isLoading: true, query: 'marvel'),
        SearchState(movies: [mockMovie], isLoading: false, query: 'marvel'),
      ],
      verify: (_) {
        verify(() => mockSearchMovies('marvel')).called(1);
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, error] when SearchMoviesUseCase throws',
      build: () {
        when(() => mockSearchMovies('fail')).thenThrow(
            Exception('Search failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchMoviesEvent('fail')),
      wait: const Duration(milliseconds: 1100),
      expect: () =>
      [
        const SearchState(isLoading: true, query: 'fail'),
        const SearchState(
            isLoading: false, query: 'fail', error: 'Exception: Search failed'),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits empty movies immediately if query is empty',
      build: () {
        return bloc;
      },
      act: (bloc) => bloc.add(const SearchMoviesEvent('')),
      expect: () =>
      [
        const SearchState(movies: [], isLoading: false, query: '', error: null),
      ],
      verify: (_) {
        verifyNever(() => mockSearchMovies(any()));
      },
    );

    blocTest<SearchBloc, SearchState>(
      'emits initial state when ClearSearchEvent is added after search',
      build: () {
        final batmanMovie = mockMovie.copyWith(id: 30, title: 'Batman');
        when(() => mockSearchMovies('batman')).thenAnswer((_) async =>
        [
          batmanMovie
        ]);
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SearchMoviesEvent('batman'));
        await Future.delayed(const Duration(milliseconds: 1200));
        bloc.add(ClearSearchEvent());
      },
      expect: () =>
      [
        const SearchState(isLoading: true, query: 'batman'),
        SearchState(movies: [mockMovie.copyWith(id: 30, title: 'Batman')],
            isLoading: false,
            query: 'batman'),
        const SearchState(),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'debounces subsequent search events',
      build: () {
        final firstMovie = mockMovie.copyWith(id: 11, title: 'Movie1');
        final secondMovie = mockMovie.copyWith(id: 12, title: 'Movie2');
        when(() => mockSearchMovies('first')).thenAnswer((_) async =>
        [
          firstMovie
        ]);
        when(() => mockSearchMovies('second')).thenAnswer((_) async =>
        [
          secondMovie
        ]);
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const SearchMoviesEvent('first'));
        await Future.delayed(const Duration(milliseconds: 300));
        bloc.add(const SearchMoviesEvent('second'));
        await Future.delayed(const Duration(milliseconds: 1200));
      },
      expect: () =>
      [
        const SearchState(isLoading: true, query: 'second'),
        SearchState(movies: [mockMovie.copyWith(id: 12, title: 'Movie2')],
            isLoading: false,
            query: 'second'),
      ],
      verify: (_) {
        verifyNever(() => mockSearchMovies('first'));
        verify(() => mockSearchMovies('second')).called(1);
      },
    );
  });
}

extension MovieCopyWith on Movie {
  Movie copyWith({
    int? id,
    String? title,
    String? originalTitle,
    String? overview,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    double? voteAverage,
    int? voteCount,
    double? popularity,
    bool? adult,
    bool? video,
    String? originalLanguage,
    List<int>? genreIds,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      adult: adult ?? this.adult,
      video: video ?? this.video,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      genreIds: genreIds ?? this.genreIds,
    );
  }
}
