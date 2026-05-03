import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/dashboard_repository_impl.dart';
import '../../../../domain/walidata_dashboard_progress.dart';

class WalidataDashboardController
    extends AsyncNotifier<List<WalidataDashboardProgress>> {
  @override
  Future<List<WalidataDashboardProgress>> build() async {
    return ref.read(dashboardRepositoryProvider).getWalidataProgressData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(dashboardRepositoryProvider).getWalidataProgressData(),
    );
  }
}

final walidataDashboardControllerProvider =
    AsyncNotifierProvider<
      WalidataDashboardController,
      List<WalidataDashboardProgress>
    >(() {
      return WalidataDashboardController();
    });
