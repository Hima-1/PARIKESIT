import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/pembinaan/domain/dokumentasi_kegiatan.dart';
import 'package:parikesit/features/pembinaan/domain/pembinaan.dart';

void main() {
  group('DokumentasiKegiatan.fromJson', () {
    test('parses summary payload without media relation', () {
      final model = DokumentasiKegiatan.fromJson({
        'id': 1,
        'created_by_id': 2,
        'directory_dokumentasi': 'dir-a',
        'judul_dokumentasi': 'Judul A',
        'bukti_dukung_undangan_dokumentasi': 'undangan.pdf',
        'daftar_hadir_dokumentasi': 'hadir.pdf',
        'materi_dokumentasi': 'materi.pdf',
        'notula_dokumentasi': 'notula.pdf',
        'created_at': '2026-03-13T01:02:03.000000Z',
        'updated_at': '2026-03-13T01:02:03.000000Z',
      });

      expect(model.id, '1');
      expect(model.files, isEmpty);
    });

    test('parses detail payload with integer media ids', () {
      final model = DokumentasiKegiatan.fromJson({
        'id': 1,
        'created_by_id': 2,
        'directory_dokumentasi': 'dir-a',
        'judul_dokumentasi': 'Judul A',
        'bukti_dukung_undangan_dokumentasi': 'undangan.pdf',
        'daftar_hadir_dokumentasi': 'hadir.pdf',
        'materi_dokumentasi': 'materi.pdf',
        'notula_dokumentasi': 'notula.pdf',
        'file_dokumentasi': [
          {
            'id': 10,
            'dokumentasi_kegiatan_id': 1,
            'nama_file': 'media/a.jpg',
            'tipe_file': 'jpg',
            'created_at': '2026-03-13T01:02:03.000000Z',
            'updated_at': '2026-03-13T01:02:03.000000Z',
          },
        ],
        'created_at': '2026-03-13T01:02:03.000000Z',
        'updated_at': '2026-03-13T01:02:03.000000Z',
      });

      expect(model.files.single.id, '10');
      expect(model.files.single.dokumentasiKegiatanId, '1');
    });
  });

  group('Pembinaan.fromJson', () {
    test('parses summary payload without media relation', () {
      final model = Pembinaan.fromJson({
        'id': 1,
        'created_by_id': 2,
        'directory_pembinaan': 'dir-b',
        'judul_pembinaan': 'Judul B',
        'bukti_dukung_undangan_pembinaan': 'undangan.pdf',
        'daftar_hadir_pembinaan': 'hadir.pdf',
        'materi_pembinaan': 'materi.pdf',
        'notula_pembinaan': 'notula.pdf',
        'created_at': '2026-03-13T01:02:03.000000Z',
        'updated_at': '2026-03-13T01:02:03.000000Z',
      });

      expect(model.id, '1');
      expect(model.files, isEmpty);
    });

    test('parses detail payload with integer media ids', () {
      final model = Pembinaan.fromJson({
        'id': 1,
        'created_by_id': 2,
        'directory_pembinaan': 'dir-b',
        'judul_pembinaan': 'Judul B',
        'bukti_dukung_undangan_pembinaan': 'undangan.pdf',
        'daftar_hadir_pembinaan': 'hadir.pdf',
        'materi_pembinaan': 'materi.pdf',
        'notula_pembinaan': 'notula.pdf',
        'file_pembinaan': [
          {
            'id': 10,
            'pembinaan_id': 1,
            'nama_file': 'media/b.jpg',
            'tipe_file': 'jpg',
            'created_at': '2026-03-13T01:02:03.000000Z',
            'updated_at': '2026-03-13T01:02:03.000000Z',
          },
        ],
        'created_at': '2026-03-13T01:02:03.000000Z',
        'updated_at': '2026-03-13T01:02:03.000000Z',
      });

      expect(model.files.single.id, '10');
      expect(model.files.single.pembinaanId, '1');
    });
  });
}
