enum CompletedAssessmentSortField {
  createdAt('created_at', 'Tanggal'),
  name('nama_formulir', 'Nama formulir');

  const CompletedAssessmentSortField(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum CompletedAssessmentSortDirection {
  asc('asc'),
  desc('desc');

  const CompletedAssessmentSortDirection(this.apiValue);

  final String apiValue;
}

class CompletedAssessmentQuery {
  const CompletedAssessmentQuery({
    this.search = '',
    this.sort = CompletedAssessmentSortField.createdAt,
    this.direction = CompletedAssessmentSortDirection.desc,
    this.page = 1,
    this.perPage = 10,
  });

  final String search;
  final CompletedAssessmentSortField sort;
  final CompletedAssessmentSortDirection direction;
  final int page;
  final int perPage;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'sort': sort.apiValue,
      'direction': direction.apiValue,
      if (search.trim().isNotEmpty) 'search': search.trim(),
    };
  }

  CompletedAssessmentQuery copyWith({
    String? search,
    CompletedAssessmentSortField? sort,
    CompletedAssessmentSortDirection? direction,
    int? page,
    int? perPage,
  }) {
    return CompletedAssessmentQuery(
      search: search ?? this.search,
      sort: sort ?? this.sort,
      direction: direction ?? this.direction,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
