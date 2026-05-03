import 'dart:io';

import 'package:flutter_riverpod/legacy.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';

import '../../../../core/utils/file_saver.dart';
import '../../../../core/utils/logger.dart';
import '../../../pembinaan/data/dokumentasi_repository.dart';
import '../../../pembinaan/data/pembinaan_repository.dart';
import '../../data/admin_user_repository.dart';
import '../../domain/admin_activity_query.dart';
import 'admin_dokumentasi_state.dart';

class AdminDokumentasiController extends StateNotifier<AdminDokumentasiState> {
  AdminDokumentasiController({
    required this.dokumentasiRepository,
    required this.pembinaanRepository,
  }) : super(const AdminDokumentasiState()) {
    refresh();
  }

  final IDokumentasiRepository dokumentasiRepository;
  final IPembinaanRepository pembinaanRepository;

  void setMode(DokumentasiMode mode) {
    state = state.copyWith(mode: mode, clearErrorMessage: true);
    final hasCachedData = mode == DokumentasiMode.kegiatan
        ? state.kegiatanPage != null
        : state.pembinaanPage != null;
    if (!hasCachedData) {
      refresh();
    }
  }

  void setSearch(String search) {
    if (state.mode == DokumentasiMode.kegiatan) {
      state = state.copyWith(
        kegiatanQuery: state.kegiatanQuery.copyWith(search: search, page: 1),
      );
      return;
    }

    state = state.copyWith(
      pembinaanQuery: state.pembinaanQuery.copyWith(search: search, page: 1),
    );
  }

  void setSort(AdminActivitySortField sort) {
    if (state.mode == DokumentasiMode.kegiatan) {
      state = state.copyWith(
        kegiatanQuery: state.kegiatanQuery.copyWith(sort: sort, page: 1),
      );
      return;
    }

    state = state.copyWith(
      pembinaanQuery: state.pembinaanQuery.copyWith(sort: sort, page: 1),
    );
  }

  void toggleSortDirection() {
    if (state.mode == DokumentasiMode.kegiatan) {
      state = state.copyWith(
        kegiatanQuery: state.kegiatanQuery.copyWith(
          direction: state.kegiatanQuery.direction == SortDirection.asc
              ? SortDirection.desc
              : SortDirection.asc,
          page: 1,
        ),
      );
      return;
    }

    state = state.copyWith(
      pembinaanQuery: state.pembinaanQuery.copyWith(
        direction: state.pembinaanQuery.direction == SortDirection.asc
            ? SortDirection.desc
            : SortDirection.asc,
        page: 1,
      ),
    );
  }

  Future<void> nextPage() async {
    if (!state.hasNextPage) return;

    if (state.mode == DokumentasiMode.kegiatan) {
      state = state.copyWith(
        kegiatanQuery: state.kegiatanQuery.copyWith(
          page: state.kegiatanQuery.page + 1,
        ),
      );
    } else {
      state = state.copyWith(
        pembinaanQuery: state.pembinaanQuery.copyWith(
          page: state.pembinaanQuery.page + 1,
        ),
      );
    }

    await refresh();
  }

  Future<void> previousPage() async {
    if (!state.hasPreviousPage) return;

    if (state.mode == DokumentasiMode.kegiatan) {
      state = state.copyWith(
        kegiatanQuery: state.kegiatanQuery.copyWith(
          page: state.kegiatanQuery.page - 1,
        ),
      );
    } else {
      state = state.copyWith(
        pembinaanQuery: state.pembinaanQuery.copyWith(
          page: state.pembinaanQuery.page - 1,
        ),
      );
    }

    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      if (state.mode == DokumentasiMode.kegiatan) {
        final kegiatan = await dokumentasiRepository.getActivitiesPage(
          search: state.kegiatanQuery.search,
          sort: state.kegiatanQuery.sort,
          direction: state.kegiatanQuery.direction,
          page: state.kegiatanQuery.page,
          perPage: state.kegiatanQuery.perPage,
        );

        state = state.copyWith(
          kegiatanPage: kegiatan,
          isLoading: false,
          clearErrorMessage: true,
        );
      } else {
        final pembinaan = await pembinaanRepository.getActivitiesPage(
          search: state.pembinaanQuery.search,
          sort: state.pembinaanQuery.sort,
          direction: state.pembinaanQuery.direction,
          page: state.pembinaanQuery.page,
          perPage: state.pembinaanQuery.perPage,
        );

        state = state.copyWith(
          pembinaanPage: pembinaan,
          isLoading: false,
          clearErrorMessage: true,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorMapper.toMessage(
          e,
          fallbackMessage: 'Gagal mengambil data. Silakan coba lagi.',
        ),
      );
    }
  }

