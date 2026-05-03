import 'package:parikesit/core/config/app_config.dart';

class EvidenceAttachment {
  const EvidenceAttachment({
    required this.fileName,
    required this.fileUrl,
    this.fileSizeLabel,
  });

  factory EvidenceAttachment.fromJson(Map<String, dynamic> json) {
    return EvidenceAttachment(
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSizeLabel: json['fileSizeLabel'] as String?,
    );
  }

  final String fileName;
  final String fileUrl;
  final String? fileSizeLabel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSizeLabel': fileSizeLabel,
    };
  }
}

List<EvidenceAttachment> buildEvidenceAttachments(List<String>? paths) {
  if (paths == null || paths.isEmpty) {
    return const <EvidenceAttachment>[];
  }

  return paths
      .where((String path) => path.trim().isNotEmpty)
      .map(
        (String path) => EvidenceAttachment(
          fileName: evidenceFileName(path),
          fileUrl: resolveEvidencePublicUrl(path),
        ),
      )
      .toList(growable: false);
}

String evidenceFileName(String path) {
  return path.split('/').last.split('\\').last;
}

String resolveEvidencePublicUrl(String path) {
  final String trimmed = path.trim();
  final Uri? parsed = Uri.tryParse(trimmed);
  if (parsed != null && parsed.hasScheme && parsed.hasAuthority) {
    return parsed.toString();
  }

  final Uri baseUri = Uri.parse(_resolveBaseUrl());
  final String normalizedPath;
  if (trimmed.startsWith('/storage/')) {
    normalizedPath = trimmed;
  } else if (trimmed.startsWith('storage/')) {
    normalizedPath = '/$trimmed';
  } else {
    normalizedPath = '/storage/$trimmed';
  }

  return baseUri.resolve(normalizedPath).toString();
}

String _resolveBaseUrl() {
  try {
    return AppConfig.baseUrl;
  } on StateError {
    return 'http://127.0.0.1:8000';
  }
}
