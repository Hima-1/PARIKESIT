import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';

class EvidenceLinkTile extends StatelessWidget {
  const EvidenceLinkTile({
    super.key,
    required this.fileName,
    required this.fileUrl,
    this.fileSizeLabel,
    this.onOpen,
  });

  final String fileName;
  final String fileUrl;
  final String? fileSizeLabel;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isImage = _isImageFile(fileName);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.shellSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.sogan.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: AppSpacing.pAll8,
          decoration: BoxDecoration(
            color: AppTheme.sogan.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_resolveFileIcon(fileName), color: AppTheme.sogan),
        ),
        title: Text(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          fileSizeLabel == null ? fileUrl : '$fileUrl • $fileSizeLabel',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: AppTheme.neutral),
        ),
        trailing: IconButton(
          icon: Icon(isImage ? LucideIcons.eye : LucideIcons.externalLink),
          color: AppTheme.gold,
          tooltip: isImage ? 'Lihat gambar' : 'Buka bukti dukung',
          onPressed: () async {
            await HapticFeedback.lightImpact();
            if (!context.mounted) return;
            if (isImage) {
              _showImagePreview(context);
            } else if (onOpen != null) {
              onOpen!();
            } else {
              await _openExternal(context);
            }
          },
        ),
        onTap: () async {
          await HapticFeedback.lightImpact();
          if (!context.mounted) return;
          if (isImage) {
            _showImagePreview(context);
            return;
          }
          if (onOpen != null) {
            onOpen!();
            return;
          }
          await _openExternal(context);
        },
      ),
    );
  }

  bool _isImageFile(String value) {
    final String file = value.toLowerCase();
    return file.endsWith('.jpg') ||
        file.endsWith('.jpeg') ||
        file.endsWith('.png') ||
        file.endsWith('.webp');
  }

  void _showImagePreview(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
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

  Future<void> _openExternal(BuildContext context) async {
    try {
      final Uri url = Uri.parse(fileUrl);
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bukti dukung tidak dapat dibuka dari perangkat ini.',
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Bukti dukung tidak dapat dibuka dari perangkat ini.',
            ),
          ),
        );
      }
    }
  }

  IconData _resolveFileIcon(String value) {
    final String file = value.toLowerCase();
    if (file.endsWith('.pdf')) {
      return LucideIcons.fileText;
    }
    if (_isImageFile(file)) {
      return LucideIcons.image;
    }
    if (file.endsWith('.xls') ||
        file.endsWith('.xlsx') ||
        file.endsWith('.csv')) {
      return LucideIcons.table;
    }
    if (file.endsWith('.doc') || file.endsWith('.docx')) {
      return LucideIcons.fileText;
    }
    return LucideIcons.paperclip;
  }
}
