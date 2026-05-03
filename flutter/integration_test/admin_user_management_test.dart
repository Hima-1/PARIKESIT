import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:parikesit/main.dart' as app;

import 'test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Admin User Management', () {
    testWidgets('admin can create and search users', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Login
      await loginAs(tester, 'admin@gmail.com', 'password');
      await pumpUntil(
        tester,
        find.text('Progress Penilaian'),
        label: 'Admin Dashboard',
      );

      // 2. Navigate to User Management
      final userManagementText =
          (tester.view.physicalSize.width / tester.view.devicePixelRatio < 600)
          ? 'USER'
          : 'Manajemen User';

      const addButton = Key('admin-user-add');

      await navigateTo(
        tester,
        find.text(userManagementText),
        targetText: 'Manajemen User',
        label: 'User Management Navigation',
      );

      // 3. Create User
      final testRunId = DateTime.now().millisecondsSinceEpoch;
      final testUserName = '[TEST_ADMIN] User IT $testRunId';
      final testUserEmail = 'test_it_user_$testRunId@example.com';

      await tapButton(tester, addButton, label: 'Add User Button');
      await pumpUntil(
        tester,
        find.byKey(const Key('admin-user-form-name')),
        label: 'User Form',
      );

      await enterFormText(
        tester,
        const Key('admin-user-form-name'),
        testUserName,
      );
      await enterFormText(
        tester,
        const Key('admin-user-form-email'),
        testUserEmail,
      );
      await enterFormText(
        tester,
        const Key('admin-user-form-password'),
        'password123',
      );
      await selectFromDropdown(
        tester,
        const Key('admin-user-form-role'),
        'OPD',
      );
      await enterFormText(
        tester,
        const Key('admin-user-form-phone'),
        '08123456789',
      );
      await enterFormText(
        tester,
        const Key('admin-user-form-address'),
        'Alamat Test',
      );

      await tapButton(
        tester,
        const Key('admin-user-form-submit'),
        label: 'Submit User',
      );

      // 4. Search for the created user
      await pumpUntil(
        tester,
        find.byKey(const Key('admin-user-search')),
        label: 'User List with Search',
      );
      await enterFormText(tester, const Key('admin-user-search'), testUserName);

      // Wait for results
      await pumpUntil(tester, find.text(testUserName), label: 'Search Results');

      expect(find.text(testUserName), findsWidgets);
      expect(find.text(testUserEmail), findsWidgets);

      // 5. Verify pagination/table content
      expect(find.text('OPD'), findsWidgets);
    });
  });
}
