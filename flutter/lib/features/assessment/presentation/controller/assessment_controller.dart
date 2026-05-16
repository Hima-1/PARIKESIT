import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_indikator.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/bukti_dukung.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

part 'assessment_controller.freezed.dart';

@freezed
abstract class AssessmentFormState with _$AssessmentFormState {
  const factory AssessmentFormState({
    required int formulirId,
    AssessmentFormModel? formulir,
    String? selectedDomainId,
    String? selectedAspekId,
    @Default(<AssessmentIndikator>[]) List<AssessmentIndikator> indikators,
    @Default(<int, Penilaian>{}) Map<int, Penilaian> draftsByIndikatorId,
    @Default(<int, List<BuktiDukung>>{})
    Map<int, List<BuktiDukung>> buktiDukungByPenilaianId,
  }) = _AssessmentFormState;
}

class AssessmentFormController extends AsyncNotifier<AssessmentFormState> {
  AssessmentFormController(this._formulirId);

  final int _formulirId;
  int _loadRequestVersion = 0;

  @override
  Future<AssessmentFormState> build() async {
    final (
      AssessmentFormModel formulir,
      Map<int, Penilaian> existing,
    ) = await ref
        .read(assessmentRepositoryProvider)
        .getMyPenilaians(_formulirId)
        .onError((error, stackTrace) async {
          final AssessmentFormModel f = await ref
              .read(assessmentRepositoryProvider)
              .getFormulir(_formulirId);
          return (f, const <int, Penilaian>{});
        });

    return AssessmentFormState(
      formulirId: _formulirId,
      formulir: formulir,
      draftsByIndikatorId: existing,
    );
  }

  Future<void> loadIndikatorsForDomainOrAspek({
    required String domainId,
    String? aspekId,
    bool forceRepository = false,
  }) async {
    final AssessmentFormState previous =
        state.value ?? AssessmentFormState(formulirId: _formulirId);
    final requestVersion = ++_loadRequestVersion;

    state = const AsyncValue<AssessmentFormState>.loading();
    final nextState = await AsyncValue.guard(() async {
      final List<AssessmentIndikator> indikators = await _getIndikators(
        domainId: domainId,
        aspekId: aspekId,
        forceRepository: forceRepository,
      );

      return previous.copyWith(
        selectedDomainId: domainId,
        selectedAspekId: aspekId,
        indikators: indikators,
      );
    });
    if (requestVersion == _loadRequestVersion) {
      state = nextState;
    }
  }

  Future<void> loadIndicatorsForOpd(int opdId) async {
    final AssessmentFormState previous =
        state.value ?? AssessmentFormState(formulirId: _formulirId);
    final requestVersion = ++_loadRequestVersion;

    // Fetch first without setting loading state — this avoids a rapid double
    // rebuild (loading → data) on a heavy widget tree that can cause ANR.
    try {
      final (
        AssessmentFormModel formulir,
        Map<int, Penilaian> assessments,
      ) = await ref
          .read(assessmentRepositoryProvider)
          .getIndicatorsForOpd(_formulirId, opdId);

      if (requestVersion == _loadRequestVersion) {
        state = AsyncValue<AssessmentFormState>.data(
          previous.copyWith(
            formulir: formulir,
            draftsByIndikatorId: assessments,
          ),
        );
      }
    } catch (error, stackTrace) {
      if (requestVersion == _loadRequestVersion) {
        state = AsyncValue<AssessmentFormState>.error(error, stackTrace);
      }
    }
  }

