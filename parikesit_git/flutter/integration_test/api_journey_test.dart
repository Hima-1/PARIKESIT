import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/features/auth/presentation/login_screen.dart';
import 'package:parikesit/main.dart' as app;

Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 20),
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

  testWidgets('login as admin', (tester) async {
    app.main();
    await tester.pumpAndSettle();

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
    expect(find.text('Dashboard Admin'), findsOneWidget);
  });
}
