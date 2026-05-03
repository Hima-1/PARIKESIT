import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'logger.dart';

class DownloadTarget {
  const DownloadTarget({required this.fileName, required this.tempFilePath});

  final String fileName;
  final String tempFilePath;
}

class FileSaver {
  static const MethodChannel _downloadsChannel = MethodChannel(
    'parikesit/downloads',
  );

  static String _sanitizeFileName(String fileName) {
    final sanitized = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]+'), '_').trim();
    if (sanitized.isEmpty) {
      return 'download-${DateTime.now().millisecondsSinceEpoch}.bin';
    }

    return sanitized;
  }

  static Future<String?> saveFile(List<int> bytes, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final safeFileName = _sanitizeFileName(fileName);
      final filePath = p.join(directory.path, safeFileName);
      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      AppLogger.debug('File saved to app documents: $filePath');
      return filePath;
    } catch (e, stack) {
      AppLogger.error('Failed to save file', e, stack);
      return null;
    }
  }

  static Future<String?> saveToDownloads(
    List<int> bytes,
    String fileName,
  ) async {
    final safeFileName = _sanitizeFileName(fileName);

    try {
      if (!Platform.isAndroid) {
        return saveFile(bytes, safeFileName);
      }

      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        AppLogger.warning(
          'External storage directory unavailable, falling back to app documents',
        );
        return saveFile(bytes, safeFileName);
      }

      final filePath = p.join(directory.path, safeFileName);
      final file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      AppLogger.debug(
        'File saved to app-accessible external storage: $filePath',
      );
      return filePath;
    } on FileSystemException catch (e, stack) {
      AppLogger.error(
        'Failed to save file to Android external storage',
        e,
        stack,
      );
      return saveFile(bytes, safeFileName);
    } catch (e, stack) {
      AppLogger.error('Failed to save file to downloads', e, stack);
      return saveFile(bytes, safeFileName);
    }
  }

  static Future<DownloadTarget?> prepareDownloadTarget(String fileName) async {
    final safeFileName = _sanitizeFileName(fileName);

    try {
      final directory = await getTemporaryDirectory();
      return DownloadTarget(
        fileName: safeFileName,
        tempFilePath: p.join(directory.path, safeFileName),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to prepare download target', e, stack);
      return null;
    }
  }

  static String sanitizeDownloadFileName(String fileName) {
    return _sanitizeFileName(fileName);
  }

  static Future<String?> moveTempFileToPublicDownloads(
    String tempFilePath,
    String fileName,
  ) async {
    final safeFileName = _sanitizeFileName(fileName);

    try {
      if (!Platform.isAndroid) {
        final bytes = await File(tempFilePath).readAsBytes();
        return saveFile(bytes, safeFileName);
      }

      final String? savedPath = await _downloadsChannel
          .invokeMethod<String>('saveFileToDownloads', <String, dynamic>{
            'sourcePath': tempFilePath,
            'fileName': safeFileName,
            'mimeType': 'application/zip',
          });

      AppLogger.debug(
        'File saved to public Downloads: ${savedPath ?? safeFileName}',
      );
      return savedPath;
    } on PlatformException catch (e, stack) {
      AppLogger.error('Failed to save file to public Downloads', e, stack);
      return null;
    } catch (e, stack) {
      AppLogger.error(
        'Unexpected failure saving file to public Downloads',
        e,
        stack,
      );
      return null;
    } finally {
      try {
        final tempFile = File(tempFilePath);
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
      } catch (e, stack) {
        AppLogger.warning('Failed to delete temporary download file: $e');
        AppLogger.error('Temporary download cleanup failure', e, stack);
      }
    }
  }
}
