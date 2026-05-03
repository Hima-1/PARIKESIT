import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/admin/presentation/widgets/dokumentasi_form.dart';
import 'package:parikesit/features/pembinaan/domain/file_dokumentasi.dart';
import 'package:parikesit/features/pembinaan/domain/file_pembinaan.dart';

void main() {
  testWidgets('add form for kegiatan shows kegiatan labels', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DokumentasiForm(
            isPembinaan: false,
            mode: DokumentasiFormMode.add,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TAMBAH DOKUMENTASI'), findsOneWidget);
    expect(find.text('Judul Kegiatan'), findsOneWidget);
  });

  testWidgets('add form for pembinaan shows pembinaan labels', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DokumentasiForm(
            isPembinaan: true,
            mode: DokumentasiFormMode.add,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TAMBAH DOKUMENTASI'), findsOneWidget);
    expect(find.text('Judul Pembinaan'), findsOneWidget);
  });

  testWidgets('edit form shows existing documents and media', (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DokumentasiForm(
            isPembinaan: false,
            mode: DokumentasiFormMode.edit,
            id: '1',
            initialData: {
              'judul_dokumentasi': 'Dokumentasi OPD',
              'bukti_dukung_undangan_dokumentasi':
                  'file-dokumentasi/opd/undangan-lama.pdf',
              'daftar_hadir_dokumentasi':
                  'file-dokumentasi/opd/daftar-hadir-lama.pdf',
              'materi_dokumentasi': 'file-dokumentasi/opd/materi-lama.pdf',
              'notula_dokumentasi': 'file-dokumentasi/opd/notula-lama.pdf',
              'file_dokumentasi': [
                {'nama_file': 'file-dokumentasi/opd/media/media-lama-1.jpg'},
                {'nama_file': 'file-dokumentasi/opd/media/media-lama-2.png'},
              ],
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dokumentasi OPD'), findsOneWidget);
    expect(find.text('undangan-lama.pdf'), findsOneWidget);
    expect(find.text('daftar-hadir-lama.pdf'), findsOneWidget);
    expect(find.text('materi-lama.pdf'), findsOneWidget);
    expect(find.text('notula-lama.pdf'), findsOneWidget);
    expect(find.text('Media yang sudah terunggah:'), findsOneWidget);
    expect(find.text('media-lama-1.jpg'), findsOneWidget);
    expect(find.text('media-lama-2.png'), findsOneWidget);
  });

  testWidgets('edit form accepts typed kegiatan media objects', (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DokumentasiForm(
            isPembinaan: false,
            mode: DokumentasiFormMode.edit,
            id: '1',
            initialData: <String, dynamic>{
              'judul_dokumentasi': 'Dokumentasi Typed',
              'bukti_dukung_undangan_dokumentasi':
                  'file-dokumentasi/opd/undangan-typed.pdf',
              'daftar_hadir_dokumentasi':
                  'file-dokumentasi/opd/daftar-hadir-typed.pdf',
              'materi_dokumentasi': 'file-dokumentasi/opd/materi-typed.pdf',
              'notula_dokumentasi': 'file-dokumentasi/opd/notula-typed.pdf',
              'file_dokumentasi': <FileDokumentasi>[
                FileDokumentasi(
                  id: 'media-1',
                  dokumentasiKegiatanId: '1',
                  namaFile: 'file-dokumentasi/opd/media/media-typed-1.jpg',
                  tipeFile: 'jpg',
                  createdAt: DateTime(2026, 3, 29),
                  updatedAt: DateTime(2026, 3, 29),
                ),
                FileDokumentasi(
                  id: 'media-2',
                  dokumentasiKegiatanId: '1',
                  namaFile: 'file-dokumentasi/opd/media/media-typed-2.png',
                  tipeFile: 'png',
                  createdAt: DateTime(2026, 3, 29),
                  updatedAt: DateTime(2026, 3, 29),
                ),
              ],
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Dokumentasi Typed'), findsOneWidget);
    expect(find.text('media-typed-1.jpg'), findsOneWidget);
    expect(find.text('media-typed-2.png'), findsOneWidget);
  });

  testWidgets('edit form accepts typed pembinaan media objects', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DokumentasiForm(
            isPembinaan: true,
            mode: DokumentasiFormMode.edit,
            id: '2',
            initialData: <String, dynamic>{
              'judul_pembinaan': 'Pembinaan Typed',
              'bukti_dukung_undangan_pembinaan':
                  'file-pembinaan/opd/undangan-typed.pdf',
              'daftar_hadir_pembinaan':
                  'file-pembinaan/opd/daftar-hadir-typed.pdf',
              'materi_pembinaan': 'file-pembinaan/opd/materi-typed.pdf',
              'notula_pembinaan': 'file-pembinaan/opd/notula-typed.pdf',
              'file_pembinaan': <FilePembinaan>[
                FilePembinaan(
                  id: 'media-1',
                  pembinaanId: '2',
                  namaFile: 'file-pembinaan/opd/media/media-typed-1.jpg',
                  tipeFile: 'jpg',
                  createdAt: DateTime(2026, 3, 29),
                  updatedAt: DateTime(2026, 3, 29),
                ),
                FilePembinaan(
                  id: 'media-2',
                  pembinaanId: '2',
                  namaFile: 'file-pembinaan/opd/media/media-typed-2.png',
                  tipeFile: 'png',
                  createdAt: DateTime(2026, 3, 29),
                  updatedAt: DateTime(2026, 3, 29),
                ),
              ],
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Pembinaan Typed'), findsOneWidget);
    expect(find.text('media-typed-1.jpg'), findsOneWidget);
    expect(find.text('media-typed-2.png'), findsOneWidget);
  });
}