  Future<void> createKegiatan(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      await dokumentasiRepository.createActivity(data);
      state = state.copyWith(
        mode: DokumentasiMode.kegiatan,
        kegiatanQuery: state.kegiatanQuery.copyWith(page: 1),
      );
      await refresh();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorMapper.toMessage(
          e,
          fallbackMessage: 'Gagal menambah kegiatan. Silakan coba lagi.',
        ),
      );
    }
  }

  Future<void> createPembinaan(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      await pembinaanRepository.createActivity(data);
      state = state.copyWith(
        mode: DokumentasiMode.pembinaan,
        pembinaanQuery: state.pembinaanQuery.copyWith(page: 1),
      );
      await refresh();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorMapper.toMessage(
          e,
          fallbackMessage: 'Gagal menambah pembinaan. Silakan coba lagi.',
        ),
      );
    }
  }

  Future<void> updateActivity({
    required String id,
    required Map<String, dynamic> data,
    required bool isPembinaan,
  }) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      if (isPembinaan) {
        await pembinaanRepository.updateActivity(id, data);
        state = state.copyWith(mode: DokumentasiMode.pembinaan);
      } else {
        await dokumentasiRepository.updateActivity(id, data);
        state = state.copyWith(mode: DokumentasiMode.kegiatan);
      }
      await refresh();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorMapper.toMessage(
          e,
          fallbackMessage: 'Gagal memperbarui data. Silakan coba lagi.',
        ),
      );
    }
  }

  Future<void> deleteActivity(String id, bool isPembinaan) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);
    try {
      if (isPembinaan) {
        final currentItems = state.pembinaanPage?.items.length ?? 0;
        await pembinaanRepository.deleteActivity(id);
        final nextPage = currentItems <= 1 && state.pembinaanQuery.page > 1
            ? state.pembinaanQuery.page - 1
            : state.pembinaanQuery.page;
        state = state.copyWith(
          mode: DokumentasiMode.pembinaan,
          pembinaanQuery: state.pembinaanQuery.copyWith(page: nextPage),
        );
      } else {
        final currentItems = state.kegiatanPage?.items.length ?? 0;
        await dokumentasiRepository.deleteActivity(id);
        final nextPage = currentItems <= 1 && state.kegiatanQuery.page > 1
            ? state.kegiatanQuery.page - 1
            : state.kegiatanQuery.page;
        state = state.copyWith(
          mode: DokumentasiMode.kegiatan,
          kegiatanQuery: state.kegiatanQuery.copyWith(page: nextPage),
        );
      }
      await refresh();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: AppErrorMapper.toMessage(
          e,
          fallbackMessage: 'Gagal menghapus data. Silakan coba lagi.',
        ),
      );
    }
  }

  Future<void> deletePembinaan(String id) async {
    return deleteActivity(id, true);
  }

  Future<void> deleteKegiatan(String id) async {
    return deleteActivity(id, false);
  }

  Future<void> downloadSingleFile(String storagePath, String fileName) async {
    state = state.copyWith(
      isDownloading: true,
      downloadStatusMessage: 'Menyiapkan unduhan $fileName...',
      clearDownloadProgress: true,
      clearLastDownloadedFilePath: true,
      clearErrorMessage: true,
    );
    try {
      AppLogger.debug(
        '[downloadSingleFile] start fileName=$fileName storagePath=$storagePath',
      );
      final response = state.mode == DokumentasiMode.pembinaan
          ? await pembinaanRepository.downloadPublicFile(storagePath)
          : await dokumentasiRepository.downloadPublicFile(storagePath);
      AppLogger.debug(
        '[downloadSingleFile] bytes received count=${response.length}',
      );
      final path = await FileSaver.saveToDownloads(response, fileName);
      state = state.copyWith(
        isDownloading: false,
        downloadProgress: 1,
        downloadStatusMessage: path == null
            ? 'Gagal menyimpan file $fileName'
            : 'File berhasil diunduh ke $path',
        lastDownloadedFilePath: path,
      );
    } catch (e, stack) {
      AppLogger.error('[downloadSingleFile] failed', e, stack);
      state = state.copyWith(
        isDownloading: false,
        clearDownloadProgress: true,
        downloadStatusMessage: 'Gagal mengunduh file $fileName: $e',
      );
    }
  }

  Future<void> downloadAll(String id, bool isPembinaan) async {
    state = state.copyWith(
      isDownloading: true,
      downloadProgress: 0,
      downloadStatusMessage: 'Menyiapkan unduhan lampiran...',
      clearLastDownloadedFilePath: true,
      clearErrorMessage: true,
    );
    try {
      final fallbackFileName = isPembinaan
          ? 'pembinaan_$id.zip'
          : 'dokumentasi_$id.zip';
      final target = await FileSaver.prepareDownloadTarget(fallbackFileName);

      if (target == null) {
        throw const FileSystemException(
          'Tidak dapat menyiapkan file unduhan sementara',
        );
      }

      AppLogger.debug(
        '[downloadAll] start id=$id isPembinaan=$isPembinaan fallbackFileName=$fallbackFileName tempPath=${target.tempFilePath}',
      );

      final downloadedTarget = isPembinaan
          ? await pembinaanRepository.downloadActivity(
              id,
              target: target,
              onReceiveProgress: _handleDownloadProgress,
            )
          : await dokumentasiRepository.downloadActivity(
              id,
              target: target,
              onReceiveProgress: _handleDownloadProgress,
            );

      final savedPath = await FileSaver.moveTempFileToPublicDownloads(
        downloadedTarget.tempFilePath,
        downloadedTarget.fileName,
      );

      if (savedPath == null) {
        throw const FileSystemException(
          'Tidak dapat memindahkan file ke folder Downloads publik',
        );
      }

      state = state.copyWith(
        isDownloading: false,
        downloadProgress: 1,
        downloadStatusMessage:
            'File ${downloadedTarget.fileName} berhasil diunduh ke $savedPath',
        lastDownloadedFilePath: savedPath,
      );
    } catch (e, stack) {
      AppLogger.error('[downloadAll] failed', e, stack);
      state = state.copyWith(
        isDownloading: false,
        clearDownloadProgress: true,
        downloadStatusMessage: 'Gagal mengunduh: $e',
      );
    }
  }

  void _handleDownloadProgress(int received, int total) {
    final progress = total > 0 ? received / total : null;
    final progressLabel = progress == null
        ? 'Mengunduh lampiran...'
        : 'Mengunduh lampiran ${(progress * 100).toStringAsFixed(0)}%';

    state = state.copyWith(
      isDownloading: true,
      downloadProgress: progress,
      downloadStatusMessage: progressLabel,
    );
  }
}

final adminDokumentasiControllerProvider =
    StateNotifierProvider<AdminDokumentasiController, AdminDokumentasiState>((
      ref,
    ) {
      return AdminDokumentasiController(
        dokumentasiRepository: ref.watch(dokumentasiRepositoryProvider),
        pembinaanRepository: ref.watch(pembinaanRepositoryProvider),
      );
    });
