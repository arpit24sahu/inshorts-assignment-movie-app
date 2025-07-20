import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:movie/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/movies_event.dart';
import 'package:movie/features/movies/presentation/bloc/movies_state.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';
import 'package:movie/features/movies/domain/use_cases/get_trending_movies.dart';
import 'package:movie/features/movies/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie/features/movies/domain/use_cases/get_saved_movies.dart';
import 'package:movie/features/movies/domain/use_cases/save_movie.dart';
import 'package:movie/features/movies/domain/use_cases/remove_movie.dart';

// Mock classes for all use cases
class MockGetTrendingMovies extends Mock implements GetTrendingMoviesUseCase {}

class MockGetNowPlayingMovies extends Mock
    implements GetNowPlayingMoviesUseCase {}

class MockGetSavedMovies extends Mock implements GetSavedMoviesUseCase {}

class MockSaveMovie extends Mock implements SaveMovieUseCase {}

class MockRemoveMovie extends Mock implements RemoveMovieUseCase {}

final mockMovie = Movie(
  id: 1,
  title: 'Mock Movie',
  originalTitle: 'Mock Movie Original',
  overview: 'A mock overview.',
  posterPath: '/mockPoster.jpg',
  backdropPath: '/mockBackdrop.jpg',
  releaseDate: '2022-01-01',
  voteAverage: 8.5,
  voteCount: 1482,
  popularity: 321.0,
  adult: false,
  video: false,
  originalLanguage: 'en',
  genreIds: [12, 28],
);

void main() {
  final getIt = GetIt.I;
  late MockGetTrendingMovies mockGetTrendingMovies;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetSavedMovies mockGetSavedMovies;
  late MockSaveMovie mockSaveMovie;
  late MockRemoveMovie mockRemoveMovie;
  late MoviesBloc bloc;

  setUp(() {
    getIt.reset();
    mockGetTrendingMovies = MockGetTrendingMovies();
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetSavedMovies = MockGetSavedMovies();
    mockSaveMovie = MockSaveMovie();
    mockRemoveMovie = MockRemoveMovie();
    getIt.registerSingleton<GetTrendingMoviesUseCase>(mockGetTrendingMovies);
    getIt.registerSingleton<GetNowPlayingMoviesUseCase>(
        mockGetNowPlayingMovies);
    getIt.registerSingleton<GetSavedMoviesUseCase>(mockGetSavedMovies);
    getIt.registerSingleton<SaveMovieUseCase>(mockSaveMovie);
    getIt.registerSingleton<RemoveMovieUseCase>(mockRemoveMovie);
    bloc = MoviesBloc(
      getTrendingMovies: mockGetTrendingMovies,
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getSavedMovies: mockGetSavedMovies,
      saveMovie: mockSaveMovie,
      removeMovie: mockRemoveMovie,
    );
  });

  setUpAll(() {
    registerFallbackValue(mockMovie);
  });

  tearDown(() async {
    await getIt.reset();
    bloc.close();
  });

  group('MoviesBloc', () {
    test('initial state is MoviesState()', () {
      expect(bloc.state, equals(const MoviesState()));
    });

    blocTest<MoviesBloc, MoviesState>(
      'emits [loading, loaded] when LoadTrendingMovies is added and use case succeeds',
      build: () {
        when(() => mockGetTrendingMovies()).thenAnswer((_) async =>
        [
          mockMovie
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTrendingMovies()),
      expect: () =>
      [
        const MoviesState(isLoadingTrending: true),
        MoviesState(
          trendingMovies: [mockMovie],
          isLoadingTrending: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetTrendingMovies()).called(1);
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'emits [loading, loaded] when LoadNowPlayingMovies is added and use case succeeds',
      build: () {
        when(() => mockGetNowPlayingMovies()).thenAnswer((_) async =>
        [
          mockMovie
        ]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadNowPlayingMovies()),
      expect: () =>
      [
        const MoviesState(isLoadingNowPlaying: true),
        MoviesState(
          nowPlayingMovies: [mockMovie],
          isLoadingNowPlaying: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetNowPlayingMovies()).called(1);
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'emits [loading, loaded] when LoadSavedMovies is added and use case succeeds',
      build: () {
        when(() => mockGetSavedMovies()).thenAnswer((_) async => [mockMovie]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadSavedMovies()),
      expect: () =>
      [
        const MoviesState(isLoadingSaved: true),
        MoviesState(
          savedMovies: [mockMovie],
          isLoadingSaved: false,
        ),
      ],
      verify: (_) {
        verify(() => mockGetSavedMovies()).called(1);
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'emits savedMovies updated after SaveMovieEvent',
      build: () {
        when(() => mockSaveMovie(any())).thenAnswer((_) async =>
            Future.value());
        when(() => mockGetSavedMovies()).thenAnswer((_) async => [mockMovie]);
        return bloc;
      },
      act: (bloc) => bloc.add(SaveMovieEvent(mockMovie)),
      expect: () =>
      [
        MoviesState(savedMovies: [mockMovie]),
      ],
      verify: (_) {
        verify(() => mockSaveMovie(any())).called(1);
        verify(() => mockGetSavedMovies()).called(1);
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'emits savedMovies updated after RemoveMovieEvent',
      build: () {
        when(() => mockRemoveMovie(any())).thenAnswer((_) async =>
            Future.value());
        when(() => mockGetSavedMovies()).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveMovieEvent(mockMovie.id)),
      expect: () =>
      [
        const MoviesState(savedMovies: []),
      ],
      verify: (_) {
        verify(() => mockRemoveMovie(any())).called(1);
        verify(() => mockGetSavedMovies()).called(1);
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'emits error when use cases throw',
      build: () {
        when(() => mockGetTrendingMovies()).thenThrow(Exception('Failed'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTrendingMovies()),
      expect: () =>
      [
        const MoviesState(isLoadingTrending: true),
        MoviesState(isLoadingTrending: false, error: 'Exception: Failed'),
      ],
    );
  });
}
