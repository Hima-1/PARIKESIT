import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/paginated_response.dart';
import '../data/notification_repository.dart';
import '../domain/notification_model.dart';
import 'notification_inbox_state.dart';

class NotificationController extends AsyncNotifier<NotificationInboxState> {
  static const _perPage = 10;
  int _requestVersion = 0;

  @override
  Future<NotificationInboxState> build() async {
    return _fetchInitialPage();
  }

  Future<void> refresh() async {
    final requestVersion = ++_requestVersion;
    state = const AsyncValue.loading();
    final nextState = await AsyncValue.guard(_fetchInitialPage);
    if (requestVersion == _requestVersion) {
      state = nextState;
    }
  }

  Future<void> markAsRead(String id) async {
    final currentState = state.value;
    final currentList =
        currentState?.notifications ?? const <AppNotification>[];
    final target = currentList.where((notif) => notif.id == id).firstOrNull;
    if (currentState == null || target == null || target.isRead) {
      return;
    }

    final requestVersion = ++_requestVersion;
    final updated = await ref
        .read(notificationRepositoryProvider)
        .markAsRead(id);
    if (requestVersion != _requestVersion) {
      return;
    }

    final newList = currentList
        .map((notif) => notif.id == id ? updated : notif)
        .toList();

    state = AsyncValue.data(
      currentState.copyWith(
        page: _copyPageWithItems(currentState.page!, newList),
      ),
    );
  }

  Future<void> markAllAsRead() async {
    final currentState = state.value;
    if (currentState == null) {
      return;
    }

    final requestVersion = ++_requestVersion;
    await ref.read(notificationRepositoryProvider).markAllAsRead();
    if (requestVersion != _requestVersion) {
      return;
    }

    final newList = currentState.notifications
        .map((notif) => notif.copyWith(isRead: true))
        .toList();

    state = AsyncValue.data(
      currentState.copyWith(
        page: _copyPageWithItems(currentState.page!, newList),
      ),
    );
  }

  Future<void> deleteNotification(String id) async {
    final currentState = state.value;
    if (currentState == null) {
      return;
    }

    final existing = currentState.notifications;
    final updatedList = existing
        .where((notification) => notification.id != id)
        .toList();
    if (updatedList.length == existing.length) {
      return;
    }

    final requestVersion = ++_requestVersion;
    state = AsyncValue.data(
      currentState.copyWith(
        page: _copyPageWithItems(
          currentState.page!,
          updatedList,
          totalDelta: -1,
        ),
        hasMutated: true,
      ),
    );

    try {
      await ref.read(notificationRepositoryProvider).deleteNotification(id);
      if (requestVersion != _requestVersion) {
        return;
      }

      final latestState = state.value;
      if (latestState != null &&
          latestState.notifications.isEmpty &&
          latestState.currentPage > 1) {
        final nextState = await AsyncValue.guard(
          () => _reloadLoadedPages(
            targetPageCount: latestState.currentPage - 1,
            hasMutated: true,
          ),
        );
        if (requestVersion == _requestVersion) {
          state = nextState;
        }
      }
    } catch (_) {
      if (requestVersion == _requestVersion) {
        state = AsyncValue.data(currentState);
      }
      rethrow;
    }
  }

  Future<void> deleteReadNotifications() async {
    final currentState = state.value;
    if (currentState == null) {
      return;
    }

    final requestVersion = ++_requestVersion;
    await ref.read(notificationRepositoryProvider).deleteReadNotifications();
    final nextState = await AsyncValue.guard(
      () => _reloadLoadedPages(
        targetPageCount: currentState.currentPage,
        hasMutated: true,
      ),
    );
    if (requestVersion == _requestVersion) {
      state = nextState;
    }
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasNextPage) {
      return;
    }

    final requestVersion = ++_requestVersion;
    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));
    try {
      final nextPage = await ref
          .read(notificationRepositoryProvider)
          .fetchNotifications(
            page: currentState.currentPage + 1,
            perPage: _perPage,
          );
      if (requestVersion != _requestVersion) {
        return;
      }

      final mergedPage = nextPage.copyWith(
        data: [...currentState.notifications, ...nextPage.items],
      );
      state = AsyncValue.data(
        currentState.copyWith(page: mergedPage, isLoadingMore: false),
      );
    } catch (_) {
      if (requestVersion == _requestVersion) {
        state = AsyncValue.data(currentState.copyWith(isLoadingMore: false));
      }
      rethrow;
    }
  }

  Future<NotificationInboxState> _fetchInitialPage() async {
    final page = await ref
        .read(notificationRepositoryProvider)
        .fetchNotifications(page: 1, perPage: _perPage);
    return NotificationInboxState(page: page);
  }

  Future<NotificationInboxState> _reloadLoadedPages({
    required int targetPageCount,
    bool hasMutated = false,
  }) async {
    var mergedPage = await ref
        .read(notificationRepositoryProvider)
        .fetchNotifications(page: 1, perPage: _perPage);

    final safeTargetPageCount = targetPageCount < 1 ? 1 : targetPageCount;
    while (mergedPage.hasNextPage &&
        mergedPage.meta.currentPage < safeTargetPageCount) {
      final nextPage = await ref
          .read(notificationRepositoryProvider)
          .fetchNotifications(
            page: mergedPage.meta.currentPage + 1,
            perPage: _perPage,
          );
      mergedPage = nextPage.copyWith(
        data: [...mergedPage.items, ...nextPage.items],
      );
    }

    return NotificationInboxState(page: mergedPage, hasMutated: hasMutated);
  }

  PaginatedResponse<AppNotification> _copyPageWithItems(
    PaginatedResponse<AppNotification> page,
    List<AppNotification> items, {
    int totalDelta = 0,
  }) {
    final nextTotal = page.meta.total + totalDelta;
    final safeTotal = nextTotal < 0 ? 0 : nextTotal;

    return page.copyWith(
      data: items,
      meta: page.meta.copyWith(
        total: safeTotal,
        from: items.isEmpty ? null : 1,
        to: items.isEmpty ? null : items.length,
      ),
    );
  }
}

final notificationControllerProvider =
    AsyncNotifierProvider<NotificationController, NotificationInboxState>(() {
      return NotificationController();
    });

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications =
      ref.watch(notificationControllerProvider).value?.notifications ??
      const <AppNotification>[];
  return notifications.where((n) => !n.isRead).length;
});
