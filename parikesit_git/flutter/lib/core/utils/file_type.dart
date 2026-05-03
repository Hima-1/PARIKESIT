import 'package:path/path.dart' as p;

enum PickedFileKind { pdf, image, unsupported }

PickedFileKind detectPickedFileKind(String filePath) {
  final ext = p.extension(filePath).toLowerCase().replaceFirst('.', '');

  switch (ext) {
    case 'pdf':
      return PickedFileKind.pdf;
    case 'jpg':
    case 'jpeg':
    case 'png':
      return PickedFileKind.image;
    default:
      return PickedFileKind.unsupported;
  }
}
