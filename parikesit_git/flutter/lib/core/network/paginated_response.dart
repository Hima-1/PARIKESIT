import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_response.freezed.dart';
part 'paginated_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginatedResponse<T> with _$PaginatedResponse<T> {
  const factory PaginatedResponse({
    required List<T> data,
    required PaginationMeta meta,
    required PaginationLinks links,
  }) = _PaginatedResponse<T>;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PaginatedResponseFromJson(json, fromJsonT);
}

extension PaginatedResponseX<T> on PaginatedResponse<T> {
  List<T> get items => data;
  bool get hasNextPage => meta.currentPage < meta.lastPage;
  bool get hasPreviousPage => meta.currentPage > 1;
  bool get isEmpty => data.isEmpty;
}

@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
    @JsonKey(name: 'per_page') required int perPage,
    required int total,
    @JsonKey(name: 'from') int? from,
    @JsonKey(name: 'to') int? to,
    required String path,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

@freezed
abstract class PaginationLinks with _$PaginationLinks {
  const factory PaginationLinks({
    required String first,
    required String last,
    String? prev,
    String? next,
  }) = _PaginationLinks;

  factory PaginationLinks.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinksFromJson(json);
}
