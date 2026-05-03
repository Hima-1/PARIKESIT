import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/features/assessment/domain/opd_model.dart';

void main() {
  group('OpdModel.fromJson', () {
    test('parses nested assessment progress stats', () {
      final model = OpdModel.fromJson(const <String, dynamic>{
        'id': 7,
        'name': 'Dinas Kominfo',
        'role': 'opd',
        'nomor_telepon': '08123456789',
        'stats': <String, dynamic>{
          'total_indikator': 5,
          'opd_progress': <String, dynamic>{'count': 5, 'percentage': 100},
          'walidata_progress': <String, dynamic>{'count': 2, 'percentage': 40},
          'admin_progress': <String, dynamic>{'count': 1, 'percentage': 20},
        },
      });

      expect(model.totalIndicators, 5);
      expect(model.opdProgress?.count, 5);
      expect(model.opdProgress?.percentage, 100);
      expect(model.walidataProgress?.count, 2);
      expect(model.walidataProgress?.percentage, 40);
      expect(model.adminProgress?.count, 1);
      expect(model.adminProgress?.percentage, 20);
    });

    test('keeps legacy payload without stats compatible', () {
      final model = OpdModel.fromJson(const <String, dynamic>{
        'id': 7,
        'name': 'Dinas Kominfo',
        'role': 'opd',
        'opd_score': 3.2,
        'walidata_score': 3.4,
        'admin_score': 3.6,
      });

      expect(model.opdScore, 3.2);
      expect(model.walidataScore, 3.4);
      expect(model.adminScore, 3.6);
      expect(model.totalIndicators, 0);
      expect(model.opdProgress, isNull);
      expect(model.walidataProgress, isNull);
      expect(model.adminProgress, isNull);
    });
  });
}
