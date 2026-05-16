class InputSanitizer {
  const InputSanitizer._();

  static String trimPlainText(String value, {int maxLength = 2000}) {
    final withoutControlChars = value.replaceAll(
      RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'),
      '',
    );
    final normalized = withoutControlChars
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (maxLength > 0 && normalized.length > maxLength) {
      return normalized.substring(0, maxLength);
    }

    return normalized;
  }

  static String? nullableTrimmed(String value, {int maxLength = 2000}) {
    final sanitized = trimPlainText(value, maxLength: maxLength);

    return sanitized.isEmpty ? null : sanitized;
  }

  static String normalizeEmail(String value) {
    return trimPlainText(value, maxLength: 255).toLowerCase();
  }

  static String normalizePhone(String value) {
    final sanitized = trimPlainText(
      value,
      maxLength: 0,
    ).replaceAll(RegExp(r'[^0-9+()\-\s]'), '');
    final normalized = sanitized.replaceAll(RegExp(r'\s+'), ' ').trim();

    return normalized.length > 20 ? normalized.substring(0, 20) : normalized;
  }
}
