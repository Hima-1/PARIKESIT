import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Walidata Dashboard Navigation', () {
    testWidgets('navigate to Riwayat', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loginAs(tester, 'diskominfo@klaten.go.id', 'password');
      await pumpUntil(tester, find.text('Profil Performa OPD'));

      final shortcut = find.text('Riwayat');
      await tester.ensureVisible(shortcut);
      await tester.tap(shortcut);
      await tester.pumpAndSettle();

      await pumpUntil(tester, find.text('Penilaian Selesai'));
      expect(find.text('Penilaian Selesai'), findsOneWidget);
    });

    testWidgets('navigate to Dokumen', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loginAs(tester, 'diskominfo@klaten.go.id', 'password');
      await pumpUntil(tester, find.text('Profil Performa OPD'));

      final shortcut = find.text('Dokumen');
      await tester.ensureVisible(shortcut);
      await tester.tap(shortcut);
      await tester.pumpAndSettle();

      // Screen title for RouteConstants.pembinaan is usually "Pembinaan" or similar
      await pumpUntil(tester, find.text('Pembinaan'));
      expect(find.text('Pembinaan'), findsOneWidget);
    });

    testWidgets('navigate to Profil', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await loginAs(tester, 'diskominfo@klaten.go.id', 'password');
      await pumpUntil(tester, find.text('Profil Performa OPD'));

      final shortcut = find.text('Profil');
      await tester.ensureVisible(shortcut);
      await tester.tap(shortcut);
      await tester.pumpAndSettle();

      await pumpUntil(tester, find.text('Profil Pengguna'));
      expect(find.text('Profil Pengguna'), findsOneWidget);
    });
  });
}
