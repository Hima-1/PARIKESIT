import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';

void main() {
  testWidgets('EthnoCard renders flat shadcn surface with hairline border', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(body: EthnoCard(child: Text('Konten'))),
      ),
    );

    final Card card = tester.widget<Card>(find.byType(Card));

    expect(card.color, AppTheme.surface);
    expect(card.elevation, 0);
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.side.color, AppTheme.borderColor);
  });
}
