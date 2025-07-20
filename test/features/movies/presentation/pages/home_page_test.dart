import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';
import 'package:movie/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/movies_event.dart';
import 'package:movie/features/movies/presentation/bloc/movies_state.dart';
import 'package:movie/features/movies/presentation/pages/home_page.dart';
import 'package:movie/features/movies/presentation/widgets/shimmer_widget.dart';

class MockMoviesBloc extends Mock implements MoviesBloc {}

class MoviesEventFake extends Fake implements MoviesEvent {}

//
// final mockMovie = Movie(
//   id: 1,
//   title: 'Mock Movie',
//   originalTitle: 'Mock Movie Original',
//   overview: 'A mock overview.',
//   posterPath: '/mockPoster.jpg',
//   backdropPath: '/mockBackdrop.jpg',
//   releaseDate: '2022-01-01',
//   voteAverage: 8.5,
//   voteCount: 1482,
//   popularity: 321.0,
//   adult: false,
//   video: false,
//   originalLanguage: 'en',
//   genreIds: [12, 28],
// );

void main() {
  late MockMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockMoviesBloc();
  });

  setUpAll(() {
    registerFallbackValue(MoviesEventFake());
  });

  Widget makeWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<MoviesBloc>.value(
        value: mockBloc,
        child: const HomePage(),
      ),
    );
  }

  group('HomePage Widget', () {
    testWidgets('displays loading indicators for both sections', (tester) async {
      const loadingState = MoviesState(isLoadingTrending: true, isLoadingNowPlaying: true);
      when(() => mockBloc.state).thenReturn(loadingState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(loadingState));

      await tester.pumpWidget(makeWidgetUnderTest());
      // Only use pump(), not pumpAndSettle(), for single-state stream
      await tester.pump();

      expect(find.byKey(ValueKey("shimmer_list")), findsNWidgets(2));
      expect(find.text('Trending Movies'), findsOneWidget);
      expect(find.text('Now Playing'), findsOneWidget);
    });

    testWidgets('displays correct section headers', (tester) async {
      const headersState = MoviesState();
      when(() => mockBloc.state).thenReturn(headersState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(headersState));

      await tester.pumpWidget(makeWidgetUnderTest());
      await tester.pump();

      expect(find.text('Trending Movies'), findsOneWidget);
      expect(find.text('Now Playing'), findsOneWidget);
    });

    testWidgets('refresh triggers bloc event', (tester) async {
      const refreshState = MoviesState();
      when(() => mockBloc.state).thenReturn(refreshState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(refreshState));

      await tester.pumpWidget(makeWidgetUnderTest());
      await tester.pump();

      final refreshFinder = find.byType(RefreshIndicator);
      expect(refreshFinder, findsOneWidget);
    });

    testWidgets('renders empty lists as expected', (tester) async {
      const emptyState = MoviesState(trendingMovies: [], nowPlayingMovies: []);
      when(() => mockBloc.state).thenReturn(emptyState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(emptyState));

      await tester.pumpWidget(makeWidgetUnderTest());
      await tester.pump();

      expect(find.textContaining('Trending Movies'), findsOneWidget);
      expect(find.textContaining('Now Playing'), findsOneWidget);
    });
  });
}
