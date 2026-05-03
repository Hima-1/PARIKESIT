import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/presentation/add_form_screen.dart';

void main() {
  testWidgets('renders create formulir form with template selector', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AddFormScreen()));

    expect(find.text('Gunakan template'), findsOneWidget);
    expect(find.text('Tambahkan'), findsOneWidget);
    expect(find.text('Edit Formulir'), findsNothing);
  });

  testWidgets('loads existing formulir name in edit mode', (
    WidgetTester tester,
  ) async {
    final AssessmentFormModel existing = AssessmentFormModel(
      id: '42',
      title: 'Formulir Lama',
      date: DateTime(2026, 3, 13),
      domains: const <DomainModel>[],
    );

    await tester.pumpWidget(
      MaterialApp(home: AddFormScreen(formulir: existing)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Formulir Lama'), findsWidgets);
    expect(find.text('Edit Formulir'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    expect(find.text('Gunakan template'), findsNothing);
  });
}
