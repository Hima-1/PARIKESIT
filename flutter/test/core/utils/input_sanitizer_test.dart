import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/utils/input_sanitizer.dart';

void main() {
  group('InputSanitizer', () {
    test('normalizes plain text whitespace and removes control characters', () {
      expect(
        InputSanitizer.trimPlainText('  Nama\tUser\x00\nBaru  '),
        'Nama User Baru',
      );
    });

    test('returns null for empty nullable text', () {
      expect(InputSanitizer.nullableTrimmed('   '), isNull);
    });

    test('normalizes email and phone values', () {
      expect(
        InputSanitizer.normalizeEmail('  USER@Example.COM  '),
        'user@example.com',
      );
      expect(InputSanitizer.normalizePhone(' 08ab12-34<script> '), '0812-34');
    });

    test('limits normalized text length', () {
      expect(InputSanitizer.trimPlainText('abcdef', maxLength: 3), 'abc');
    });
  });
}
