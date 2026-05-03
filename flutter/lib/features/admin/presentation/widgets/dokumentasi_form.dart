import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/utils/app_error_mapper.dart';
import 'package:parikesit/core/widgets/app_text_field.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';
import 'package:parikesit/core/widgets/file_upload_field.dart';
import 'package:parikesit/features/admin/presentation/controller/admin_dokumentasi_controller.dart';
import 'package:parikesit/features/admin/presentation/controller/dokumentasi_detail_controller.dart';
import 'package:parikesit/features/pembinaan/domain/file_dokumentasi.dart';
import 'package:parikesit/features/pembinaan/domain/file_pembinaan.dart';

enum DokumentasiFormMode { add, edit }

class DokumentasiForm extends ConsumerStatefulWidget {
  const DokumentasiForm({
    super.key,
    required this.isPembinaan,
    required this.mode,
    this.initialData,
    this.id,
  });

  final bool isPembinaan;
  final DokumentasiFormMode mode;
  final Map<String, dynamic>? initialData;
  final String? id;

  @override
  ConsumerState<DokumentasiForm> createState() => _DokumentasiFormState();
}

class _AddMediaButton extends StatelessWidget {
  const _AddMediaButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return EthnoButton(
      onPressed: onTap,
      icon: Icons.add_photo_alternate_rounded,
      label: 'TAMBAH LAMPIRAN MEDIA',
      style: EthnoButtonStyle.outlined,
      size: EthnoButtonSize.small,
      isFullWidth: true,
    );
  }
}

