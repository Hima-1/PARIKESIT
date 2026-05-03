import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/utils/json_converters.dart';
import 'package:parikesit/features/assessment/domain/assessment_indikator.dart';
import 'package:parikesit/features/assessment/domain/penilaian.dart';

void main() {
  group('LaravelDateConverter', () {
    const converter = LaravelDateConverter();
    const nullableConverter = NullableLaravelDateConverter();

    test('should parse ISO-8601 with microseconds and UTC Z', () {
      const dateStr = '2023-10-05T14:48:00.000000Z';
      final result = converter.fromJson(dateStr);

      expect(result.year, 2023);
      expect(result.month, 10);
      expect(result.day, 5);
      expect(result.hour, 21); // In +7 (Local)
      expect(result.minute, 48);
    });

    test('should serialize to ISO-8601 string in UTC', () {
      final date = DateTime.utc(2023, 10, 5, 14, 48);
      final result = converter.toJson(date);

      expect(result, '2023-10-05T14:48:00.000Z');
    });

    test('should handle null for nullable converter', () {
      expect(nullableConverter.fromJson(null), null);
      expect(nullableConverter.fromJson(''), null);
      expect(nullableConverter.toJson(null), null);
    });
  });

  group('FlexibleDoubleConverter', () {
    test('should parse numeric strings', () {
      const converter = FlexibleDoubleConverter();

      expect(converter.fromJson('4.00'), 4.0);
      expect(converter.fromJson('2'), 2.0);
    });

    test('should allow Penilaian.fromJson when nilai is a string', () {
      final Penilaian penilaian = Penilaian.fromJson(<String, dynamic>{
        'id': 6,
        'formulir_id': 12,
        'indikator_id': 382,
        'nilai': '4.00',
        'catatan': 'ambatukam',
        'nilai_diupdate': '3.00',
        'diupdate_by': 9,
        'tanggal_diperbarui': '2026-03-14T10:30:00.000000Z',
        'nilai_koreksi': null,
      });

      expect(penilaian.nilai, 4.0);
      expect(penilaian.nilaiDiupdate, 3.0);
      expect(penilaian.diupdateBy, 9);
      expect(penilaian.tanggalDiperbarui, isNotNull);
      expect(penilaian.nilaiKoreksi, isNull);
    });

    test(
      'should allow AssessmentIndikator.fromJson when bobot_indikator is a string',
      () {
        final AssessmentIndikator indikator =
            AssessmentIndikator.fromJson(<String, dynamic>{
              'id': 1,
              'aspek_id': 2,
              'nama_indikator': 'Indikator',
              'bobot_indikator': '1.25',
            });

        expect(indikator.bobotIndikator, 1.25);
      },
    );
  });

  group('NullableEvidenceListConverter', () {
    test('should allow null bukti_dukung', () {
      final Penilaian penilaian = Penilaian.fromJson(<String, dynamic>{
        'id': 1,
        'formulir_id': 10,
        'indikator_id': 100,
        'nilai': 4,
        'bukti_dukung': null,
      });

      expect(penilaian.buktiDukung, isNull);
    });

    test(
      'should normalize plain string bukti_dukung into a single-item list',
      () {
        final Penilaian penilaian = Penilaian.fromJson(<String, dynamic>{
          'id': 2,
          'formulir_id': 10,
          'indikator_id': 100,
          'nilai': 4,
          'bukti_dukung': 'bukti-dukung/file.pdf',
        });

        expect(penilaian.buktiDukung, <String>['bukti-dukung/file.pdf']);
      },
    );

    test('should parse json array string bukti_dukung into a list', () {
      final Penilaian penilaian = Penilaian.fromJson(<String, dynamic>{
        'id': 3,
        'formulir_id': 10,
        'indikator_id': 100,
        'nilai': 4,
        'bukti_dukung': '["bukti-dukung/file.pdf"]',
      });

      expect(penilaian.buktiDukung, <String>['bukti-dukung/file.pdf']);
    });

    test('should keep list bukti_dukung as a list', () {
      final Penilaian penilaian = Penilaian.fromJson(<String, dynamic>{
        'id': 4,
        'formulir_id': 10,
        'indikator_id': 100,
        'nilai': 4,
        'bukti_dukung': <String>['bukti-dukung/file.pdf'],
      });

      expect(penilaian.buktiDukung, <String>['bukti-dukung/file.pdf']);
    });
  });
}
