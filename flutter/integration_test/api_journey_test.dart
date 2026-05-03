import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login as admin', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await loginAs(tester, 'admin@gmail.com', 'password');
    await pumpUntil(tester, find.text('admin@gmail.com'));
    await pumpUntil(tester, find.text('Progress Penilaian'));

    expect(find.text('admin@gmail.com'), findsWidgets);
  });
}
