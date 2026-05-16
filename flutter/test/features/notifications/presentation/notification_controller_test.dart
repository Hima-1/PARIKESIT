import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/notifications/data/notification_repository.dart';
import 'package:parikesit/features/notifications/domain/notification_model.dart';
import 'package:parikesit/features/notifications/presentation/notification_controller.dart';

void main() {
  group('NotificationController', () {
    test(
      'loads notifications from repository and updates unread count',
      () async {
        final repository = _FakeNotificationRepository([
          _notification(id: '1', isRead: false),
          _notification(id: '2', isRead: true),
        ]);
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final inbox = await container.read(
          notificationControllerProvider.future,
        );

        expect(inbox.notifications, hasLength(2));
        expect(container.read(unreadNotificationCountProvider), 1);
      },
    );

    test('markAsRead persists change through repository', () async {
      final repository = _FakeNotificationRepository([
        _notification(id: '1', isRead: false),
      ]);
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(notificationControllerProvider.future);
      await container
          .read(notificationControllerProvider.notifier)
          .markAsRead('1');

      final notifications = container
          .read(notificationControllerProvider)
          .value!
          .notifications;
      expect(notifications.single.isRead, isTrue);
      expect(repository.markedIds, ['1']);
    });

    test(
      'deleteNotification removes the item from the current state',
      () async {
        final repository = _FakeNotificationRepository([
          _notification(id: '1', isRead: false),
          _notification(id: '2', isRead: true),
        ]);
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificationControllerProvider.future);
        await container
            .read(notificationControllerProvider.notifier)
            .deleteNotification('1');

        final notifications = container
            .read(notificationControllerProvider)
            .value!
            .notifications;
        expect(notifications.map((item) => item.id), ['2']);
        expect(repository.deletedIds, ['1']);
      },
    );

    test(
      'deleteReadNotifications removes only read items from the state',
      () async {
        final repository = _FakeNotificationRepository([
          _notification(id: '1', isRead: false),
          _notification(id: '2', isRead: true),
        ]);
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificationControllerProvider.future);
        await container
            .read(notificationControllerProvider.notifier)
            .deleteReadNotifications();

        final notifications = container
            .read(notificationControllerProvider)
            .value!
            .notifications;
        expect(notifications.map((item) => item.id), ['1']);
        expect(repository.deletedReadCount, 1);
      },
    );

    test('loadMore appends the next page to the existing state', () async {
      final repository = _FakeNotificationRepository(
        [
          _notification(id: '1', isRead: false),
          _notification(id: '2', isRead: true),
        ],
        secondPage: [_notification(id: '3', isRead: false)],
      );
      final container = ProviderContainer(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(notificationControllerProvider.future);
      await container.read(notificationControllerProvider.notifier).loadMore();

      final notifications = container
          .read(notificationControllerProvider)
          .value!
          .notifications;
      expect(notifications.map((item) => item.id), ['1', '2', '3']);
      expect(repository.fetchedPages, [1, 2]);
    });

    test(
      'refreshSilently updates inbox and unread count without clearing current state',
      () async {
        final repository = _FakeNotificationRepository([
          _notification(id: '1', isRead: true),
        ]);
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        await container.read(notificationControllerProvider.future);
        repository.replaceFirstPage([
          _notification(id: '2', isRead: false),
          _notification(id: '3', isRead: false),
        ]);

        final refresh = container
            .read(notificationControllerProvider.notifier)
            .refreshSilently();

        expect(
          container
              .read(notificationControllerProvider)
              .value!
              .notifications
              .map((item) => item.id),
          ['1'],
        );

        await refresh;

        final notifications = container
            .read(notificationControllerProvider)
            .value!
            .notifications;
        expect(notifications.map((item) => item.id), ['2', '3']);
        expect(container.read(unreadNotificationCountProvider), 2);
      },
    );

    test(
      'stale refreshSilently response does not replace newer data',
      () async {
        final repository = _ControlledNotificationRepository();
        final container = ProviderContainer(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final initialLoad = container.read(
          notificationControllerProvider.future,
        );
        repository.completeFetch(0, [_notification(id: '1', isRead: false)]);
        await initialLoad;

        final staleRefresh = container
            .read(notificationControllerProvider.notifier)
            .refreshSilently();
        final freshRefresh = container
            .read(notificationControllerProvider.notifier)
            .refreshSilently();

        repository.completeFetch(2, [
          _notification(id: 'fresh', isRead: false),
        ]);
        await freshRefresh;

        repository.completeFetch(1, [
          _notification(id: 'stale', isRead: false),
        ]);
        await staleRefresh;

        final notifications = container
            .read(notificationControllerProvider)
            .value!
            .notifications;
        expect(notifications.map((item) => item.id), ['fresh']);
      },
    );
  });
}

