import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/features/public/presentation/landing_public_screen.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user can logout from profile screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Login
    await loginAs(tester, 'admin@gmail.com', 'password');

    // Wait for Dashboard
    await pumpUntil(tester, find.text('Dashboard Admin'));

    // Navigate to Profile
    if (tester.view.physicalSize.width / tester.view.devicePixelRatio < 600) {
      await tester.tap(find.text('Profile'));
    } else {
      await tester.tap(find.text('Profil'));
    }
    await tester.pumpAndSettle();

    // Verify Profile screen
    await pumpUntil(tester, find.text('Profil Pengguna'));

    // Tap Logout tile in profile actions
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    // Confirm Logout in Dialog
    await pumpUntil(tester, find.text('Keluar Aplikasi'));
    await tester.tap(find.text('Keluar').last);
    await tester.pumpAndSettle();

    expect(find.text('Data pengguna tidak ditemukan.'), findsNothing);

    // Verify back to landing screen
    await pumpUntil(tester, find.byKey(LandingPublicScreen.aboutHeroKey));
    expect(find.byKey(LandingPublicScreen.aboutHeroKey), findsOneWidget);
    expect(find.text('Selamat Datang'), findsNothing);
  });
}
