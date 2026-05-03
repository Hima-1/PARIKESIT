import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opd user can view their profile', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login as OPD
    await loginAs(tester, 'dpupr@klaten.go.id', 'password');

    // Wait for Dashboard
    await pumpUntil(tester, find.text('dpupr@klaten.go.id'));

    // Profile is opened from the user avatar in the app header.
    await tester.tap(find.byType(CircleAvatar).last);
    await tester.pumpAndSettle();

    // Verify Profile screen
    await pumpUntil(tester, find.text('Profil Pengguna'));
    expect(find.text('Nama Lengkap'), findsOneWidget);
    expect(find.text('Email'), findsWidgets); // Both label and value
    expect(find.text('Peran'), findsOneWidget);
    expect(find.text('OPD'), findsOneWidget); // Role value for this user
  });
}
