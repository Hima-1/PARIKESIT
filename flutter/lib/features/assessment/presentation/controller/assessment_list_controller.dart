import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';

class AssessmentListController
    extends AsyncNotifier<PaginatedResponse<AssessmentFormModel>> {
  static const int _perPage = 15;
  int _page = 1;

  @override
  Future<PaginatedResponse<AssessmentFormModel>> build() async {
    return _fetch();
  }

  Future<PaginatedResponse<AssessmentFormModel>> _reloadActivities(
    Future<void> Function(IAssessmentRepository repository) mutation,
  ) async {
    final IAssessmentRepository repository = ref.read(
      assessmentRepositoryProvider,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await mutation(repository);
      return _fetch(repository: repository);
    });

    return state.maybeWhen(
      data: (data) => data,
      orElse: () => const PaginatedResponse<AssessmentFormModel>(
        data: <AssessmentFormModel>[],
        meta: PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: _perPage,
          total: 0,
          path: '/formulir',
        ),
        links: PaginationLinks(first: '', last: ''),
      ),
    );
  }

  Future<void> addActivity(String name, {bool useTemplate = true}) async {
    final IAssessmentRepository repository = ref.read(
      assessmentRepositoryProvider,
    );
    final AssessmentFormModel activity = AssessmentFormModel(
      id: DateTime.now().toString(),
      title: name,
      date: DateTime.now(),
      domains: <DomainModel>[],
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.addActivity(activity, useTemplate: useTemplate);
      _page = 1;
      return _fetch(repository: repository);
    });
  }

  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {
    final IAssessmentRepository repository = ref.read(
      assessmentRepositoryProvider,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.addDomain(activityId, domainName, aspects);

      final AssessmentFormModel refreshed = await repository.getFormulir(
        int.parse(activityId),
      );
      final PaginatedResponse<AssessmentFormModel> page = await _fetch(
        repository: repository,
      );

      return page.copyWith(
        data: page.items
            .map((activity) => activity.id == activityId ? refreshed : activity)
            .toList(growable: false),
      );
    });
  }

  Future<void> updateActivity(String activityId, String name) async {
    final int formulirId = int.tryParse(activityId) ?? 0;
    if (formulirId <= 0) {
      throw ArgumentError.value(activityId, 'activityId');
    }

    await _reloadActivities((repository) async {
      await repository.updateActivity(formulirId, name);
    });
  }

  Future<void> deleteActivity(String activityId) async {
    final int formulirId = int.tryParse(activityId) ?? 0;
    if (formulirId <= 0) {
      throw ArgumentError.value(activityId, 'activityId');
    }

    await _reloadActivities((repository) async {
      await repository.deleteActivity(formulirId);
    });
  }

  Future<void> nextPage() async {
    final PaginatedResponse<AssessmentFormModel>? current = state.asData?.value;
    if (current != null && !current.hasNextPage) {
      return;
    }

    _page += 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }

    _page -= 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refreshActivities() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<PaginatedResponse<AssessmentFormModel>> _fetch({
    IAssessmentRepository? repository,
  }) {
    final IAssessmentRepository resolvedRepository =
        repository ?? ref.read(assessmentRepositoryProvider);
    return resolvedRepository.getActivitiesPage(page: _page, perPage: _perPage);
  }
}

final assessmentListControllerProvider =
    AsyncNotifierProvider<
      AssessmentListController,
      PaginatedResponse<AssessmentFormModel>
    >(AssessmentListController.new);

abstract class _BaseCompletedAssessmentListController
    extends AsyncNotifier<PaginatedResponse<AssessmentFormModel>> {
  CompletedAssessmentQuery _query = const CompletedAssessmentQuery();

  @override
  Future<PaginatedResponse<AssessmentFormModel>> build() async {
    return _fetch();
  }

  CompletedAssessmentQuery get query => _query;

  Future<void> setSearch(String search) async {
    await _updateQuery(_query.copyWith(search: search.trim(), page: 1));
  }

  Future<void> setSort(CompletedAssessmentSortField sort) async {
    await _updateQuery(_query.copyWith(sort: sort, page: 1));
  }

  Future<void> toggleSortDirection() async {
    final nextDirection =
        _query.direction == CompletedAssessmentSortDirection.asc
        ? CompletedAssessmentSortDirection.desc
        : CompletedAssessmentSortDirection.asc;

    await _updateQuery(_query.copyWith(direction: nextDirection, page: 1));
  }

  Future<void> nextPage() async {
    final current = state.asData?.value;
    if (current != null && !current.hasNextPage) {
      return;
    }

    await _updateQuery(_query.copyWith(page: _query.page + 1));
  }

  Future<void> previousPage() async {
    if (_query.page <= 1) {
      return;
    }

    await _updateQuery(_query.copyWith(page: _query.page - 1));
  }

  Future<void> refreshCompletedActivities() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> _updateQuery(CompletedAssessmentQuery query) async {
    _query = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<PaginatedResponse<AssessmentFormModel>> _fetch();
}

class CompletedAssessmentListController
    extends _BaseCompletedAssessmentListController {
  @override
  Future<PaginatedResponse<AssessmentFormModel>> _fetch() {
    return ref
        .read(assessmentRepositoryProvider)
        .getCompletedActivities(query: query);
  }
}

final completedActivitiesProvider =
    AsyncNotifierProvider<
      CompletedAssessmentListController,
      PaginatedResponse<AssessmentFormModel>
    >(CompletedAssessmentListController.new);

class PublicCompletedAssessmentListController
    extends _BaseCompletedAssessmentListController {
  @override
  Future<PaginatedResponse<AssessmentFormModel>> _fetch() {
    return ref
        .read(assessmentRepositoryProvider)
        .getPublicCompletedActivities(query: query);
  }
}

final publicCompletedActivitiesProvider =
    AsyncNotifierProvider<
      PublicCompletedAssessmentListController,
      PaginatedResponse<AssessmentFormModel>
    >(PublicCompletedAssessmentListController.new);
