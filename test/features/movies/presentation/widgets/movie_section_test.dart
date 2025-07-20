import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/features/movies/presentation/widgets/movie_section.dart';
import 'package:movie/features/movies/domain/entities/movie.dart';

void main() {
  final movie = Movie(
    id: 9,
    title: 'MovieTitle',
    originalTitle: '-',
    overview: '',
    posterPath: '',
    backdropPath: '',
    releaseDate: '2022-01-01',
    voteAverage: 8,
    voteCount: 100,
    popularity: 99.0,
    adult: false,
    video: false,
    originalLanguage: 'en',
    genreIds: const [],
  );

  Widget widgetUnderTest(
      {bool isLoading = false, List<Movie>? movies, VoidCallback? loadMore}) =>
      MaterialApp(
        home: MovieSection(
          title: 'Section',
          movies: movies ?? [movie],
          isLoading: isLoading,
          onLoadMore: loadMore,
        ),
      );

  testWidgets('shows shimmer when loading and empty', (tester) async {
    await tester.pumpWidget(widgetUnderTest(isLoading: true, movies: []));
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('shows list of movies', (tester) async {
    await tester.pumpWidget(widgetUnderTest(movies: [movie, movie]));
    expect(find.byType(MovieSection), findsOneWidget);
  });

  testWidgets('shows load more button if onLoadMore provided', (tester) async {
    await tester.pumpWidget(widgetUnderTest(loadMore: () {}));
    expect(find.text('Load More'), findsOneWidget);
  });
}