class _FakeNotificationRepository extends NotificationRepository {
  _FakeNotificationRepository(
    this._notifications, {
    List<AppNotification>? secondPage,
  }) : secondPage = secondPage ?? <AppNotification>[],
       super(Dio());

  final List<AppNotification> _notifications;
  final List<AppNotification> secondPage;
  final List<String> markedIds = [];
  final List<String> deletedIds = [];
  int deletedReadCount = 0;
  final List<int> fetchedPages = [];

  void replaceFirstPage(List<AppNotification> notifications) {
    _notifications
      ..clear()
      ..addAll(notifications);
  }

  @override
  Future<PaginatedResponse<AppNotification>> fetchNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    fetchedPages.add(page);
    final items = page == 1 ? _notifications : secondPage;
    final lastPage = secondPage.isEmpty ? 1 : 2;

    return PaginatedResponse<AppNotification>(
      data: items.map((notification) => notification.copyWith()).toList(),
      meta: PaginationMeta(
        currentPage: page,
        lastPage: lastPage,
        perPage: perPage,
        total: _notifications.length + secondPage.length,
        from: items.isEmpty ? null : 1,
        to: items.isEmpty ? null : items.length,
        path: '/notifications',
      ),
      links: PaginationLinks(
        first: '/notifications?page=1',
        last: '/notifications?page=$lastPage',
        prev: page > 1 ? '/notifications?page=${page - 1}' : null,
        next: page < lastPage ? '/notifications?page=${page + 1}' : null,
      ),
    );
  }

  @override
  Future<AppNotification> markAsRead(String id) async {
    markedIds.add(id);
    final index = _notifications.indexWhere(
      (notification) => notification.id == id,
    );
    final updated = _notifications[index].copyWith(isRead: true);
    _notifications[index] = updated;
    return updated;
  }

  @override
  Future<void> markAllAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    deletedIds.add(id);
    _notifications.removeWhere((notification) => notification.id == id);
    secondPage.removeWhere((notification) => notification.id == id);
  }

  @override
  Future<void> deleteReadNotifications() async {
    final before = _notifications.length + secondPage.length;
    _notifications.removeWhere((notification) => notification.isRead);
    secondPage.removeWhere((notification) => notification.isRead);
    deletedReadCount = before - (_notifications.length + secondPage.length);
  }
}

class _ControlledNotificationRepository extends NotificationRepository {
  _ControlledNotificationRepository() : super(Dio());

  final List<int> fetchedPages = [];
  final List<Completer<PaginatedResponse<AppNotification>>> _requests = [];

  @override
  Future<PaginatedResponse<AppNotification>> fetchNotifications({
    int page = 1,
    int perPage = 10,
  }) {
    fetchedPages.add(page);
    final completer = Completer<PaginatedResponse<AppNotification>>();
    _requests.add(completer);

    return completer.future;
  }

  void completeFetch(int index, List<AppNotification> notifications) {
    _requests[index].complete(
      PaginatedResponse<AppNotification>(
        data: notifications,
        meta: PaginationMeta(
          currentPage: 1,
          lastPage: 1,
          perPage: 10,
          total: notifications.length,
          from: notifications.isEmpty ? null : 1,
          to: notifications.isEmpty ? null : notifications.length,
          path: '/notifications',
        ),
        links: const PaginationLinks(
          first: '/notifications?page=1',
          last: '/notifications?page=1',
        ),
      ),
    );
  }
}

AppNotification _notification({required String id, required bool isRead}) {
  return AppNotification(
    id: id,
    title: 'Reminder $id',
    body: 'Body $id',
    type: 'incomplete_form_reminder',
    data: const {
      'type': 'incomplete_form_reminder',
      'formulir_id': '10',
      'target_route': '/penilaian-kegiatan?formulirId=10',
    },
    createdAt: DateTime(2026, 3, 22, 9),
    isRead: isRead,
  );
}