  Future<Penilaian> saveDraftAssessment({
    required int indikatorId,
    required double nilai,
    String? catatan,
    List<String> filePaths = const <String>[],
  }) async {
    final AssessmentFormState previous =
        state.value ?? AssessmentFormState(formulirId: _formulirId);
    final Penilaian? existing = previous.draftsByIndikatorId[indikatorId];

    // Protection: Prevent OPD save if Walidata has corrected or Admin has evaluated
    if (existing != null) {
      final bool isLocked =
          (existing.nilaiDiupdate != null && existing.nilaiDiupdate! > 0) ||
          (existing.evaluasi != null && existing.evaluasi!.isNotEmpty);
      if (isLocked) {
        throw StateError(
          'Penilaian sudah dikunci oleh BPS dan tidak dapat diubah.',
        );
      }
    }

    try {
      final sanitizedNote = InputSanitizer.nullableTrimmed(
        catatan ?? '',
        maxLength: 2000,
      );
      final Map<String, dynamic> payload = <String, dynamic>{'nilai': nilai};
      if (sanitizedNote != null) {
        payload['catatan'] = sanitizedNote;
      }
      if (filePaths.isNotEmpty) {
        payload['bukti_dukung_file_paths'] = filePaths;
      }

      final Penilaian savedDraft = await ref
          .read(assessmentRepositoryProvider)
          .submitPenilaian(_formulirId, indikatorId, payload);

      final AssessmentFormState latest =
          state.value ?? AssessmentFormState(formulirId: _formulirId);
      final Map<int, Penilaian> nextDrafts = Map<int, Penilaian>.from(
        latest.draftsByIndikatorId,
      )..[savedDraft.indikatorId] = savedDraft;

      state = AsyncValue<AssessmentFormState>.data(
        latest.copyWith(draftsByIndikatorId: nextDrafts),
      );
      return savedDraft;
    } catch (error, stackTrace) {
      state = AsyncValue<AssessmentFormState>.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> saveWalidataCorrection({
    required int indicatorId,
    required double score,
    String? note,
  }) async {
    final AssessmentFormState previous =
        state.value ?? AssessmentFormState(formulirId: _formulirId);
    final Penilaian? existing = previous.draftsByIndikatorId[indicatorId];

    if (existing == null) {
      throw StateError(
        'Penilaian untuk indikator ini belum diisi oleh OPD/Walidata.',
      );
    }

    // Protection: Prevent Walidata save if Admin has already evaluated
    if (existing.evaluasi != null && existing.evaluasi!.isNotEmpty) {
      throw StateError(
        'Evaluasi sudah final oleh Admin BPS dan tidak dapat diubah.',
      );
    }

    try {
      final Map<String, dynamic> payload = <String, dynamic>{
        'penilaian_id': existing.id,
        'nilai': score,
        'catatan_koreksi':
            InputSanitizer.nullableTrimmed(note ?? '', maxLength: 2000) ?? '',
      };

      final Penilaian corrected = await ref
          .read(assessmentRepositoryProvider)
          .submitWalidataCorrection(payload);

      final AssessmentFormState latest =
          state.value ?? AssessmentFormState(formulirId: _formulirId);
      final Map<int, Penilaian> nextDrafts = Map<int, Penilaian>.from(
        latest.draftsByIndikatorId,
      )..[corrected.indikatorId] = corrected;

      state = AsyncValue<AssessmentFormState>.data(
        latest.copyWith(draftsByIndikatorId: nextDrafts),
      );
    } catch (error, stackTrace) {
      state = AsyncValue<AssessmentFormState>.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> saveAdminEvaluation({
    required int indicatorId,
    required double score,
    String? note,
  }) async {
    final AssessmentFormState previous =
        state.value ?? AssessmentFormState(formulirId: _formulirId);
    final Penilaian? existing = previous.draftsByIndikatorId[indicatorId];

    if (existing == null) {
      throw StateError(
        'Penilaian untuk indikator ini belum diisi oleh OPD/Walidata.',
      );
    }

    if (existing.nilaiDiupdate == null) {
      throw StateError(
        'Walidata belum mengisi penilaian. Anda tidak dapat melakukan evaluasi.',
      );
    }

    try {
      final Map<String, dynamic> payload = <String, dynamic>{
        'penilaian_id': existing.id,
        'nilai_evaluasi': score,
        'evaluasi':
            InputSanitizer.nullableTrimmed(note ?? '', maxLength: 2000) ?? '',
      };

      final Penilaian evaluated = await ref
          .read(assessmentRepositoryProvider)
          .submitAdminEvaluation(payload);

      final AssessmentFormState latest =
          state.value ?? AssessmentFormState(formulirId: _formulirId);
      final Map<int, Penilaian> nextDrafts = Map<int, Penilaian>.from(
        latest.draftsByIndikatorId,
      )..[evaluated.indikatorId] = evaluated;

      state = AsyncValue<AssessmentFormState>.data(
        latest.copyWith(draftsByIndikatorId: nextDrafts),
      );
    } catch (error, stackTrace) {
      state = AsyncValue<AssessmentFormState>.error(error, stackTrace);
      rethrow;
    }
  }

  Future<BuktiDukung> uploadBuktiDukung({
    required int penilaianId,
    required String filePath,
  }) async {
    try {
      final BuktiDukung uploaded = await ref
          .read(assessmentRepositoryProvider)
          .uploadBuktiDukung(penilaianId, filePath);

      final AssessmentFormState latest =
          state.value ?? AssessmentFormState(formulirId: _formulirId);
      final Map<int, List<BuktiDukung>> nextBuktiByPenilaian =
          Map<int, List<BuktiDukung>>.from(latest.buktiDukungByPenilaianId);
      final List<BuktiDukung> nextBukti = List<BuktiDukung>.from(
        nextBuktiByPenilaian[penilaianId] ?? const <BuktiDukung>[],
      )..add(uploaded);
      nextBuktiByPenilaian[penilaianId] = nextBukti;

      state = AsyncValue<AssessmentFormState>.data(
        latest.copyWith(buktiDukungByPenilaianId: nextBuktiByPenilaian),
      );
      return uploaded;
    } catch (error, stackTrace) {
      state = AsyncValue<AssessmentFormState>.error(error, stackTrace);
      rethrow;
    }
  }

  Future<List<AssessmentIndikator>> _getIndikators({
    required String domainId,
    String? aspekId,
    required bool forceRepository,
  }) async {
    return _readIndikatorsFromRepository(domainId: domainId, aspekId: aspekId);
  }

  Future<List<AssessmentIndikator>> _readIndikatorsFromRepository({
    required String domainId,
    String? aspekId,
  }) async {
    final AssessmentFormState previous =
        state.value ?? AssessmentFormState(formulirId: _formulirId);
    final AssessmentFormModel? formulir = previous.formulir;

    if (formulir == null) {
      return const <AssessmentIndikator>[];
    }

    final List<AssessmentIndikator> result = <AssessmentIndikator>[];

    final DomainModel? domain = formulir.domains
        .where((d) => d.id == domainId)
        .firstOrNull;

    if (domain == null) return const <AssessmentIndikator>[];

    if (aspekId != null) {
      final AspectModel? aspek = domain.aspects
          .where((a) => a.id == aspekId)
          .firstOrNull;
      if (aspek != null) {
        for (final indikator in aspek.indicators) {
          result.add(
            indikator.toAssessmentIndikator(
              aspectId: aspek.id,
              aspectName: aspek.name,
              domainName: domain.name,
            ),
          );
        }
      }
    } else {
      for (final aspek in domain.aspects) {
        for (final indikator in aspek.indicators) {
          result.add(
            indikator.toAssessmentIndikator(
              aspectId: aspek.id,
              aspectName: aspek.name,
              domainName: domain.name,
            ),
          );
        }
      }
    }

    return result;
  }
}

final assessmentFormControllerProvider =
    AsyncNotifierProvider.family<
      AssessmentFormController,
      AssessmentFormState,
      int
    >(AssessmentFormController.new);

final publicAssessmentDetailProvider =
    FutureProvider.family<AssessmentFormState, ({int activityId, int opdId})>((
      ref,
      args,
    ) async {
      final (
        AssessmentFormModel formulir,
        Map<int, Penilaian> assessments,
      ) = await ref
          .read(assessmentRepositoryProvider)
          .getPublicIndicatorsForOpd(args.activityId, args.opdId);

      return AssessmentFormState(
        formulirId: args.activityId,
        formulir: formulir,
        draftsByIndikatorId: assessments,
      );
    });
