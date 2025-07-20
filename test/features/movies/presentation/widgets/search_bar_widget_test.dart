import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/features/movies/presentation/widgets/search_bar_widget.dart';

void main() {
  testWidgets('renders hint and triggers onChanged', (tester) async {
    var changed = '';
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchBarWidget(
            hintText: 'Search...',
            controller: controller,
            onChanged: (v) => changed = v,
          ),
        ),
      ),
    );
    expect(find.text('Search...'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'matrix');
    expect(changed, 'matrix');
  });

  testWidgets('shows clear button when text is not empty', (tester) async {
    final controller = TextEditingController(text: 'abc');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchBarWidget(
            hintText: 'Search...',
            controller: controller,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.clear), findsOneWidget);
  });
}
