import '../data/admin_user_repository.dart';

enum AdminActivitySortField {
  createdAt('created_at', 'Terbaru'),
  title('title', 'Judul');

  const AdminActivitySortField(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class AdminActivityQuery {
  const AdminActivityQuery({
    this.search = '',
    this.sort = AdminActivitySortField.createdAt,
    this.direction = SortDirection.desc,
    this.page = 1,
    this.perPage = 10,
  });

  final String search;
  final AdminActivitySortField sort;
  final SortDirection direction;
  final int page;
  final int perPage;

  AdminActivityQuery copyWith({
    String? search,
    AdminActivitySortField? sort,
    SortDirection? direction,
    int? page,
    int? perPage,
  }) {
    return AdminActivityQuery(
      search: search ?? this.search,
      sort: sort ?? this.sort,
      direction: direction ?? this.direction,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
