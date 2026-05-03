import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Walidata Dashboard Navigation', () {
    testWidgets('navigate through primary walidata destinations', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();
      await loginAs(tester, 'diskominfo@klaten.go.id', 'password');
      await pumpUntil(tester, find.text('Progress Penilaian'));

      final penilaianShortcut = find.text('PENILAIAN');
      await tester.ensureVisible(penilaianShortcut);
      await tester.tap(penilaianShortcut);
      await tester.pumpAndSettle();

      await pumpUntil(tester, find.text('Antrian Koreksi'));
      expect(find.text('Antrian Koreksi'), findsOneWidget);

      final dashboardShortcut = find.text('BERANDA');
      await tester.ensureVisible(dashboardShortcut);
      await tester.tap(dashboardShortcut);
      await tester.pumpAndSettle();
      await pumpUntil(tester, find.text('Progress Penilaian'));

      final kegiatanShortcut = find.text('KEGIATAN');
      await tester.ensureVisible(kegiatanShortcut);
      await tester.tap(kegiatanShortcut);
      await tester.pumpAndSettle();

      await pumpUntil(tester, find.text('Kegiatan'));
      expect(find.text('Kegiatan'), findsWidgets);

      await tester.tap(find.text('BERANDA'));
      await tester.pumpAndSettle();
      await pumpUntil(tester, find.text('Progress Penilaian'));

      await tester.tap(find.byType(CircleAvatar).last);
      await tester.pumpAndSettle();

      await pumpUntil(tester, find.text('Profil Pengguna'));
      expect(find.text('Profil Pengguna'), findsOneWidget);
    });
  });
}
