import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/search_bloc.dart';
import 'package:movie/features/movies/presentation/bloc/search_state.dart';
import 'package:movie/features/movies/presentation/pages/search_page.dart';

class MockSearchBloc extends Mock implements SearchBloc {
  @override
  Stream<SearchState> get stream => Stream.value(state);
}

void main() {
  late MockSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockSearchBloc();
  });

  Widget makeWidgetUnderTest() =>
      MaterialApp(
        home: BlocProvider<SearchBloc>.value(
          value: mockBloc,
          child: const SearchPage(),
        ),
      );

  group('SearchPage Widget', () {
    testWidgets('shows empty state when query is empty', (tester) async {
      when(() => mockBloc.state).thenReturn(const SearchState());
      await tester.pumpWidget(makeWidgetUnderTest());
      expect(find.textContaining('Search for your favorite movies'),
          findsOneWidget);
    });

    testWidgets('shows loading when isLoading is true', (tester) async {
      when(() => mockBloc.state).thenReturn(
          const SearchState(isLoading: true, query: 'hi'));
      await tester.pumpWidget(makeWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows no results UI when movies is empty and query is set', (
        tester) async {
      when(() => mockBloc.state).thenReturn(
          const SearchState(movies: [], query: 'spiderman', isLoading: false));
      await tester.pumpWidget(makeWidgetUnderTest());
      expect(find.textContaining('No movies found for'), findsOneWidget);
    });
  });
}
