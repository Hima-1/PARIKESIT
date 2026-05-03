import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/pembinaan_repository.dart';
import '../../domain/pembinaan.dart';

class PembinaanController extends AsyncNotifier<List<Pembinaan>> {
  @override
  Future<List<Pembinaan>> build() async {
    final repository = ref.watch(pembinaanRepositoryProvider);
    return repository.getActivities();
  }

  Future<void> getPembinaans({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repository = ref.read(pembinaanRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.getActivities(
        search: search,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  Future<void> submitPembinaan(Map<String, dynamic> data) async {
    final repository = ref.read(pembinaanRepositoryProvider);
    try {
      await repository.createActivity(data);
      await getPembinaans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePembinaan(String id) async {
    final repository = ref.read(pembinaanRepositoryProvider);
    try {
      await repository.deleteActivity(id);
      await getPembinaans();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final pembinaanControllerProvider =
    AsyncNotifierProvider<PembinaanController, List<Pembinaan>>(
      PembinaanController.new,
    );
