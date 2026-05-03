import 'package:flutter/material.dart';
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
import 'package:parikesit/features/assessment/presentation/opd_comparison_summary_screen.dart';

void main() {
  group('OpdComparisonSummaryScreen', () {
    testWidgets('renders summary rows from repository data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentRepositoryProvider.overrideWithValue(
              _SummaryAssessmentRepository(),
            ),
          ],
          child: MaterialApp(
            home: OpdComparisonSummaryScreen(
              activityId: '5',
              activity: AssessmentFormModel(
                id: '5',
                title: 'Formulir Evaluasi',
                date: DateTime(2026, 3, 13),
                domains: const <DomainModel>[],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.text('Bappeda'), findsOneWidget);
      expect(find.text('Dinkes'), findsOneWidget);
      expect(find.text('3.00'), findsOneWidget);
      expect(find.text('4.25'), findsOneWidget);
      expect(find.text('0.00'), findsNWidgets(3));
      expect(
        find.text('TODO: Implement comparison summary via API'),
        findsNothing,
      );
    });
  });
}

class _SummaryAssessmentRepository implements IAssessmentRepository {
  @override
  Future<AssessmentFormModel> addActivity(
    AssessmentFormModel activity, {
    bool useTemplate = true,
  }) async => activity;

  @override
  Future<void> addDomain(
    String activityId,
    String domainName,
    List<String> aspects,
  ) async {}

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteActivity(int formulirId) async {}

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[];

  Future<PaginatedResponse<AssessmentFormModel>> getActivitiesPage({
    int page = 1,
    int perPage = 15,
  }) async => PaginatedResponse<AssessmentFormModel>(
    data: await getActivities(),
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 0,
      from: null,
      to: null,
      path: '/formulir',
    ),
    links: const PaginationLinks(
      first: '/formulir?page=1',
      last: '/formulir?page=1',
    ),
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
      total: 0,
      from: null,
      to: null,
      path: '/penilaian-selesai',
    ),
    links: const PaginationLinks(
      first: '/penilaian-selesai?page=1',
      last: '/penilaian-selesai?page=1',
    ),
  );

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
  ) async => <ComparisonSummaryModel>[
    const ComparisonSummaryModel(
      opdId: 1,
      opdName: 'Bappeda',
      skorMandiri: 3,
      skorWalidata: 4.25,
      skorBps: 0,
    ),
    const ComparisonSummaryModel(
      opdId: 2,
      opdName: 'Dinkes',
      skorMandiri: 2,
      skorWalidata: 0,
      skorBps: 0,
    ),
  ];

  @override
  Future<AssessmentFormModel> getFormulir(int id) async =>
      throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => throw UnimplementedError();

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => throw UnimplementedError();

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

  Future<PaginatedResponse<OpdModel>> getOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async => PaginatedResponse<OpdModel>(
    data: await getOpdsForActivity(activityId),
    meta: PaginationMeta(
      currentPage: page,
      lastPage: 1,
      perPage: perPage,
      total: 0,
      from: null,
      to: null,
      path: '/penilaian-selesai/$activityId/opds',
    ),
    links: PaginationLinks(
      first: '/penilaian-selesai/$activityId/opds?page=1',
      last: '/penilaian-selesai/$activityId/opds?page=1',
    ),
  );

  Future<PaginatedResponse<OpdModel>> getPublicOpdsForActivityPage(
    String activityId, {
    int page = 1,
    int perPage = 10,
  }) async => getOpdsForActivityPage(activityId, page: page, perPage: perPage);

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitAdminEvaluation(
    int assessmentId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitWalidataCorrection(
    int assessmentId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async => throw UnimplementedError();
}
