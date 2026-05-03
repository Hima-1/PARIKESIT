import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/dashboard_repository_impl.dart';
import '../../../../domain/opd_dashboard_progress.dart';

class OpdDashboardController extends AsyncNotifier<List<OpdDashboardProgress>> {
  @override
  Future<List<OpdDashboardProgress>> build() async {
    return ref.read(dashboardRepositoryProvider).getOpdProgressData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(dashboardRepositoryProvider).getOpdProgressData(),
    );
  }
}

final opdDashboardControllerProvider =
    AsyncNotifierProvider<OpdDashboardController, List<OpdDashboardProgress>>(
      () {
        return OpdDashboardController();
      },
    );
