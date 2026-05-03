import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Walidata can review an assessment activity', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login as Walidata
    await loginAs(tester, 'diskominfo@klaten.go.id', 'password');

    // Wait for Dashboard using specialized helper
    await waitForDashboard(
      tester,
      marker: find.text('Profil Performa OPD'),
      label: 'Walidata',
    );

    // Find the first activity card in the list
    final activityCard = find.byType(EthnoCard).first;

    // If the list is empty, this test will fail here, which is expected
    // as we need seeded data for this flow.
    await navigateTo(
      tester,
      activityCard,
      targetText: 'Review Kegiatan',
      label: 'Activity Review Navigation',
    );

    // Verify content on the review screen
    expect(find.text('Ringkasan Nilai Domain'), findsOneWidget);

    // Check for the identity section (Data Identitas Penilai)
    final identitySection = find.text('Data Identitas Penilai');
    await tester.ensureVisible(identitySection);
    expect(identitySection, findsOneWidget);

    // 3.2 Ensure indicator detail loading is correctly verified
    // We expect ExpansionTiles for domains/indicators
    final domainExpansionTile = find.byType(ExpansionTile).first;
    if (domainExpansionTile.evaluate().isNotEmpty) {
      debugPrint('Expanding domain to verify indicators...');
      await tester.tap(domainExpansionTile);
      await tester.pumpAndSettle();

      // Look for an indicator within the expanded domain
      final indicatorItem = find
          .descendant(of: domainExpansionTile, matching: find.byType(ListTile))
          .first;

      if (indicatorItem.evaluate().isNotEmpty) {
        await navigateTo(
          tester,
          indicatorItem,
          targetText: 'Detail Indikator',
          label: 'Indicator Detail Navigation',
        );
        // Verify evidence or notes are present if available
        expect(find.textContaining('Evidence'), findsWidgets);
      }
    }
  });
}
