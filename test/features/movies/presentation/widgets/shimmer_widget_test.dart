import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/features/movies/presentation/widgets/shimmer_widget.dart';

void main() {
  testWidgets('renders default shimmer widget', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShimmerWidget()));
    expect(find.byType(ShimmerWidget), findsOneWidget);
    expect(find.byType(Container), findsOneWidget);
  });

  testWidgets('renders shimmer with specific size', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ShimmerWidget(width: 100, height: 20),
      ),
    );
    final widget = tester.widget<ShimmerWidget>(find.byType(ShimmerWidget));
    expect(widget.width, 100);
    expect(widget.height, 20);
  });
}
