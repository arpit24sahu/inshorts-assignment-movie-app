import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/movies_state.dart';
import 'package:movie/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

void main() {
  final movie = Movie(
    id: 33,
    title: 'Spiderman',
    originalTitle: 'Spider',
    overview: 'Some superhero.',
    posterPath: "/tt.jpg",
    backdropPath: "/bb.jpg",
    releaseDate: '2020-05-01',
    voteAverage: 6.5,
    voteCount: 140,
    popularity: 98.0,
    adult: false,
    video: false,
    originalLanguage: 'en',
    genreIds: [247],
  );

  late MockMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockMoviesBloc();
  });

  Widget testable({Movie? data}) => MaterialApp(
    home: BlocProvider<MoviesBloc>.value(
      value: mockBloc,
      child: MovieDetailPage(
        movieId: 33,
        movie: data,
      ),
    ),
  );

  testWidgets('renders detail info when movie is given', (tester) async {
    // Provide state and stream stub: this makes BlocProvider work!
    when(() => mockBloc.state).thenReturn(const MoviesState());
    when(() => mockBloc.stream)
        .thenAnswer((_) => const Stream<MoviesState>.empty());

    await tester.pumpWidget(testable(data: movie));
    expect(find.text('Spiderman'), findsWidgets);
    expect(find.textContaining('Overview'), findsWidgets);
    expect(find.textContaining('Movie Details'), findsOneWidget);
  });

  testWidgets('shows fallback not found for missing movie', (tester) async {
    when(() => mockBloc.state).thenReturn(const MoviesState());
    when(() => mockBloc.stream)
        .thenAnswer((_) => const Stream<MoviesState>.empty());

    await tester.pumpWidget(testable(data: null));
    expect(find.text('Movie not found'), findsOneWidget);
  });
}
