import '../../../core/network/paginated_response.dart';
import '../domain/notification_model.dart';

class NotificationInboxState {
  const NotificationInboxState({
    this.page,
    this.isLoadingMore = false,
    this.hasMutated = false,
  });

  final PaginatedResponse<AppNotification>? page;
  final bool isLoadingMore;
  final bool hasMutated;

  List<AppNotification> get notifications => page?.items ?? const [];
  bool get hasNextPage => page?.hasNextPage ?? false;
  int get currentPage => page?.meta.currentPage ?? 1;

  NotificationInboxState copyWith({
    PaginatedResponse<AppNotification>? page,
    bool? isLoadingMore,
    bool? hasMutated,
  }) {
    return NotificationInboxState(
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMutated: hasMutated ?? this.hasMutated,
    );
  }
}
