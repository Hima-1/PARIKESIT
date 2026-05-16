import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import '../../../../data/dashboard_repository.dart';
import '../../../../domain/opd_dashboard_progress.dart';

class OpdDashboardController
    extends AsyncNotifier<PaginatedResponse<OpdDashboardProgress>> {
  static const int _perPage = 10;
  int _page = 1;
  int _requestVersion = 0;

  @override
  Future<PaginatedResponse<OpdDashboardProgress>> build() async {
    return _fetch();
  }

  Future<void> nextPage() async {
    final current = state.asData?.value;
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

  Future<void> refresh() async {
    await _runLatest(_fetch);
  }

  Future<PaginatedResponse<OpdDashboardProgress>> _fetch() {
    return ref
        .read(dashboardRepositoryProvider)
        .getOpdProgressPage(page: _page, perPage: _perPage);
  }

  Future<void> _runLatest(
    Future<PaginatedResponse<OpdDashboardProgress>> Function() fetch,
  ) async {
    final requestVersion = ++_requestVersion;
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(fetch);
    if (requestVersion == _requestVersion) {
      state = nextState;
    }
  }
}

final opdDashboardControllerProvider =
    AsyncNotifierProvider<
      OpdDashboardController,
      PaginatedResponse<OpdDashboardProgress>
    >(() {
      return OpdDashboardController();
    });
