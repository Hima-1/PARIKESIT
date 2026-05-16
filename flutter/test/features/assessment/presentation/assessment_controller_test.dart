import 'dart:async';

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
import 'package:parikesit/features/assessment/presentation/controller/assessment_controller.dart';

void main() {
  test(
    'saveWalidataCorrection sends Laravel payload and stores corrected assessment state',
    () async {
      final _FakeAssessmentRepository repository = _FakeAssessmentRepository()
        ..myPenilaians = <int, Penilaian>{
          383: const Penilaian(
            id: 17,
            formulirId: 12,
            indikatorId: 383,
            nilai: 2,
            catatan: 'Nilai awal OPD',
          ),
        };
      final ProviderContainer container = ProviderContainer(
        overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(assessmentFormControllerProvider(12).future);

      await container
          .read(assessmentFormControllerProvider(12).notifier)
          .saveWalidataCorrection(
            indicatorId: 383,
            score: 4,
            note: 'Perlu disesuaikan',
          );

      final AssessmentFormState state = container
          .read(assessmentFormControllerProvider(12))
          .requireValue;
      final Penilaian saved = state.draftsByIndikatorId[383]!;

      expect(repository.lastCorrectionAssessmentId, 17);
      expect(repository.lastCorrectionPayload, <String, dynamic>{
        'penilaian_id': 17,
        'nilai': 4.0,
        'catatan_koreksi': 'Perlu disesuaikan',
      });
      expect(saved.nilai, 2);
      expect(saved.nilaiDiupdate, 4);
      expect(saved.catatanKoreksi, 'Perlu disesuaikan');
    },
  );

  test(
    'saveDraftAssessment forwards selected evidence paths through submitPenilaian',
    () async {
      final _FakeAssessmentRepository repository = _FakeAssessmentRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(assessmentFormControllerProvider(12).future);

      final Penilaian saved = await container
          .read(assessmentFormControllerProvider(12).notifier)
          .saveDraftAssessment(
            indikatorId: 383,
            nilai: 2,
            catatan: 'tes',
            filePaths: const <String>[
              r'C:\temp\bukti-1.jpg',
              r'C:\temp\bukti-2.pdf',
            ],
          );

      expect(saved.id, 7);
      expect(repository.lastSubmittedFormulirId, 12);
      expect(repository.lastSubmittedIndikatorId, 383);
      expect(
        repository.lastSubmitPayload?['bukti_dukung_file_paths'],
        const <String>[r'C:\temp\bukti-1.jpg', r'C:\temp\bukti-2.pdf'],
      );
      expect(repository.uploadBuktiDukungCalled, isFalse);
    },
  );

  test(
    'concurrent draft saves merge into the latest assessment state',
    () async {
      final firstSave = Completer<void>();
      final secondSave = Completer<void>();
      final repository = _FakeAssessmentRepository()
        ..submitCompleters = <int, Completer<void>>{
          101: firstSave,
          202: secondSave,
        };
      final container = ProviderContainer(
        overrides: [assessmentRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(assessmentFormControllerProvider(12).future);
      final notifier = container.read(
        assessmentFormControllerProvider(12).notifier,
      );

      final firstFuture = notifier.saveDraftAssessment(
        indikatorId: 101,
        nilai: 3,
      );
      final secondFuture = notifier.saveDraftAssessment(
        indikatorId: 202,
        nilai: 4,
      );

      secondSave.complete();
      await secondFuture;
      firstSave.complete();
      await firstFuture;

      final drafts = container
          .read(assessmentFormControllerProvider(12))
          .requireValue
          .draftsByIndikatorId;

      expect(drafts.keys, containsAll(<int>[101, 202]));
      expect(drafts[101]?.nilai, 3);
      expect(drafts[202]?.nilai, 4);
    },
  );
}

class _FakeAssessmentRepository implements AssessmentRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  int? lastSubmittedFormulirId;
  int? lastSubmittedIndikatorId;
  Map<String, dynamic>? lastSubmitPayload;
  int? lastCorrectionAssessmentId;
  Map<String, dynamic>? lastCorrectionPayload;
  bool uploadBuktiDukungCalled = false;
  Map<int, Penilaian> myPenilaians = <int, Penilaian>{};
  Map<int, Completer<void>> submitCompleters = <int, Completer<void>>{};

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
  Future<AssessmentFormModel> getFormulir(int id) async => _formulir(id);

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
  Future<Penilaian> submitPenilaian(
    int formulirId,
    int indikatorId,
    Map<String, dynamic> data,
  ) async {
    final completer = submitCompleters[indikatorId];
    if (completer != null) {
      await completer.future;
    }

    lastSubmittedFormulirId = formulirId;
    lastSubmittedIndikatorId = indikatorId;
    lastSubmitPayload = Map<String, dynamic>.from(data);
    return Penilaian(
      id: 7,
      formulirId: formulirId,
      indikatorId: indikatorId,
      nilai: (data['nilai'] as num).toDouble(),
      catatan: data['catatan'] as String?,
      buktiDukung: const <String>['bukti-dukung/file.jpg'],
    );
  }

  @override
  Future<Penilaian> submitWalidataCorrection(Map<String, dynamic> data) async {
    final int assessmentId = (data['penilaian_id'] as num).toInt();
    lastCorrectionAssessmentId = assessmentId;
    lastCorrectionPayload = Map<String, dynamic>.from(data);
    return Penilaian(
      id: assessmentId,
      formulirId: 12,
      indikatorId: 383,
      nilai: 2,
      catatan: 'Nilai awal OPD',
      nilaiDiupdate: (data['nilai'] as num).toDouble(),
      catatanKoreksi: data['catatan_koreksi'] as String?,
    );
  }

  @override
  Future<Penilaian> submitAdminEvaluation(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId) async =>
      <AssessmentDisposisi>[];

  @override
  Future<AssessmentDisposisi> submitDisposisi(
    int formulirId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<BuktiDukung> uploadBuktiDukung(int penilaianId, String filePath) {
    uploadBuktiDukungCalled = true;
    throw UnimplementedError();
  }

  @override
  Future<List<OpdModel>> getOpdsForActivity(String activityId) async =>
      <OpdModel>[];

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
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => (_formulir(activityId), <int, Penilaian>{});

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getPublicIndicatorsForOpd(
    int activityId,
    int opdId,
  ) async => getIndicatorsForOpd(activityId, opdId);

  @override
  Future<Map<String, double?>> getOpdStats(int activityId, int opdId) async =>
      <String, double?>{'opd': null, 'walidata': null, 'admin': null};

  @override
  Future<Map<String, RoleScore>> getOpdDomainScores(
    int activityId,
    int opdId,
  ) async => <String, RoleScore>{};

  @override
  Future<(AssessmentFormModel, Map<int, Penilaian>)> getMyPenilaians(
    int formulirId,
  ) async => (_formulir(formulirId), myPenilaians);

  AssessmentFormModel _formulir(int id) {
    return AssessmentFormModel(
      id: '$id',
      title: 'Formulir',
      date: DateTime(2026, 3, 13),
      domains: const <DomainModel>[],
    );
  }
}
