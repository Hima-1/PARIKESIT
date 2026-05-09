import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_patterns.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';
import 'package:parikesit/features/assessment/presentation/widgets/completed_assessment_list_view.dart';
import 'package:parikesit/features/public/presentation/widgets/public_flow_widgets.dart';

part 'widgets/public_landing_tabs.dart';

enum PublicLandingTab { about, hasil }

class LandingPublicScreen extends ConsumerWidget {
  const LandingPublicScreen({super.key, this.tab = PublicLandingTab.about});

  final PublicLandingTab tab;

  static const Key aboutTabKey = Key('public_landing_about_tab');
  static const Key resultsTabKey = Key('public_landing_results_tab');
  static const Key aboutHeroKey = Key('public_landing_about_hero');
  static const Key bottomNavKey = Key('public_landing_bottom_nav');
  static const Key backgroundKey = Key('public_landing_background');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      key: LandingPublicScreen.backgroundKey,
      color: AppTheme.cream,
      child: KawungBackground(
        opacity: 0.025,
        child: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: PublicLandingTab.values.indexOf(tab),
            children: [
              KeyedSubtree(
                key: LandingPublicScreen.aboutTabKey,
                child: _PublicAboutTab(
                  onOpenResults: () =>
                      context.go(RouteConstants.publicLandingResults),
                  onOpenLogin: () => context.go(RouteConstants.login),
                ),
              ),
              const KeyedSubtree(
                key: LandingPublicScreen.resultsTabKey,
                child: _PublicResultsTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
