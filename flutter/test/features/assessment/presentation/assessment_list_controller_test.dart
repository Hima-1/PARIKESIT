import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_disposisi.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/comparison_summary_model.dart';
import 'package:parikesit/features/assessment/domain/completed_assessment_query.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';
import 'package:parikesit/features/assessment/presentation/controller/assessment_list_controller.dart';

void main() {
  test(
    'addActivity keeps created detail with template domains in controller state',
    () async {
      final _FakeAssessmentRepository repository = _FakeAssessmentRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(assessmentListControllerProvider.future);

      await container
          .read(assessmentListControllerProvider.notifier)
          .addActivity('Formulir Template', useTemplate: true);

      final AsyncValue<PaginatedResponse<AssessmentFormModel>> state = container
          .read(assessmentListControllerProvider);

      expect(state.hasValue, isTrue);
      final List<AssessmentFormModel> activities = state.requireValue.items;
      expect(activities, hasLength(1));
      expect(activities.first.title, 'Formulir Template');
      expect(activities.first.domains, isNotEmpty);
      expect(activities.first.domains.first.name, 'Domain Template');
    },
  );

  test('updateActivity refreshes list with renamed formulir', () async {
    final _FakeAssessmentRepository repository = _FakeAssessmentRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(assessmentListControllerProvider.future);
    await container
        .read(assessmentListControllerProvider.notifier)
        .updateActivity('8', 'Formulir Baru');

    final AsyncValue<PaginatedResponse<AssessmentFormModel>> state = container
        .read(assessmentListControllerProvider);

    expect(state.hasValue, isTrue);
    expect(state.requireValue.items.first.title, 'Formulir Baru');
    expect(repository.lastUpdatedId, 8);
    expect(repository.lastUpdatedName, 'Formulir Baru');
  });

  test('deleteActivity removes formulir from refreshed list', () async {
    final _FakeAssessmentRepository repository = _FakeAssessmentRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(assessmentListControllerProvider.future);
    await container
        .read(assessmentListControllerProvider.notifier)
        .deleteActivity('8');

    final AsyncValue<PaginatedResponse<AssessmentFormModel>> state = container
        .read(assessmentListControllerProvider);

    expect(state.hasValue, isTrue);
    expect(state.requireValue.items, isEmpty);
    expect(repository.lastDeletedId, 8);
  });

  test('nextPage and previousPage fetch paginated formulir pages', () async {
    final _PagedAssessmentRepository repository = _PagedAssessmentRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(assessmentListControllerProvider.future);

    expect(
      container.read(assessmentListControllerProvider).requireValue.items,
      hasLength(15),
    );
    expect(repository.requestedPages, <int>[1]);

    await container.read(assessmentListControllerProvider.notifier).nextPage();

    var page = container.read(assessmentListControllerProvider).requireValue;
    expect(page.meta.currentPage, 2);
    expect(page.items.single.title, 'Formulir 16');

    await container
        .read(assessmentListControllerProvider.notifier)
        .previousPage();

    page = container.read(assessmentListControllerProvider).requireValue;
    expect(page.meta.currentPage, 1);
    expect(page.items.first.title, 'Formulir 1');
    expect(repository.requestedPages, <int>[1, 2, 1]);
  });
}

class _PagedAssessmentRepository extends AssessmentRepository {
  _PagedAssessmentRepository() : super(Dio());

  final List<int> requestedPages = <int>[];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async {
    requestedPages.add(page);
    final allItems = List<AssessmentFormModel>.generate(
      16,
      (index) => AssessmentFormModel(
        id: '${index + 1}',
        title: 'Formulir ${index + 1}',
        date: DateTime(2026, 3, 13),
        domains: const <DomainModel>[],
      ),
    );
    final start = (page - 1) * perPage;
    final items = allItems.skip(start).take(perPage).toList();

    return PaginatedResponse<AssessmentFormModel>(
      data: items,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 2,
        perPage: perPage,
        total: allItems.length,
        from: items.isEmpty ? null : start + 1,
        to: items.isEmpty ? null : start + items.length,
        path: '/formulir',
      ),
      links: const PaginationLinks(
        first: '/formulir?page=1',
        last: '/formulir?page=2',
      ),
    );
  }
}

class _FakeAssessmentRepository implements AssessmentRepository {
  _FakeAssessmentRepository()
    : _activities = <AssessmentFormModel>[
        AssessmentFormModel(
          id: '8',
          title: 'Formulir Template',
          date: DateTime(2026, 3, 13),
          domains: const <DomainModel>[],
        ),
      ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  final List<AssessmentFormModel> _activities;
  @override
  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  }) async {
    final AssessmentFormModel created = AssessmentFormModel(
      id: '8',
      title: activity.title,
      date: activity.date,
      domains: <DomainModel>[
        DomainModel(
          id: '101',
          name: 'Domain Template',
          date: DateTime(2026, 3, 13),
          aspects: const <AspectModel>[],
          indicatorCount: 0,
        ),
      ],
    );
    if (_activities.length == 1 &&
        _activities.first.id == '8' &&
        _activities.first.title == 'Formulir Template') {
      _activities[0] = created;
    } else {
      _activities.add(created);
    }
    return created;
  }

  int? lastUpdatedId;
  String? lastUpdatedName;
  int? lastDeletedId;

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    lastUpdatedId = formulirId;
    lastUpdatedName = name;
    final int index = _activities.indexWhere(
      (item) => item.id == formulirId.toString(),
    );
    final AssessmentFormModel updated = _activities[index].copyWith(
      title: name,
    );
    _activities[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteActivity(int formulirId) async {
    lastDeletedId = formulirId;
    _activities.removeWhere((item) => item.id == formulirId.toString());
  }

  @override
  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {}

  @override
  Future<AssessmentFormModel> getFormulir(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<AssessmentFormModel>> getActivities() async {
    return List<AssessmentFormModel>.unmodifiable(_activities);
  }

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: _activities.length,
      from: _activities.isEmpty ? null : 1,
      to: _activities.isEmpty ? null : _activities.length,
      path: '',
    ),
    links: const PaginationLinks(first: '', last: ''),
  );

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: query.page,
      lastPage: 1,
      perPage: query.perPage,
      total: _activities.length,
      from: _activities.isEmpty ? null : 1,
      to: _activities.isEmpty ? null : _activities.length,
      path: '/penilaian-selesai',
    ),
    links: const PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getPublicCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => getCompletedActivities(query: query);

  @override
  Future<List<OpdModel>> getPublicOpdsForActivity(String activityId) async =>
      getOpdsForActivity(activityId);

  @override
  Future<List<ComparisonSummaryModel>> getComparisonSummary(
    String activityId,
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': null, 'walidata': null, 'admin': null};

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async => <String, RoleScore>{};

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async =>
      <OpdModel>[];

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Penilaian> submitAdminEvaluation(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Penilaian> submitWalidataCorrection(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<BuktiDukung> uploadBuktiDukung(int penilaianId, String filePath) {
    throw UnimplementedError();
  }
}
