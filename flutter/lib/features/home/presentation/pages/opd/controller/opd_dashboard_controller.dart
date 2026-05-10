import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import '../../../../data/dashboard_repository.dart';
import '../../../../domain/opd_dashboard_progress.dart';

class OpdDashboardController
    extends AsyncNotifier<PaginatedResponse<OpdDashboardProgress>> {
  static const int _perPage = 10;
  int _page = 1;

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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> previousPage() async {
    if (_page <= 1) {
      return;
    }

    _page -= 1;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<PaginatedResponse<OpdDashboardProgress>> _fetch() {
    return ref
        .read(dashboardRepositoryProvider)
        .getOpdProgressPage(page: _page, perPage: _perPage);
  }
}

final opdDashboardControllerProvider =
    AsyncNotifierProvider<
      OpdDashboardController,
      PaginatedResponse<OpdDashboardProgress>
    >(() {
      return OpdDashboardController();
    });
