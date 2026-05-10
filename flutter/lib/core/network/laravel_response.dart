import 'paginated_response.dart';

class LaravelResponseFormatException implements Exception {
  LaravelResponseFormatException(this.message);
  final String message;

  @override
  String toString() => 'LaravelResponseFormatException: $message';
}

List<T> parseLaravelPaginatedList<T>(
  dynamic json,
  T Function(Map<String, dynamic>) fromJson, {
  required String label,
}) {
  if (json is! Map) {
    throw LaravelResponseFormatException(
      '$label expected a JSON object but got ${json.runtimeType}',
    );
  }

  final data = json['data'];
  if (data is! List) {
    throw LaravelResponseFormatException(
      '$label expected `data` to be a List but got ${data.runtimeType}',
    );
  }

  return data.map((e) => fromJson((e as Map).cast<String, dynamic>())).toList();
}

PaginatedResponse<T> parseLaravelPaginatedResponse<T>(
  dynamic json,
  T Function(Map<String, dynamic>) fromJson, {
  required String label,
}) {
  if (json is! Map) {
    throw LaravelResponseFormatException(
      '$label expected a JSON object but got ${json.runtimeType}',
    );
  }

  final root = json.cast<String, dynamic>();
  final normalizedRoot = _normalizeLaravelPaginatedPayload(root);

  try {
    return PaginatedResponse<T>.fromJson(
      normalizedRoot,
      (item) => fromJson((item as Map).cast<String, dynamic>()),
    );
  } catch (error) {
    throw LaravelResponseFormatException(
      '$label failed to parse paginated response: $error',
    );
  }
}

Map<String, dynamic> _normalizeLaravelPaginatedPayload(
  Map<String, dynamic> root,
) {
  final hasNestedMeta =
      root['meta'] is Map<String, dynamic> || root['meta'] is Map;
  final hasNestedLinks =
      root['links'] is Map<String, dynamic> || root['links'] is Map;

  if (hasNestedMeta && hasNestedLinks) {
    return root;
  }

  if (hasNestedMeta) {
    final meta = (root['meta'] as Map).cast<String, dynamic>();
    return <String, dynamic>{
      'data': root['data'] ?? const <dynamic>[],
      'meta': <String, dynamic>{
        'current_page': meta['current_page'] ?? 1,
        'last_page': meta['last_page'] ?? 1,
        'per_page': meta['per_page'] ?? 10,
        'total': meta['total'] ?? 0,
        'from': meta['from'],
        'to': meta['to'],
        'path': meta['path'] ?? '',
      },
      'links': const <String, dynamic>{'first': '', 'last': ''},
    };
  }

  return <String, dynamic>{
    'data': root['data'] ?? const <dynamic>[],
    'meta': <String, dynamic>{
      'current_page': root['current_page'] ?? 1,
      'last_page': root['last_page'] ?? 1,
      'per_page': root['per_page'] ?? 10,
      'total': root['total'] ?? 0,
      'from': root['from'],
      'to': root['to'],
      'path': root['path'] ?? '',
    },
    'links': <String, dynamic>{
      'first': root['first_page_url'] ?? '',
      'last': root['last_page_url'] ?? '',
      'prev': root['prev_page_url'],
      'next': root['next_page_url'],
    },
  };
}

/// Extracts the inner `data` map from a Laravel-style response, falling back
/// to the response itself when there is no envelope. Throws if the payload is
/// not a map.
Map<String, dynamic> extractMapData(dynamic responseData) {
  if (responseData is Map<String, dynamic>) {
    final dynamic data = responseData['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return responseData;
  }
  throw const FormatException('Unexpected API response format');
}

/// Extracts the inner `data` list from a Laravel-style response, returning an
/// empty list when no list is found.
List<dynamic> extractListData(dynamic responseData) {
  if (responseData is List<dynamic>) {
    return responseData;
  }
  if (responseData is Map<String, dynamic>) {
    final dynamic data = responseData['data'];
    if (data is List<dynamic>) {
      return data;
    }
  }
  return const <dynamic>[];
}

double? parseNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

T parseLaravelResourceObject<T>(
  dynamic json,
  T Function(Map<String, dynamic>) fromJson, {
  required String label,
}) {
  if (json is! Map) {
    throw LaravelResponseFormatException(
      '$label expected a JSON object but got ${json.runtimeType}',
    );
  }

  final root = json.cast<String, dynamic>();
  final dynamic data = root['data'];

  if (data == null) {
    return fromJson(root);
  }

  if (data is! Map) {
    throw LaravelResponseFormatException(
      '$label expected `data` to be a JSON object but got ${data.runtimeType}',
    );
  }

  return fromJson(data.cast<String, dynamic>());
}
