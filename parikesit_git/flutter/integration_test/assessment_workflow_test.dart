import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opd user can navigate to assessment activities', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login as OPD
    await loginAs(tester, 'dpupr@klaten.go.id', 'password');

    // Wait for Dashboard to load
    await pumpUntil(tester, find.text('Status Pengisian'));

    // Scroll to the "Penilaian" shortcut or "Kegiatan Penilaian"
    // The "Penilaian" shortcut icon is Icons.assignment_outlined with text 'Penilaian'
    final penilaianShortcut = find
        .descendant(of: find.byType(InkWell), matching: find.text('Penilaian'))
        .last;

    await tester.ensureVisible(penilaianShortcut);
    await tester.tap(penilaianShortcut);
    await tester.pumpAndSettle();

    // Now we should be on the Penilaian Mandiri screen
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Assert we successfully navigated to the Assessment page
    // It will either show the list of activities or an empty state message
    final listView = find.byType(ListView);
    final emptyState = find.text('Tidak ada formulir penilaian.');

    expect(
      listView.evaluate().isNotEmpty || emptyState.evaluate().isNotEmpty,
      isTrue,
      reason: 'Expected to find ListView or empty state text',
    );
  });
}
