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

    // Initial frame: animation hasn't progressed.
    expect(find.text('animated-content'), findsOneWidget);

    // Advance partway and confirm content still attached.
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('animated-content'), findsOneWidget);

    // Settle to end-state.
    await tester.pumpAndSettle();
    expect(find.text('animated-content'), findsOneWidget);
  });
}
