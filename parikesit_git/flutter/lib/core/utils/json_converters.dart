import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

class FlexibleDoubleConverter implements JsonConverter<double, Object?> {
  const FlexibleDoubleConverter();

  @override
  double fromJson(Object? json) {
    if (json is num) {
      return json.toDouble();
    }
    if (json is String) {
      final double? parsed = double.tryParse(json);
      if (parsed != null) {
        return parsed;
      }
    }

    throw FormatException('Cannot convert $json to double');
  }

  @override
  Object toJson(double object) => object;
}

class NullableFlexibleDoubleConverter
    implements JsonConverter<double?, Object?> {
  const NullableFlexibleDoubleConverter();

  @override
  double? fromJson(Object? json) {
    if (json == null) {
      return null;
    }

    return const FlexibleDoubleConverter().fromJson(json);
  }

  @override
  Object? toJson(double? object) => object;
}

class LaravelDateConverter implements JsonConverter<DateTime, String> {
  const LaravelDateConverter();

  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json).toLocal();
  }

  @override
  String toJson(DateTime object) {
    return object.toUtc().toIso8601String();
  }
}

class NullableLaravelDateConverter
    implements JsonConverter<DateTime?, String?> {
  const NullableLaravelDateConverter();

  @override
  DateTime? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    return const LaravelDateConverter().fromJson(json);
  }

  @override
  String? toJson(DateTime? object) {
    if (object == null) return null;
    return const LaravelDateConverter().toJson(object);
  }
}

class FlexibleStringConverter implements JsonConverter<String, Object?> {
  const FlexibleStringConverter();

  @override
  String fromJson(Object? json) {
    if (json == null) return '';
    return json.toString();
  }

  @override
  Object? toJson(String object) => object;
}

class NullableEvidenceListConverter
    implements JsonConverter<List<String>?, Object?> {
  const NullableEvidenceListConverter();

  @override
  List<String>? fromJson(Object? json) {
    if (json == null) {
      return null;
    }

    if (json is List) {
      final List<String> values = json
          .map((Object? item) => item?.toString().trim())
          .whereType<String>()
          .where((String item) => item.isNotEmpty && item != '-')
          .toList(growable: false);
      return values.isEmpty ? null : values;
    }

    if (json is String) {
      final String trimmed = json.trim();
      if (trimmed.isEmpty || trimmed == '-') {
        return null;
      }

      try {
        final dynamic decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return fromJson(decoded);
        }
      } catch (_) {
        return <String>[trimmed];
      }

      return <String>[trimmed];
    }

    return <String>[json.toString()];
  }

  @override
  Object? toJson(List<String>? object) {
    if (object == null || object.isEmpty) {
      return null;
    }

    return object;
  }
}
