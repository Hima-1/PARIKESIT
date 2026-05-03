import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login as walidata user and view dashboard', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Use a standard Walidata test account
    await loginAs(tester, 'diskominfo@klaten.go.id', 'password');

    // Wait for the Walidata Dashboard specific elements to appear using specialized helper
    await waitForDashboard(
      tester,
      marker: find.text('Profil Performa OPD'),
      label: 'Walidata',
    );

    // Verify that Walidata Dashboard widgets are present
    expect(find.text('Profil Performa OPD'), findsOneWidget);
    expect(find.text('Daftar Penilaian'), findsOneWidget);

    // Verify shortcuts are present
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Dokumen'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // Verify it's NOT the admin or opd dashboard
    expect(find.text('Dashboard Admin'), findsNothing);
    expect(find.text('Manajemen User'), findsNothing);

    expect(find.text('Status Pengisian'), findsNothing);
    expect(find.text('Mulai Penilaian'), findsNothing);
    expect(find.text('Kegiatan Penilaian'), findsNothing);

    // Verify shortcut navigation
    await navigateTo(
      tester,
      find.text('Riwayat'),
      targetText: 'Penilaian Selesai',
      label: 'Riwayat Shortcut Navigation',
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
  });
}
