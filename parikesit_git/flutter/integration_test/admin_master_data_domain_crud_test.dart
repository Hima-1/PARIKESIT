import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/features/auth/presentation/login_screen.dart';
import 'package:parikesit/main.dart' as app;

Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
  Duration step = const Duration(milliseconds: 200),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Timed out waiting for: $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('admin can create and delete domain', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login
    await _pumpUntil(tester, find.byKey(LoginScreen.emailFieldKey));
    await tester.enterText(
      find.byKey(LoginScreen.emailFieldKey),
      'admin@gmail.com',
    );
    await tester.enterText(
      find.byKey(LoginScreen.passwordFieldKey),
      'password',
    );
    await tester.tap(find.byKey(LoginScreen.loginButtonKey));

    await _pumpUntil(tester, find.text('Dashboard Admin'));

    // Navigate to Master Data
    // Desktop layout uses permanent sidebar, but mobile layout uses bottom-nav.
    if (tester.view.physicalSize.width / tester.view.devicePixelRatio < 600) {
      await tester.tap(find.text('Master'));
    } else {
      await tester.tap(find.text('Master Data'));
    }
    await tester.pumpAndSettle();

    await _pumpUntil(tester, find.byKey(const Key('admin-master-add-domain')));

    // Create domain
    await tester.tap(find.byKey(const Key('admin-master-add-domain')));
    await tester.pumpAndSettle();

    await _pumpUntil(tester, find.byKey(const Key('admin-master-form-name')));
    await tester.enterText(
      find.byKey(const Key('admin-master-form-name')),
      'Domain IT Test',
    );
    await tester.enterText(
      find.byKey(const Key('admin-master-form-weight')),
      '10',
    );
    await tester.tap(find.byKey(const Key('admin-master-form-save')));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Expect domain appears in list
    await _pumpUntil(tester, find.text('Domain IT Test'));
    expect(find.text('Domain IT Test'), findsWidgets);

    // Delete domain by finding the first matching expansion tile and tapping its delete.
    // Note: without stable ID in test, we delete by matching the visible name.
    final domainTile = find
        .widgetWithText(ExpansionTile, 'Domain IT Test')
        .first;
    await tester.ensureVisible(domainTile);
    await tester.tap(domainTile);
    await tester.pumpAndSettle();

    // This will delete the domain only if its delete button is visible.
    // If multiple domains match, the first visible one is used.
    await tester.tap(
      find
          .descendant(
            of: domainTile,
            matching: find.byIcon(Icons.delete_outline),
          )
          .first,
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Domain should disappear
    expect(find.text('Domain IT Test'), findsNothing);
  });
}
