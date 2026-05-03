import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_empty_state.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';

import '../../../core/router/route_constants.dart';
import 'controller/assessment_list_controller.dart';
import 'widgets/assessment_widgets.dart';

final activityDetailsProvider =
    FutureProvider.family<AssessmentFormModel, String>((ref, activityId) async {
      return ref
          .read(assessmentRepositoryProvider)
          .getFormulir(int.parse(activityId));
    });

class ActivityDetailsScreen extends ConsumerWidget {
  const ActivityDetailsScreen({super.key, required this.activityId});

  final String activityId;

  Future<void> _handleRefresh(WidgetRef ref, {required bool loadDetail}) async {
    final listFuture = ref.refresh(assessmentListControllerProvider.future);
    await listFuture;
    if (loadDetail) {
      final detailFuture = ref.refresh(
        activityDetailsProvider(activityId).future,
      );
      await detailFuture;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PaginatedResponse<AssessmentFormModel>> activitiesAsync =
        ref.watch(assessmentListControllerProvider);
    final AssessmentFormModel? cachedActivity = activitiesAsync.maybeWhen(
      data: (page) => _findActivity(page.items),
      orElse: () => null,
    );
    final bool needsDetailLoad =
        cachedActivity == null || cachedActivity.domains.isEmpty;
    final AsyncValue<AssessmentFormModel>? detailAsync = needsDetailLoad
        ? ref.watch(activityDetailsProvider(activityId))
        : null;

    final String title = activitiesAsync.maybeWhen(
      data: (PaginatedResponse<AssessmentFormModel> page) {
        final AssessmentFormModel? activity = _findActivity(page.items);
        return activity?.title ?? 'Detail Kegiatan';
      },
      orElse: () => 'Detail Kegiatan',
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.shellSurfaceSoft,
        surfaceTintColor: AppTheme.shellSurfaceSoft,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppTheme.sogan,
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.sogan,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref, loadDetail: needsDetailLoad),
        child: activitiesAsync.when(
          loading: () => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 240),
              Center(child: CircularProgressIndicator()),
            ],
          ),
          error: (Object error, StackTrace stackTrace) =>
              _buildScrollableMessage('Gagal memuat data'),
          data: (PaginatedResponse<AssessmentFormModel> page) {
            final AssessmentFormModel? activity = _findActivity(page.items);
            if (activity == null && detailAsync == null) {
              return _buildScrollableMessage('Gagal memuat formulir.');
            }

            if (detailAsync != null) {
              return detailAsync.when(
                loading: () => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 240),
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
                error: (Object error, StackTrace stackTrace) =>
                    _buildScrollableMessage('Gagal memuat detail formulir.'),
                data: (AssessmentFormModel activity) =>
                    _buildDomainList(context, activity),
              );
            }

            return _buildDomainList(context, activity!);
          },
        ),
      ),
    );
  }

  Widget _buildScrollableMessage(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 240),
        Center(child: Text(message)),
      ],
    );
  }

  Widget _buildDomainList(BuildContext context, AssessmentFormModel activity) {
    final Widget addDomainButton = Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: EthnoButton(
        onPressed: () => context.push(
          RouteConstants.assessmentTambahDomain.replaceFirst(':id', activityId),
        ),
        style: EthnoButtonStyle.primary,
        icon: Icons.add,
        label: 'Tambah Domain',
        isFullWidth: true,
      ),
    );

    if (activity.domains.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          addDomainButton,
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 6, 16, 16),
            child: AppEmptyState(
              icon: Icons.domain_disabled_outlined,
              title: 'Belum ada domain di formulir ini.',
              message: 'Tambahkan domain untuk mulai menyusun formulir.',
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        addDomainButton,
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: activity.domains.length,
            itemBuilder: (BuildContext context, int index) {
              final DomainModel domain = activity.domains[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: DomainSummaryCard(domain: domain),
              );
            },
          ),
        ),
      ],
    );
  }

  AssessmentFormModel? _findActivity(List<AssessmentFormModel> activities) {
    for (final AssessmentFormModel activity in activities) {
      if (activity.id == activityId) {
        return activity;
      }
    }
    return null;
  }
}
