import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/home/presentation/widgets/walidata/walidata_activity_card.dart';

void main() {
  testWidgets('renders walidata progress details and in-progress status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WalidataActivityCard(
            title: 'Evaluasi SPBE 2026',
            date: DateTime(2026, 3, 14),
            correctedCount: 8,
            totalCount: 10,
            percentage: 80,
            finalCorrectionScore: 4.25,
          ),
        ),
      ),
    );

    expect(find.text('Evaluasi SPBE 2026'), findsOneWidget);
    expect(find.text('Koreksi Walidata'), findsOneWidget);
    expect(find.text('8/10 (80%)'), findsOneWidget);
    expect(find.text('4.25'), findsOneWidget);
    expect(find.text('Proses koreksi masih berlangsung'), findsOneWidget);
  });

  testWidgets('renders completed status without final score when absent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WalidataActivityCard(
            title: 'Evaluasi SPBE 2026',
            date: DateTime(2026, 3, 14),
            correctedCount: 10,
            totalCount: 10,
            percentage: 100,
          ),
        ),
      ),
    );

    expect(find.text('10/10 (100%)'), findsOneWidget);
    expect(find.text('Semua indikator sudah dikoreksi'), findsOneWidget);
    expect(find.text('Nilai Akhir'), findsNothing);
  });

  testWidgets('uses tap handler for navigation into activity details', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WalidataActivityCard(
            title: 'Evaluasi SPBE 2026',
            date: DateTime(2026, 3, 14),
            correctedCount: 4,
            totalCount: 8,
            percentage: 50,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(WalidataActivityCard));
    expect(tapped, isTrue);
  });
}
