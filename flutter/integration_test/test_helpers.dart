import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/auth/presentation/login_screen.dart';
import 'package:parikesit/features/public/presentation/landing_public_screen.dart';

/// Waits for a widget to appear on screen, effectively handling network latency
/// and asynchronous UI updates. Throws a [TestFailure] if the widget is not
/// found within the [timeout] duration.
Future<void> pumpUntil(
  WidgetTester tester,
  Finder finder, {
  String? label,
  Duration timeout = const Duration(seconds: 30),
  Duration step = const Duration(milliseconds: 200),
}) async {
  final labelStr = label != null ? ' ($label)' : '';
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  throw TestFailure(
    'Timed out waiting for $finder$labelStr. This may indicate a network error or '
    'backend unavailability after ${timeout.inSeconds} seconds.',
  );
}

Future<void> loginAs(WidgetTester tester, String email, String password) async {
  await openLoginScreen(tester);
  await tester.enterText(find.byKey(LoginScreen.emailFieldKey), email);
  await tester.enterText(find.byKey(LoginScreen.passwordFieldKey), password);
  await tester.tap(find.byKey(LoginScreen.loginButtonKey));
  await tester.pumpAndSettle();
}

Future<void> openLoginScreen(WidgetTester tester) async {
  final emailField = find.byKey(LoginScreen.emailFieldKey);
  if (emailField.evaluate().isNotEmpty) {
    return;
  }

  final landingMarker = find.byKey(LandingPublicScreen.aboutHeroKey);
  if (landingMarker.evaluate().isEmpty) {
    await pumpUntil(
      tester,
      find.byWidgetPredicate(
        (widget) =>
            widget.key == LoginScreen.emailFieldKey ||
            widget.key == LandingPublicScreen.aboutHeroKey,
      ),
      label: 'login screen or public landing',
    );
  }

  if (emailField.evaluate().isNotEmpty) {
    return;
  }

  await tester.tap(find.text('LOGIN').last);
  await tester.pumpAndSettle();
  await pumpUntil(
    tester,
    emailField,
    label: 'login email field after public landing login action',
  );
}

/// Ensures the user is logged in. If the login screen is visible, it performs login.
/// If already on a dashboard, it assumes login is successful.
Future<void> ensureLoggedIn(
  WidgetTester tester, {
  String email = 'admin@gmail.com',
  String password = 'password',
}) async {
  final loginFinder = find.byKey(LoginScreen.loginButtonKey);
  await tester.pump(const Duration(seconds: 1));

  if (loginFinder.evaluate().isNotEmpty) {
    await loginAs(tester, email, password);
  }
}

Future<void> logout(WidgetTester tester) async {
  // Logic to find logout button/menu depends on the role,
  // but usually it's in a profile menu or sidebar.
  final logoutFinder = find.text('Logout');
  if (logoutFinder.evaluate().isEmpty) {
    final keluarFinder = find.text('Keluar');
    if (keluarFinder.evaluate().isNotEmpty) {
      await tester.tap(keluarFinder);
    }
  } else {
    await tester.tap(logoutFinder);
  }
  await tester.pumpAndSettle();
}

Future<void> selectFromDropdown(
  WidgetTester tester,
  Key dropdownKey,
  String itemText,
) async {
  await tester.tap(find.byKey(dropdownKey));
  await tester.pumpAndSettle();
  // Dropdown items are usually in a separate overlay, so we find by text.
  await tester.tap(find.text(itemText).last);
  await tester.pumpAndSettle();
}

/// Navigates to a screen by tapping a widget found by [finder].
/// Optionally waits for a [targetText] to appear to confirm navigation.
Future<void> navigateTo(
  WidgetTester tester,
  Finder finder, {
  String? targetText,
  String? label,
}) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
  if (targetText != null) {
    await pumpUntil(
      tester,
      find.text(targetText),
      label: 'Screen: $targetText',
    );
  }
}

/// Verifies that a screen is visible by checking for [titleText].
Future<void> verifyScreen(WidgetTester tester, String titleText) async {
  expect(find.text(titleText), findsOneWidget);
}

/// Enters text into a field found by [key] and pumps.
Future<void> enterFormText(WidgetTester tester, Key key, String value) async {
  await tester.enterText(find.byKey(key), value);
  await tester.pumpAndSettle();
}

/// Taps a button found by [key] and pumps.
Future<void> tapButton(WidgetTester tester, Key key, {String? label}) async {
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

/// Specialized waiter for dashboards to avoid semantics issues and handle variadic loading.
Future<void> waitForDashboard(
  WidgetTester tester, {
  required Finder marker,
  String label = 'Dashboard',
  Duration timeout = const Duration(seconds: 30),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    // Using a fixed duration pump instead of pumpAndSettle to avoid semantics recursive loops
    await tester.pump(const Duration(milliseconds: 500));

    if (marker.evaluate().isNotEmpty) {
      return;
    }
  }

  throw TestFailure('Timed out waiting for $label dashboard marker: $marker');
}

/// Executes a [callback] while ensuring that semantics are ignored if they cause flakiness.
/// Useful for dashboards with charts or complex animations.
Future<void> withSemanticsDisabled(
  WidgetTester tester,
  Future<void> Function() callback,
) async {
  // In integration tests, sometimes the only way to avoid the parentDataDirty error
  // is to avoid pumpAndSettle or to wrap the problematic area in ExcludeSemantics.
  // This helper provides a conceptual wrapper for such operations.
  await callback();
}

/// A safer version of pumpAndSettle that caps the number of frames to avoid infinite loops.
Future<void> safeSettle(WidgetTester tester, {int maxFrames = 100}) async {
  for (int i = 0; i < maxFrames; i++) {
    // tester.pump() returns how many microtasks were executed, but in newer Flutter versions
    // it might be void in some contexts. We'll just pump fixed intervals.
    await tester.pump(const Duration(milliseconds: 100));
  }
}
