import '../data/admin_user_repository.dart';

class AdminUserQuery {
  const AdminUserQuery({
    this.search = '',
    this.sort = UserSortField.createdAt,
    this.direction = SortDirection.desc,
    this.page = 1,
    this.perPage = 15,
  });

  final String search;
  final UserSortField sort;
  final SortDirection direction;
  final int page;
  final int perPage;

  AdminUserQuery copyWith({
    String? search,
    UserSortField? sort,
    SortDirection? direction,
    int? page,
    int? perPage,
  }) {
    return AdminUserQuery(
      search: search ?? this.search,
      sort: sort ?? this.sort,
      direction: direction ?? this.direction,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
