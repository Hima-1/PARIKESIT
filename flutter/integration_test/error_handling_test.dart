import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Error Handling and Validations', () {
    testWidgets('login fails with wrong password', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAs(tester, 'admin@gmail.com', 'wrongpassword');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Wait for error message (snackbar or dialog)
      // Usually shows "Login Gagal" or "Kredensial tidak valid"
      // Based on previous code observations, let's look for text that indicates failure.
      // If we don't know the exact text, we can look for SnackBar.
      await tester.pump(
        const Duration(seconds: 1),
      ); // Give some time for API response

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('admin master data form validation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAs(tester, 'admin@gmail.com', 'password');
      await pumpUntil(tester, find.text('Dashboard Admin'));

      // Navigate to Master Data
      if (tester.view.physicalSize.width / tester.view.devicePixelRatio < 600) {
        await tester.tap(find.text('Master'));
      } else {
        await tester.tap(find.text('Master Data'));
      }
      await tester.pumpAndSettle();

      // Open creation form
      await tester.tap(find.byKey(const Key('admin-master-add-domain')));
      await tester.pumpAndSettle();

      // Submit empty form
      await tester.tap(find.byKey(const Key('admin-master-form-save')));
      await tester.pumpAndSettle();

      // Verify validation errors are shown
      expect(find.text('Nama wajib diisi'), findsOneWidget);
      expect(
        find.text('Bobot wajib diisi'),
        findsNothing,
      ); // It has default '0' usually, let's check

      // Enter invalid weight (not a number if possible, but keyboardType is number)
      // Clear weight and submit
      await tester.enterText(
        find.byKey(const Key('admin-master-form-weight')),
        '',
      );
      await tester.tap(find.byKey(const Key('admin-master-form-save')));
      await tester.pumpAndSettle();
      expect(find.text('Bobot wajib diisi'), findsOneWidget);
    });

    testWidgets('admin user form validation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAs(tester, 'admin@gmail.com', 'password');
      await pumpUntil(tester, find.text('Dashboard Admin'));

      // Navigate to User Management
      if (tester.view.physicalSize.width / tester.view.devicePixelRatio < 600) {
        await tester.tap(find.text('Users'));
      } else {
        await tester.tap(find.text('Manajemen User'));
      }
      await tester.pumpAndSettle();

      // Open User creation form
      await tester.tap(find.byKey(const Key('admin-user-add')));
      await tester.pumpAndSettle();

      // Submit empty form
      await tester.tap(find.byKey(const Key('admin-user-form-submit')));
      await tester.pumpAndSettle();

      // Verify validation errors
      expect(find.text('Nama wajib diisi'), findsOneWidget);
      expect(find.text('Email tidak valid'), findsOneWidget);
      expect(find.text('Password minimal 8 karakter'), findsOneWidget);
      expect(find.text('Nomor telepon wajib diisi'), findsOneWidget);
      expect(find.text('Alamat wajib diisi'), findsOneWidget);
    });
  });
}
