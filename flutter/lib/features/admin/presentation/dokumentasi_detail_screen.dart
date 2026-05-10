import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/auth/user_role.dart';
import 'package:parikesit/core/config/app_config.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/app_breadcrumb.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/features/admin/presentation/controller/admin_dokumentasi_controller.dart';
import 'package:parikesit/features/admin/presentation/controller/dokumentasi_detail_controller.dart';
import 'package:parikesit/features/admin/presentation/widgets/dokumentasi_form.dart';
import 'package:parikesit/features/auth/presentation/controller/auth_provider.dart';
import 'package:parikesit/features/pembinaan/domain/dokumentasi_kegiatan.dart';
import 'package:parikesit/features/pembinaan/domain/file_dokumentasi.dart';
import 'package:parikesit/features/pembinaan/domain/file_pembinaan.dart';
import 'package:parikesit/features/pembinaan/domain/pembinaan.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/app_dialogs.dart';

class DokumentasiDetailScreen extends ConsumerWidget {
  const DokumentasiDetailScreen({
    super.key,
    required this.id,
    required this.type,
  });

  final String id;
  final DokumentasiDetailType type;

  static const Set<String> _imageExtensions = <String>{
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
  };

  static const Set<String> _videoExtensions = <String>{
    '.mp4',
    '.mov',
    '.avi',
    '.mkv',
    '.webm',
    '.m4v',
  };

  Future<void> _handleRefresh(WidgetRef ref) async {
    if (type == DokumentasiDetailType.pembinaan) {
      final future = ref.refresh(pembinaanDetailProvider(id).future);
      await future;
      return;
    }

    final future = ref.refresh(dokumentasiDetailProvider(id).future);
    await future;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final role = ref.watch(userRoleProvider);
    final controllerState = ref.watch(adminDokumentasiControllerProvider);
    final bool isPembinaan = type == DokumentasiDetailType.pembinaan;
    final detailAsync = isPembinaan
        ? ref.watch(pembinaanDetailProvider(id))
        : ref.watch(dokumentasiDetailProvider(id));

    return detailAsync.when(
      loading: () => _buildLoadingScaffold(ref),
      error: (error, _) => _buildErrorScaffold(context, ref, error),
      data: (item) => _buildDetailScaffold(
        context,
        ref,
        item: item,
        isPembinaan: isPembinaan,
        isAdmin: role == UserRole.admin,
        currentUserId: authState.user?.id,
        controllerState: controllerState,
      ),
    );
  }

