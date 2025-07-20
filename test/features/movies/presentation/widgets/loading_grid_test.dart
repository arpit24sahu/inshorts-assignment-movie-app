import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/features/movies/presentation/widgets/loading_grid.dart';

void main() {
  testWidgets('renders 10 shimmer cards', (tester) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const MaterialApp(home: LoadingGrid()));

    final cards = find.byType(Card);
    expect(cards, findsNWidgets(10));
    expect(find.byType(GridView), findsOneWidget);
    addTearDown(tester.view.reset);
  });
}


