import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/assessment/data/assessment_repository.dart';
import 'package:parikesit/features/assessment/domain/assessment_models.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';

typedef OpdListArgs = ({String activityId, bool isPublicReadOnly});

class OpdSelectionController
    extends AsyncNotifier<PaginatedResponse<OpdModel>> {
  OpdSelectionController(this.args);

  static const int _perPage = 10;
  final OpdListArgs args;
  int _page = 1;
  int _requestVersion = 0;

  @override
  Future<PaginatedResponse<OpdModel>> build() async {
    return _fetch();
  }

  Future<void> nextPage() async {
    final PaginatedResponse<OpdModel>? current = state.asData?.value;
    if (current != null && !current.hasNextPage) {
      return;
    }

    _page += 1;
    await _runLatest(_fetch);
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }

    _page -= 1;
    await _runLatest(_fetch);
  }

  Future<void> refreshOpds() async {
    await _runLatest(_fetch);
  }

  Future<PaginatedResponse<OpdModel>> _fetch() {
    final repository = ref.read(assessmentRepositoryProvider);
    if (args.isPublicReadOnly) {
      return repository.getPublicOpdsForActivityPage(
        args.activityId,
        page: _page,
        perPage: _perPage,
      );
    }

    return repository.getOpdsForActivityPage(
      args.activityId,
      page: _page,
      perPage: _perPage,
    );
  }

  Future<void> _runLatest(
    Future<PaginatedResponse<OpdModel>> Function() fetch,
  ) async {
    final requestVersion = ++_requestVersion;
    state = const AsyncLoading();
    final nextState = await AsyncValue.guard(fetch);
    if (requestVersion == _requestVersion) {
      state = nextState;
    }
  }
}

final opdListProvider =
    AsyncNotifierProvider.family<
      OpdSelectionController,
      PaginatedResponse<OpdModel>,
      OpdListArgs
    >(OpdSelectionController.new);

/// Lightweight provider: fetches only the 3 comparison scores for an OPD.
/// Uses the dedicated /penilaian-selesai/{formulir}/opd/{user}/stats endpoint
/// instead of re-loading the entire formulir structure.
final opdStatsProvider =
    FutureProvider.family<Map<String, double?>, ({int activityId, int opdId})>((
      ref,
      args,
    ) async {
      final repository = ref.watch(assessmentRepositoryProvider);
      return repository.getOpdStats(args.activityId, args.opdId);
    });

final opdDomainScoresProvider =
    FutureProvider.family<
      Map<String, RoleScore>,
      ({int activityId, int opdId})
    >((ref, args) async {
      final repository = ref.watch(assessmentRepositoryProvider);
      return repository.getOpdDomainScores(args.activityId, args.opdId);
    });
