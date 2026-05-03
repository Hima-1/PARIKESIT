import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/router/route_constants.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';
import 'package:parikesit/features/assessment/presentation/widgets/completed_assessment_list_view.dart';

class PenilaianSelesaiScreen extends ConsumerWidget {
  const PenilaianSelesaiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(userRoleProvider);
    final config = CompletedAssessmentListConfig.fromRole(role);
    final state = ref.watch(completedActivitiesProvider);
    final notifier = ref.read(completedActivitiesProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(config.screenTitle)),
      body: CompletedAssessmentListView(
        role: role,
        state: state,
        query: notifier.query,
        config: config,
        onSearchChanged: notifier.setSearch,
        onClearSearch: () => notifier.setSearch(''),
        onSortChanged: notifier.setSort,
        onToggleSortDirection: notifier.toggleSortDirection,
        onRefresh: notifier.refreshCompletedActivities,
        onPreviousPage: notifier.previousPage,
        onNextPage: notifier.nextPage,
        onActivityTap: (activity) {
          if (role == UserRole.walidata || role == UserRole.admin) {
            context.push(
              RouteConstants.assessmentOpdSelection.replaceFirst(
                ':activityId',
                activity.id,
              ),
              extra: activity,
            );
            return;
          }

          context.push(
            RouteConstants.assessmentReview.replaceFirst(
              ':activityId',
              activity.id,
            ),
            extra: activity,
          );
        },
      ),
    );
  }
}
