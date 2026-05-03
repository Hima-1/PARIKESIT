import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

Future<String> generateSinglePagePdfFromImageFile(
  String imagePath, {
  String? fileNamePrefix,
}) async {
  final bytes = await File(imagePath).readAsBytes();

  final doc = pw.Document();
  final image = pw.MemoryImage(bytes);

  doc.addPage(
    pw.Page(
      build: (context) =>
          pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ),
  );

  final tempDir = await getTemporaryDirectory();
  final prefix = (fileNamePrefix == null || fileNamePrefix.isEmpty)
      ? 'dokumentasi'
      : fileNamePrefix;
  final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final outPath = p.join(tempDir.path, fileName);

  final outFile = File(outPath);
  await outFile.writeAsBytes(await doc.save(), flush: true);

  return outFile.path;
}
