enum AdminAssessmentProgressSortBy {
  date('tanggal'),
  name('nama'),
  opdProgress('progress_opd'),
  walidataProgress('progress_walidata');

  const AdminAssessmentProgressSortBy(this.apiValue);

  final String apiValue;

  String get label => switch (this) {
    AdminAssessmentProgressSortBy.date => 'Tanggal',
    AdminAssessmentProgressSortBy.name => 'Nama',
    AdminAssessmentProgressSortBy.opdProgress => 'Progress OPD',
    AdminAssessmentProgressSortBy.walidataProgress => 'Progress Walidata',
  };
}

enum SortDirection {
  asc('asc'),
  desc('desc');

  const SortDirection(this.apiValue);

  final String apiValue;
}

class AdminAssessmentProgressQuery {
  const AdminAssessmentProgressQuery({
    this.search = '',
    this.sortBy = AdminAssessmentProgressSortBy.date,
    this.sortDirection = SortDirection.desc,
    this.page = 1,
    this.perPage = 10,
  });

  final String search;
  final AdminAssessmentProgressSortBy sortBy;
  final SortDirection sortDirection;
  final int page;
  final int perPage;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'search': search,
      'sort_by': sortBy.apiValue,
      'sort_direction': sortDirection.apiValue,
    };
  }

  AdminAssessmentProgressQuery copyWith({
    String? search,
    AdminAssessmentProgressSortBy? sortBy,
    SortDirection? sortDirection,
    int? page,
    int? perPage,
  }) {
    return AdminAssessmentProgressQuery(
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
