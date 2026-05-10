import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';

class FileUploadField extends StatefulWidget {
  const FileUploadField({
    super.key,
    required this.label,
    this.initialPath,
    this.initialPaths,
    required this.onChanged,
    this.onFilesChanged,
    this.allowedExtensions,
    this.isLoading = false,
    this.allowMultiple = false,
    this.maxFiles,
  });

  final String label;
  final String? initialPath;
  final List<String>? initialPaths;
  final ValueChanged<String?> onChanged;
  final ValueChanged<List<String>>? onFilesChanged;
  final List<String>? allowedExtensions;
  final bool isLoading;
  final bool allowMultiple;
  final int? maxFiles;

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  String? _filePath;
  List<String> _filePaths = const <String>[];

  @override
  void initState() {
    super.initState();
    _filePath = widget.initialPath;
    _filePaths = List<String>.from(widget.initialPaths ?? const <String>[]);
  }

  @override
  void didUpdateWidget(FileUploadField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPath != oldWidget.initialPath) {
      _filePath = widget.initialPath;
    }
    if (widget.initialPaths != oldWidget.initialPaths) {
      _filePaths = List<String>.from(widget.initialPaths ?? const <String>[]);
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: widget.allowMultiple,
      );

      if (result == null) {
        return;
      }

      final List<String> selectedPaths = result.files
          .map((PlatformFile file) => file.path)
          .whereType<String>()
          .where((String path) => path.isNotEmpty)
          .toList(growable: false);

      if (selectedPaths.isEmpty) {
        return;
      }

      if (widget.allowMultiple) {
        final int? maxFiles = widget.maxFiles;
        if (maxFiles != null && selectedPaths.length > maxFiles) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Maksimal $maxFiles berkas dapat dipilih.'),
                backgroundColor: AppTheme.error,
              ),
            );
          }
          return;
        }

        setState(() {
          _filePaths = selectedPaths;
        });
        widget.onFilesChanged?.call(List<String>.unmodifiable(_filePaths));
        widget.onChanged(_filePaths.isNotEmpty ? _filePaths.first : null);
        return;
      }

      setState(() {
        _filePath = selectedPaths.first;
      });
      widget.onChanged(_filePath);
      widget.onFilesChanged?.call(
        _filePath == null ? const <String>[] : <String>[_filePath!],
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih file: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  void _clearFile() {
    setState(() {
      _filePath = null;
      _filePaths = const <String>[];
    });
    widget.onChanged(null);
    widget.onFilesChanged?.call(const <String>[]);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final fileName = _filePath?.split('/').last.split('\\').last;
    final List<String> fileNames = _filePaths
        .map((String path) => path.split('/').last.split('\\').last)
        .toList(growable: false);
    final bool hasSelection = widget.allowMultiple
        ? _filePaths.isNotEmpty
        : _filePath != null;
    final String titleText = widget.allowMultiple
        ? (fileNames.isEmpty
              ? 'Pilih Berkas...'
              : '${fileNames.length} berkas dipilih')
        : (_filePath != null ? fileName! : 'Pilih Berkas...');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            widget.label,
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppSpacing.gapH12,
        EthnoCard(
          isFlat: true,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          onTap: widget.isLoading ? null : _pickFile,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.terracotta.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    border: Border.all(
                      color: AppTheme.terracotta.withValues(alpha: 0.20),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    hasSelection ? LucideIcons.file : LucideIcons.uploadCloud,
                    color: AppTheme.terracotta,
                    size: 18,
                  ),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleText,
                        style: textTheme.bodyMedium?.copyWith(
                          color: hasSelection
                              ? AppTheme.sogan
                              : AppTheme.neutral,
                          fontWeight: hasSelection
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.allowMultiple && fileNames.isNotEmpty)
                        ...fileNames.map(
                          (String name) => Text(
                            name,
                            style: textTheme.labelSmall?.copyWith(
                              color: AppTheme.neutral.withValues(alpha: 0.75),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (!hasSelection && widget.allowedExtensions != null)
                        Text(
                          widget.allowMultiple
                              ? 'Format: ${widget.allowedExtensions!.join(", ").toUpperCase()}${widget.maxFiles != null ? ' • Maks ${widget.maxFiles}' : ''}'
                              : 'Format: ${widget.allowedExtensions!.join(", ").toUpperCase()}',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppTheme.neutral.withValues(alpha: 0.6),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                if (hasSelection && !widget.isLoading)
                  IconButton(
                    icon: const Icon(
                      LucideIcons.xCircle,
                      color: AppTheme.error,
                      size: 22,
                    ),
                    tooltip: 'Hapus file',
                    onPressed: _clearFile,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                if (widget.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppTheme.terracotta),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
