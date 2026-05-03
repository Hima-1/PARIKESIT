import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'app_bottom_nav.dart';
import 'app_header.dart';
import 'app_sidebar.dart';
import 'ethno_patterns.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, required this.child});

  final Widget child;

  Widget _withShellTheme(BuildContext context, Widget child) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        cardTheme: baseTheme.cardTheme.copyWith(
          color: AppTheme.shellSurface,
          shadowColor: AppTheme.sogan.withValues(alpha: 0.08),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final themedChild = _withShellTheme(context, child);

    if (isMobile) {
      return KawungBackground(
        child: Scaffold(
          appBar: const AppHeader(),
          body: SafeArea(child: themedChild),
          bottomNavigationBar: const AppBottomNav(),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: KawungBackground(
              child: Column(
                children: [
                  const AppHeader(),
                  Expanded(
                    child: Padding(
                      padding: AppSpacing.pAll24,
                      child: themedChild,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
