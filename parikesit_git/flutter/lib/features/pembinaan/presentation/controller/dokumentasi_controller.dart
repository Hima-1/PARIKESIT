import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/dokumentasi_repository.dart';
import '../../domain/dokumentasi_kegiatan.dart';

class DokumentasiController extends AsyncNotifier<List<DokumentasiKegiatan>> {
  @override
  Future<List<DokumentasiKegiatan>> build() async {
    final repository = ref.watch(dokumentasiRepositoryProvider);
    return repository.getActivities();
  }

  Future<void> getDokumentasis({
    String? search,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repository = ref.read(dokumentasiRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.getActivities(
        search: search,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  Future<void> submitDokumentasi(Map<String, dynamic> data) async {
    final repository = ref.read(dokumentasiRepositoryProvider);
    try {
      await repository.createActivity(data);
      await getDokumentasis();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteDokumentasi(String id) async {
    final repository = ref.read(dokumentasiRepositoryProvider);
    try {
      await repository.deleteActivity(id);
      await getDokumentasis();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final dokumentasiControllerProvider =
    AsyncNotifierProvider<DokumentasiController, List<DokumentasiKegiatan>>(
      DokumentasiController.new,
    );