  Scaffold _buildLoadingScaffold(WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Detail Dokumentasi')),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 240),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppTheme.sogan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _buildErrorScaffold(
    BuildContext context,
    WidgetRef ref,
    Object error,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Detail Dokumentasi')),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pPage,
          children: [
            const SizedBox(height: 200),
            Center(
              child: Text(
                'Gagal memuat detail: $error',
                style: textTheme.bodyMedium?.copyWith(color: AppTheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold _buildDetailScaffold(
    BuildContext context,
    WidgetRef ref, {
    required dynamic item,
    required bool isPembinaan,
    required bool isAdmin,
    required int? currentUserId,
    required dynamic controllerState,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final detail = _resolveDetailData(item, isPembinaan);
    final bool isCreator =
        currentUserId != null && detail.createdById == currentUserId.toString();
    final bool showActions = isPembinaan ? isAdmin : (isAdmin || isCreator);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Detail Dokumentasi')),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(ref),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pPage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBreadcrumbs(context, isPembinaan),
              AppSpacing.gapH24,
              _buildDetailHeader(context, detail, textTheme),
              AppSpacing.gapH24,
              if (showActions)
                _buildAdminActions(context, ref, id, isPembinaan, item),
              if (showActions) AppSpacing.gapH24,
              _buildSectionTitle(context, 'DOKUMEN TERKAIT'),
              AppSpacing.gapH12,
              _buildRelatedDocuments(context, item, isPembinaan),
              AppSpacing.gapH24,
              _buildSectionTitle(context, 'MEDIA (FOTO / VIDEO)'),
              AppSpacing.gapH12,
              _buildMediaSection(context, item, isPembinaan),
              AppSpacing.gapH32,
              _buildFooterActions(
                context,
                ref,
                id,
                isPembinaan,
                controllerState,
              ),
              AppSpacing.gapH24,
            ],
          ),
        ),
      ),
    );
  }

  ({String title, DateTime date, String creatorName, String createdById})
  _resolveDetailData(dynamic item, bool isPembinaan) {
    if (isPembinaan) {
      final pembinaan = item as Pembinaan;
      return (
        title: pembinaan.judulPembinaan,
        date: pembinaan.createdAt,
        creatorName: pembinaan.creatorName,
        createdById: pembinaan.createdById,
      );
    }

    final dokumentasi = item as DokumentasiKegiatan;
    return (
      title: dokumentasi.judulDokumentasi,
      date: dokumentasi.createdAt,
      creatorName: dokumentasi.creatorName,
      createdById: dokumentasi.createdById,
    );
  }

  Widget _buildDetailHeader(
    BuildContext context,
    ({String title, DateTime date, String creatorName, String createdById})
    detail,
    TextTheme textTheme,
  ) {
    return EthnoCard(
      isFlat: true,
      showBatikAccent: true,
      padding: AppSpacing.pAll24,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppTheme.sogan,
              height: 1.3,
            ),
          ),
          AppSpacing.gapH16,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMetadataItem(
                context,
                LucideIcons.calendar,
                DateFormat('dd MMMM yyyy', 'id_ID').format(detail.date),
              ),
              AppSpacing.gapH8,
              _buildMetadataItem(
                context,
                LucideIcons.userCheck,
                detail.creatorName,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs(BuildContext context, bool isPembinaan) {
    return AppBreadcrumb(
      items: [
        BreadcrumbItem(
          label: isPembinaan ? 'Pembinaan' : 'Kegiatan',
          onTap: () => Navigator.pop(context),
        ),
        const BreadcrumbItem(label: 'Detail'),
      ],
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.gold),
        AppSpacing.gapW6,
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.neutral,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTheme.sogan.withValues(alpha: 0.6),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildAdminActions(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool isPembinaan,
    dynamic item,
  ) {
    const String editLabel = 'EDIT';
    const String deleteLabel = 'HAPUS';

    return Row(
      children: [
        Expanded(
          child: EthnoButton(
            onPressed: () => _showEditForm(context, ref, id, isPembinaan, item),
            icon: LucideIcons.fileEdit,
            label: editLabel,
            style: EthnoButtonStyle.outlined,
            size: EthnoButtonSize.small,
          ),
        ),
        AppSpacing.gapW12,
        Expanded(
          child: EthnoButton(
            onPressed: () => _confirmDelete(context, ref, id, isPembinaan),
            icon: LucideIcons.trash,
            label: deleteLabel,
            style: EthnoButtonStyle.danger,
            size: EthnoButtonSize.small,
          ),
        ),
      ],
    );
  }

  void _showEditForm(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool isPembinaan,
    dynamic item,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DokumentasiForm(
        isPembinaan: isPembinaan,
        mode: DokumentasiFormMode.edit,
        id: id,
        initialData: (item as dynamic).toJson(),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool isPembinaan,
  ) async {
    final confirmed = await AppDialogs.showConfirmation(
      context,
      title: 'Hapus Dokumentasi',
      content: 'Apakah Anda yakin ingin menghapus dokumentasi ini?',
      confirmLabel: 'Hapus',
      isDanger: true,
    );

    if (confirmed == true) {
      await ref
          .read(adminDokumentasiControllerProvider.notifier)
          .deleteActivity(id, isPembinaan);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildRelatedDocuments(
    BuildContext context,
    dynamic item,
    bool isPembinaan,
  ) {
    final String undangan = isPembinaan
        ? item.buktiDukungUndanganPembinaan
        : item.buktiDukungUndanganDokumentasi;
    final String daftarHadir = isPembinaan
        ? item.daftarHadirPembinaan
        : item.daftarHadirDokumentasi;
    final String notula = isPembinaan
        ? item.notulaPembinaan
        : item.notulaDokumentasi;
    final String materi = isPembinaan
        ? item.materiPembinaan
        : item.materiDokumentasi;

    return EthnoCard(
      isFlat: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _DocumentTile(label: 'Surat Undangan', path: undangan),
          const Divider(height: 1, thickness: 0.5),
          _DocumentTile(label: 'Daftar Kehadiran', path: daftarHadir),
          const Divider(height: 1, thickness: 0.5),
          _DocumentTile(label: 'Notulensi Rapat', path: notula),
          const Divider(height: 1, thickness: 0.5),
          _DocumentTile(label: 'Materi / Bahan Tayang', path: materi),
        ],
      ),
    );
  }

  Widget _buildMediaSection(
    BuildContext context,
    dynamic item,
    bool isPembinaan,
  ) {
    final List<dynamic> files = isPembinaan
        ? List<FilePembinaan>.from((item as Pembinaan).files)
        : List<FileDokumentasi>.from((item as DokumentasiKegiatan).files);
    final textTheme = Theme.of(context).textTheme;

    if (files.isEmpty) {
      return EthnoCard(
        isFlat: true,
        padding: AppSpacing.pAll24,
        margin: EdgeInsets.zero,
        child: Center(
          child: Text(
            'Tidak ada lampiran media (foto/video).',
            style: textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
          ),
        ),
      );
    }

    return EthnoCard(
      isFlat: true,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: files.length,
        separatorBuilder: (_, _) => const Divider(height: 1, thickness: 0.5),
        itemBuilder: (context, index) {
          final String filePath = files[index].namaFile;
          final fileName = filePath.split('/').last;
          final fileUrl = _resolvePublicFileUrl(filePath);
          final isImage = _isImageFile(fileName);
          final isVideo = _isVideoFile(fileName);
          return ListTile(
            dense: true,
            onTap: () => _handleMediaTap(
              context,
              fileName: fileName,
              fileUrl: fileUrl,
              isImage: isImage,
              isVideo: isVideo,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.sogan.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.image,
                size: 18,
                color: AppTheme.sogan,
              ),
            ),
            title: Text(
              fileName,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              fileUrl,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
            ),
            trailing: IconButton(
              icon: Icon(
                isImage
                    ? LucideIcons.eye
                    : (isVideo
                          ? LucideIcons.playCircle
                          : LucideIcons.externalLink),
                color: AppTheme.gold,
                size: 24,
              ),
              tooltip: isImage
                  ? 'Lihat gambar'
                  : (isVideo ? 'Buka video' : 'Buka lampiran'),
              onPressed: () => _handleMediaTap(
                context,
                fileName: fileName,
                fileUrl: fileUrl,
                isImage: isImage,
                isVideo: isVideo,
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isImageFile(String value) {
    final String file = value.toLowerCase();
    return _imageExtensions.any(file.endsWith);
  }

  bool _isVideoFile(String value) {
    final String file = value.toLowerCase();
    return _videoExtensions.any(file.endsWith);
  }

  String _resolvePublicFileUrl(String path) {
    final trimmed = path.trim();
    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.hasScheme && parsed.hasAuthority) {
      return parsed.toString();
    }

    final baseUri = Uri.parse(AppConfig.baseUrl);
    final normalizedPath = trimmed.startsWith('/storage/')
        ? trimmed
        : (trimmed.startsWith('storage/') ? '/$trimmed' : '/storage/$trimmed');
    return baseUri.resolve(normalizedPath).toString();
  }

  Future<void> _handleMediaTap(
    BuildContext context, {
    required String fileName,
    required String fileUrl,
    required bool isImage,
    required bool isVideo,
  }) async {
    if (isImage) {
      _showImagePreview(context, fileName: fileName, fileUrl: fileUrl);
      return;
    }

    try {
      final Uri url = Uri.parse(fileUrl);
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        _showOpenFailureMessage(context, isVideo: isVideo);
      }
    } catch (_) {
      if (context.mounted) {
        _showOpenFailureMessage(context, isVideo: isVideo);
      }
    }
  }

  void _showOpenFailureMessage(BuildContext context, {required bool isVideo}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isVideo
              ? 'Video tidak dapat dibuka dari perangkat ini.'
              : 'Lampiran tidak dapat dibuka dari perangkat ini.',
        ),
      ),
    );
  }

  void _showImagePreview(
    BuildContext context, {
    required String fileName,
    required String fileUrl,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: fileUrl,
                  fit: BoxFit.contain,
                  fadeInDuration: const Duration(milliseconds: 200),
                  progressIndicatorBuilder: (context, url, progress) =>
                      const Center(
                        child: CircularProgressIndicator(color: AppTheme.gold),
                      ),
                  errorWidget: (context, url, error) => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.imageOff,
                        color: Colors.white54,
                        size: 64,
                      ),
                      AppSpacing.gapH16,
                      Text(
                        'Gagal memuat gambar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: AppSpacing.pAll12,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  fileName,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterActions(
    BuildContext context,
    WidgetRef ref,
    String id,
    bool isPembinaan,
    dynamic controllerState,
  ) {
    const String downloadLabel = 'DOWNLOAD SEMUA LAMPIRAN';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EthnoButton(
          onPressed: controllerState.isDownloading
              ? null
              : () => ref
                    .read(adminDokumentasiControllerProvider.notifier)
                    .downloadAll(id, isPembinaan),
          icon: LucideIcons.archive,
          label: downloadLabel,
          isLoading: controllerState.isDownloading,
          isFullWidth: true,
        ),
        if (controllerState.isDownloading ||
            controllerState.downloadStatusMessage != null) ...[
          AppSpacing.gapH12,
          Text(
            controllerState.downloadStatusMessage ?? 'Menyiapkan unduhan...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (controllerState.downloadProgress != null) ...[
            AppSpacing.gapH8,
            LinearProgressIndicator(
              value: controllerState.downloadProgress as double?,
              minHeight: 6,
              backgroundColor: AppTheme.sogan.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.gold),
            ),
          ],
        ],
        AppSpacing.gapH12,
        EthnoButton(
          onPressed: () => Navigator.pop(context),
          label: 'KEMBALI KE DAFTAR',
          style: EthnoButtonStyle.text,
          isFullWidth: true,
        ),
      ],
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({required this.label, required this.path});

  final String label;
  final String path;

  @override
  Widget build(BuildContext context) {
    final bool exists = path.isNotEmpty;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.sogan,
          ),
        ),
        trailing: exists
            ? EthnoButton(
                onPressed: () async {
                  final normalizedPath = path.startsWith('storage/')
                      ? path.substring('storage/'.length)
                      : path;
                  final url = Uri.parse(
                    '${AppConfig.baseUrl}/storage/$normalizedPath',
                  );
                  try {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } catch (_) {
                    await launchUrl(url);
                  }
                },
                label: 'LIHAT',
                style: EthnoButtonStyle.text,
                size: EthnoButtonSize.small,
              )
            : Text(
                'KOSONG',
                style: textTheme.labelSmall?.copyWith(
                  color: AppTheme.neutral.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w900,
                  fontSize: 8,
                ),
              ),
      ),
    );
  }
}
