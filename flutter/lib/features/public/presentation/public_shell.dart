import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/features/public/presentation/landing_public_screen.dart';
import 'package:parikesit/features/public/presentation/widgets/public_landing_bottom_nav.dart';

class PublicShell extends StatelessWidget {
  const PublicShell({super.key, required this.child, required this.location});

  final Widget child;
  final Uri location;

  @override
  Widget build(BuildContext context) {
    const List<PublicLandingBottomNavItem> items = [
      PublicLandingBottomNavItem(label: 'ABOUT', icon: LucideIcons.info),
      PublicLandingBottomNavItem(label: 'HASIL', icon: LucideIcons.barChart3),
      PublicLandingBottomNavItem(label: 'LOGIN', icon: LucideIcons.logIn),
    ];

    return Scaffold(
      bottomNavigationBar: KeyedSubtree(
        key: LandingPublicScreen.bottomNavKey,
        child: PublicLandingBottomNav(
          items: items,
          currentIndex: _currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(RouteConstants.publicLandingAbout);
                return;
              case 1:
                context.go(RouteConstants.publicLandingResults);
                return;
              case 2:
                context.go(RouteConstants.login);
                return;
            }
          },
        ),
      ),
      body: child,
    );
  }

  int get _currentIndex {
    if (location.path != RouteConstants.landing) {
      return 1;
    }

    return location.queryParameters['tab'] == PublicLandingTab.hasil.name
        ? 1
        : 0;
  }
}
