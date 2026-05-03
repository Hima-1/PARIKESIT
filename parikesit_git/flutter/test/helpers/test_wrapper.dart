import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestWrapper extends StatelessWidget {
  const TestWrapper({
    super.key,
    required this.child,
    this.overrides = const [],
    this.appShellBuilder = _defaultTestAppShell,
  });

  final Widget child;
  final List<Object> overrides;
  final Widget Function(Widget child) appShellBuilder;

  static Widget _defaultTestAppShell(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides.cast(),
      child: appShellBuilder(child),
    );
  }
}
