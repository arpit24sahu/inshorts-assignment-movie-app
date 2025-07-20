import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/movies_state.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';
import 'package:movie/features/movies/presentation/pages/saved_page.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

void main() {
  late MockMoviesBloc mockBloc;
  final tMovie = Movie(
    id: 101,
    title: 'Saved Movie',
    originalTitle: 'origTitle',
    overview: '',
    posterPath: '',
    backdropPath: '',
    releaseDate: '',
    voteAverage: 0.0,
    voteCount: 0,
    popularity: 0.0,
    adult: false,
    video: false,
    originalLanguage: 'en',
    genreIds: [],
  );

  setUp(() {
    mockBloc = MockMoviesBloc();
  });

  Widget makeWidgetUnderTest() => MaterialApp(
    home: BlocProvider<MoviesBloc>.value(
      value: mockBloc,
      child: const SavedPage(),
    ),
  );

  group('SavedPage Widget', () {
    testWidgets('shows empty when there are no saved movies', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const MoviesState(savedMovies: []));
      when(() => mockBloc.stream)
          .thenAnswer((_) => Stream.value(const MoviesState(savedMovies: [])));

      await tester.pumpWidget(makeWidgetUnderTest());
      expect(find.text('No saved movies yet'), findsOneWidget);
    });

    testWidgets('shows saved movie cards', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(MoviesState(savedMovies: [tMovie]));
      when(() => mockBloc.stream)
          .thenAnswer((_) => Stream.value(MoviesState(savedMovies: [tMovie])));

      await tester.pumpWidget(makeWidgetUnderTest());
      expect(find.textContaining('Saved Movie'), findsWidgets);
    });
  });
}




