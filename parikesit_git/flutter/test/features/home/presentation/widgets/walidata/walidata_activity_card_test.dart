import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
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
            pendingIndicators: const <PendingIndicatorPreview>[],
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
            pendingIndicators: const <PendingIndicatorPreview>[],
          ),
        ),
      ),
    );

    expect(find.text('10/10 (100%)'), findsOneWidget);
    expect(find.text('Semua indikator sudah dikoreksi'), findsOneWidget);
    expect(find.text('Nilai Akhir'), findsNothing);
  });

  testWidgets('renders preview for pending indicators', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WalidataActivityCard(
            title: 'Evaluasi SPBE 2026',
            date: DateTime(2026, 3, 14),
            correctedCount: 4,
            totalCount: 8,
            percentage: 50,
            pendingIndicators: const <PendingIndicatorPreview>[
              PendingIndicatorPreview(
                id: 1,
                name: 'Indikator A',
                domain: 'Domain A',
                aspect: 'Aspek A',
                userId: 5,
                userName: 'Dinas Kominfo',
              ),
              PendingIndicatorPreview(
                id: 2,
                name: 'Indikator B',
                domain: 'Domain B',
                aspect: 'Aspek B',
                userId: 6,
                userName: 'Bappeda',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Indikator Belum Dikoreksi'), findsOneWidget);
    expect(find.text('Indikator A'), findsOneWidget);
    expect(find.text('Domain A | Aspek A'), findsOneWidget);
    expect(
      find.text('Ketuk kartu untuk membuka daftar OPD dan detail indikator.'),
      findsOneWidget,
    );
  });
}
