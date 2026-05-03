import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pembinaan/data/dokumentasi_repository.dart';
import '../../../pembinaan/data/pembinaan_repository.dart';
import '../../../pembinaan/domain/dokumentasi_kegiatan.dart';
import '../../../pembinaan/domain/pembinaan.dart';

enum DokumentasiDetailType { kegiatan, pembinaan }

final dokumentasiDetailProvider = FutureProvider.autoDispose
    .family<DokumentasiKegiatan, String>((ref, id) async {
      final repository = ref.watch(dokumentasiRepositoryProvider);
      return repository.getActivityById(id);
    });

final pembinaanDetailProvider = FutureProvider.autoDispose
    .family<Pembinaan, String>((ref, id) async {
      final repository = ref.watch(pembinaanRepositoryProvider);
      return repository.getActivityById(id);
    });
