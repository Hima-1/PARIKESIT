import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/public/presentation/widgets/public_flow_widgets.dart';

void main() {
  testWidgets('PublicStaggeredReveal animates after configured delay', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PublicStaggeredReveal(
            key: ValueKey<String>('reveal'),
            delay: Duration.zero,
            duration: Duration(milliseconds: 300),
            child: Text('animated-content'),
          ),
        ),
      ),
    );

    final fadeFinder = find.descendant(
      of: find.byKey(const ValueKey<String>('reveal')),
      matching: find.byType(FadeTransition),
    );
    FadeTransition transition = tester.widget<FadeTransition>(fadeFinder);
    expect(transition.opacity.value, lessThan(1));

    await tester.pump(const Duration(milliseconds: 150));
    transition = tester.widget<FadeTransition>(fadeFinder);
    expect(transition.opacity.value, greaterThan(0));

    await tester.pumpAndSettle();
    transition = tester.widget<FadeTransition>(fadeFinder);
    expect(transition.opacity.value, 1);
  });
}
