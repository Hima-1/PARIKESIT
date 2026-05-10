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
import 'package:parikesit/features/assessment/presentation/indicator_detail_screen.dart';
import 'package:parikesit/features/assessment/presentation/kegiatan_penilaian_screen.dart';

void main() {
  testWidgets(
    'indicator detail reads criteria from formulir data without preloaded indikator state',
    (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer(
        overrides: [
          assessmentRepositoryProvider.overrideWithValue(
            _IndicatorDetailRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: IndicatorDetailScreen(
              formulirId: 12,
              indicatorId: 30,
              indicatorName: 'Indikator 1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kriteria level pertama'), findsOneWidget);
      expect(find.text('Tingkat Kriteria'), findsOneWidget);
      expect(find.text('Indikator 1'), findsOneWidget);
      expect(find.text('30101'), findsOneWidget);
      expect(find.text('Domain A'), findsOneWidget);
      expect(find.text('Aspek A'), findsOneWidget);
      expect(find.text('bukti-tersimpan.pdf'), findsOneWidget);
      expect(
        find.text(
          'Memilih berkas baru akan mengganti bukti dukung yang sudah tersimpan.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'kegiatan penilaian shows explicit error when formulir id is invalid',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: KegiatanPenilaianScreen(formulirId: 0)),
        ),
      );

      expect(find.text('Data formulir tidak valid.'), findsOneWidget);
    },
  );
}

class _IndicatorDetailRepository implements AssessmentRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

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
  Future<void> deleteActivity(int formulirId) async {}

  @override
  Future<List<AssessmentFormModel>> getActivities() async =>
      <AssessmentFormModel>[];

  @override
  Future<PaginatedResponse<AssessmentFormModel>> getCompletedActivities({
    CompletedAssessmentQuery query = const CompletedAssessmentQuery(),
  }) async => const PaginatedResponse<AssessmentFormModel>(
    data: <AssessmentFormModel>[],
    meta: PaginationMeta(
      currentPage: 1,
      lastPage: 1,
      perPage: 15,
      total: 0,
      path: '/penilaian-selesai',
    ),
    links: PaginationLinks(
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
  ) async => <ComparisonSummaryModel>[];

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<AssessmentFormModel> getFormulir(int id) async => _buildFormulir(id);

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (_buildFormulir(activityId), <int, Penilaian>{});

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => (
    _buildFormulir(formulirId),
    <int, Penilaian>{
      30: const Penilaian(
        id: 5,
        formulirId: 12,
        indikatorId: 30,
        nilai: 1,
        buktiDukung: <String>['bukti-dukung/bukti-tersimpan.pdf'],
      ),
    },
  );

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async => <String, RoleScore>{};

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': null, 'walidata': null, 'admin': null};

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async =>
      <OpdModel>[];

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitAdminEvaluation(Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async => throw UnimplementedError();

  @override
  Future<Penilaian> submitWalidataCorrection(Map<String, dynamic> data) async =>
      throw UnimplementedError();

  @override
  Future<AssessmentFormModel> updateActivity(
    int formulirId,
    String name,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<BuktiDukung> uploadBuktiDukung(
    int penilaianId,
    String filePath,
  ) async {
    throw UnimplementedError();
  }

  AssessmentFormModel _buildFormulir(int id) {
    return AssessmentFormModel(
      id: '$id',
      title: 'Formulir Test',
      date: DateTime(2026, 3, 29),
      domains: <DomainModel>[
        DomainModel(
          id: '10',
          name: 'Domain A',
          date: DateTime(2026, 3, 29),
          aspects: <AspectModel>[
            const AspectModel(
              id: '20',
              name: 'Aspek A',
              indicators: <IndicatorModel>[
                IndicatorModel(
                  id: '30',
                  name: 'Indikator 1',
                  kodeIndikator: '30101',
                  bobotIndikator: 1,
                  level1Kriteria: 'Kriteria level pertama',
                  level2Kriteria: 'Kriteria level kedua',
                ),
              ],
            ),
          ],
          indicatorCount: 1,
        ),
      ],
    );
  }
}
