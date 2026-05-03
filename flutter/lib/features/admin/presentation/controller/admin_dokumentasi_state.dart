import 'package:parikesit/core/network/paginated_response.dart';

import '../../../pembinaan/domain/dokumentasi_kegiatan.dart';
import '../../../pembinaan/domain/pembinaan.dart';
import '../../domain/admin_activity_query.dart';

enum DokumentasiMode { kegiatan, pembinaan }

class AdminDokumentasiState {
  const AdminDokumentasiState({
    this.mode = DokumentasiMode.kegiatan,
    this.kegiatanQuery = const AdminActivityQuery(),
    this.pembinaanQuery = const AdminActivityQuery(),
    this.kegiatanPage,
    this.pembinaanPage,
    this.isLoading = false,
    this.isDownloading = false,
    this.downloadProgress,
    this.downloadStatusMessage,
    this.lastDownloadedFilePath,
    this.errorMessage,
  });

  final DokumentasiMode mode;
  final AdminActivityQuery kegiatanQuery;
  final AdminActivityQuery pembinaanQuery;
  final PaginatedResponse<DokumentasiKegiatan>? kegiatanPage;
  final PaginatedResponse<Pembinaan>? pembinaanPage;
  final bool isLoading;
  final bool isDownloading;
  final double? downloadProgress;
  final String? downloadStatusMessage;
  final String? lastDownloadedFilePath;
  final String? errorMessage;

  AdminActivityQuery get activeQuery =>
      mode == DokumentasiMode.kegiatan ? kegiatanQuery : pembinaanQuery;

  List<dynamic> get currentItems => mode == DokumentasiMode.kegiatan
      ? (kegiatanPage?.items ?? const <DokumentasiKegiatan>[])
      : (pembinaanPage?.items ?? const <Pembinaan>[]);

  int get currentPage => mode == DokumentasiMode.kegiatan
      ? (kegiatanPage?.meta.currentPage ?? kegiatanQuery.page)
      : (pembinaanPage?.meta.currentPage ?? pembinaanQuery.page);

  int get lastPage => mode == DokumentasiMode.kegiatan
      ? (kegiatanPage?.meta.lastPage ?? 1)
      : (pembinaanPage?.meta.lastPage ?? 1);

  bool get hasPreviousPage => currentPage > 1;
  bool get hasNextPage => currentPage < lastPage;

  AdminDokumentasiState copyWith({
    DokumentasiMode? mode,
    AdminActivityQuery? kegiatanQuery,
    AdminActivityQuery? pembinaanQuery,
    PaginatedResponse<DokumentasiKegiatan>? kegiatanPage,
    PaginatedResponse<Pembinaan>? pembinaanPage,
    bool? isLoading,
    bool? isDownloading,
    double? downloadProgress,
    String? downloadStatusMessage,
    String? lastDownloadedFilePath,
    String? errorMessage,
    bool clearDownloadProgress = false,
    bool clearDownloadStatusMessage = false,
    bool clearLastDownloadedFilePath = false,
    bool clearErrorMessage = false,
  }) {
    return AdminDokumentasiState(
      mode: mode ?? this.mode,
      kegiatanQuery: kegiatanQuery ?? this.kegiatanQuery,
      pembinaanQuery: pembinaanQuery ?? this.pembinaanQuery,
      kegiatanPage: kegiatanPage ?? this.kegiatanPage,
      pembinaanPage: pembinaanPage ?? this.pembinaanPage,
      isLoading: isLoading ?? this.isLoading,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: clearDownloadProgress
          ? null
          : downloadProgress ?? this.downloadProgress,
      downloadStatusMessage: clearDownloadStatusMessage
          ? null
          : downloadStatusMessage ?? this.downloadStatusMessage,
      lastDownloadedFilePath: clearLastDownloadedFilePath
          ? null
          : lastDownloadedFilePath ?? this.lastDownloadedFilePath,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
