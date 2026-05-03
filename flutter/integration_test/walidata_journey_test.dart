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
      marker: find.text('Progress Penilaian'),
      label: 'Walidata',
    );

    // Verify that Walidata Dashboard widgets are present
    expect(find.text('diskominfo@klaten.go.id'), findsWidgets);
    expect(find.text('Progress Penilaian'), findsOneWidget);

    // Verify bottom navigation is present
    expect(find.text('PENILAIAN'), findsOneWidget);
    expect(find.text('KEGIATAN'), findsOneWidget);

    // Verify it's NOT the admin or opd dashboard
    expect(find.text('Manajemen User'), findsNothing);

    expect(find.text('Status Pengisian'), findsNothing);
    expect(find.text('Mulai Penilaian'), findsNothing);

    // Verify bottom navigation
    await navigateTo(
      tester,
      find.text('PENILAIAN'),
      targetText: 'Antrian Koreksi',
      label: 'Penilaian Bottom Navigation',
    );
  });
}
