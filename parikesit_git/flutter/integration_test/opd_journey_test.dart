import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login as opd user and view dashboard', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Use a standard OPD test account
    await loginAs(tester, 'dpupr@klaten.go.id', 'password');

    // Wait for the OPD Dashboard specific elements to appear
    await pumpUntil(tester, find.text('Status Pengisian'));

    // Verify that OPD Dashboard widgets are present
    expect(find.text('Status Pengisian'), findsOneWidget);
    expect(find.text('Formulir'), findsOneWidget);

    // Verify it's NOT the admin dashboard
    expect(find.text('Dashboard Admin'), findsNothing);
  });
}