class _DokumentasiFormState extends ConsumerState<DokumentasiForm> {
  static const List<String> _documentExtensions = ['pdf'];
  static const List<String> _mediaExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'mp4',
    'mp3',
    'avi',
    'flv',
  ];

  final _judulController = TextEditingController();
  String? _undanganPath;
  String? _daftarHadirPath;
  String? _materiPath;
  String? _notulaPath;
  final List<String> _mediaPaths = [];
  final List<String> _existingMediaFiles = [];
  String? _existingUndanganPath;
  String? _existingDaftarHadirPath;
  String? _existingMateriPath;
  String? _existingNotulaPath;

  bool _isSubmitting = false;

  String _extractExistingFilePath(dynamic file) {
    if (file is FileDokumentasi) {
      return file.namaFile;
    }
    if (file is FilePembinaan) {
      return file.namaFile;
    }
    if (file is Map<String, dynamic>) {
      return file['nama_file'] as String? ?? '';
    }
    if (file is Map) {
      return file.cast<String, dynamic>()['nama_file'] as String? ?? '';
    }
    return '';
  }

  void _updateMediaPath(int index, String? path) {
    setState(() {
      _mediaPaths[index] = path ?? '';
    });
  }

  Widget _buildDocumentUploadField({
    required String label,
    required String? initialPath,
    required void Function(String? path) onChanged,
  }) {
    return RepaintBoundary(
      child: FileUploadField(
        label: label,
        initialPath: initialPath,
        allowedExtensions: _documentExtensions,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMediaUploadField(int index) {
    return RepaintBoundary(
      key: ValueKey('media_upload_$index'),
      child: FileUploadField(
        label: 'Media Baru ${index + 1}',
        initialPath: _mediaPaths[index].isEmpty ? null : _mediaPaths[index],
        allowedExtensions: _mediaExtensions,
        onChanged: (path) => _updateMediaPath(index, path),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == DokumentasiFormMode.edit && widget.initialData != null) {
      _judulController.text = widget.isPembinaan
          ? widget.initialData!['judul_pembinaan'] ?? ''
          : widget.initialData!['judul_dokumentasi'] ?? '';
      _existingUndanganPath = widget.isPembinaan
          ? widget.initialData!['bukti_dukung_undangan_pembinaan'] as String?
          : widget.initialData!['bukti_dukung_undangan_dokumentasi'] as String?;
      _existingDaftarHadirPath = widget.isPembinaan
          ? widget.initialData!['daftar_hadir_pembinaan'] as String?
          : widget.initialData!['daftar_hadir_dokumentasi'] as String?;
      _existingMateriPath = widget.isPembinaan
          ? widget.initialData!['materi_pembinaan'] as String?
          : widget.initialData!['materi_dokumentasi'] as String?;
      _existingNotulaPath = widget.isPembinaan
          ? widget.initialData!['notula_pembinaan'] as String?
          : widget.initialData!['notula_dokumentasi'] as String?;

      final existingFiles = widget.isPembinaan
          ? (widget.initialData!['file_pembinaan'] as List<dynamic>? ??
                const [])
          : (widget.initialData!['file_dokumentasi'] as List<dynamic>? ??
                const []);
      _existingMediaFiles.addAll(
        existingFiles
            .map(_extractExistingFilePath)
            .where((path) => path.isNotEmpty),
      );
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_judulController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Judul tidak boleh kosong')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final newMediaPaths = _mediaPaths
          .where((path) => path.isNotEmpty)
          .toList();
      final Map<String, dynamic> data = {
        widget.isPembinaan ? 'judul_pembinaan' : 'judul_dokumentasi':
            _judulController.text,
        'bukti_dukung_undangan': _undanganPath ?? '',
        'daftar_hadir': _daftarHadirPath ?? '',
        'materi': _materiPath ?? '',
        'notula': _notulaPath ?? '',
      };

      if (newMediaPaths.isNotEmpty) {
        data['files'] = newMediaPaths;
      }

      if (widget.mode == DokumentasiFormMode.add) {
        if (widget.isPembinaan) {
          await ref
              .read(adminDokumentasiControllerProvider.notifier)
              .createPembinaan(data);
        } else {
          await ref
              .read(adminDokumentasiControllerProvider.notifier)
              .createKegiatan(data);
        }
      } else {
        await ref
            .read(adminDokumentasiControllerProvider.notifier)
            .updateActivity(
              id: widget.id!,
              data: data,
              isPembinaan: widget.isPembinaan,
            );

        if (widget.isPembinaan) {
          ref.invalidate(pembinaanDetailProvider(widget.id!));
        } else {
          ref.invalidate(dokumentasiDetailProvider(widget.id!));
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_buildErrorMessage(e))));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _buildErrorMessage(Object error) {
    return AppErrorMapper.toMessage(
      error,
      fallbackMessage: 'Gagal menyimpan data. Silakan coba lagi.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final title =
        '${widget.mode == DokumentasiFormMode.add ? 'TAMBAH' : 'EDIT'} DOKUMENTASI';
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: AppTheme.shellSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppTheme.sogan,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.sogan.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.sogan,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH24,
              AppTextField(
                controller: _judulController,
                label: 'Judul ${widget.isPembinaan ? 'Pembinaan' : 'Kegiatan'}',
                hint: 'Contoh: Rapat Koordinasi SDI',
                prefixIcon: const Icon(Icons.title_rounded),
              ),
              AppSpacing.gapH32,
              _buildSectionHeader(context, 'DOKUMEN UTAMA (PDF)'),
              AppSpacing.gapH16,
              _buildDocumentUploadField(
                label: '1. Surat Undangan',
                initialPath: _undanganPath ?? _existingUndanganPath,
                onChanged: (path) => setState(() => _undanganPath = path),
              ),
              AppSpacing.gapH12,
              _buildDocumentUploadField(
                label: '2. Daftar Hadir',
                initialPath: _daftarHadirPath ?? _existingDaftarHadirPath,
                onChanged: (path) => setState(() => _daftarHadirPath = path),
              ),
              AppSpacing.gapH12,
              _buildDocumentUploadField(
                label: '3. Materi / Bahan Tayang',
                initialPath: _materiPath ?? _existingMateriPath,
                onChanged: (path) => setState(() => _materiPath = path),
              ),
              AppSpacing.gapH12,
              _buildDocumentUploadField(
                label: '4. Notulensi Rapat',
                initialPath: _notulaPath ?? _existingNotulaPath,
                onChanged: (path) => setState(() => _notulaPath = path),
              ),
              AppSpacing.gapH32,
              _buildSectionHeader(context, 'LAMPIRAN MEDIA (FOTO/VIDEO)'),
              AppSpacing.gapH16,
              if (_existingMediaFiles.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'Media yang sudah terunggah:',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppTheme.neutral,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ..._existingMediaFiles.map(
                  (path) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EthnoCard(
                      isFlat: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      margin: EdgeInsets.zero,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_rounded,
                            size: 18,
                            color: AppTheme.sogan,
                          ),
                          AppSpacing.gapW12,
                          Expanded(
                            child: Text(
                              path.split('/').last,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppTheme.sogan.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppTheme.success,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapH16,
              ],
              ..._mediaPaths.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMediaUploadField(entry.key),
                );
              }),
              _AddMediaButton(
                onTap: () {
                  setState(() {
                    _mediaPaths.add('');
                  });
                },
              ),
              AppSpacing.gapH48,
              EthnoButton(
                onPressed: _isSubmitting ? null : _submit,
                label: 'SIMPAN PERUBAHAN',
                isLoading: _isSubmitting,
                isFullWidth: true,
              ),
              AppSpacing.gapH16,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTheme.gold,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
