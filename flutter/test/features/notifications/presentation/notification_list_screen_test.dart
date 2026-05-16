import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/network/paginated_response.dart';
import 'package:parikesit/features/notifications/data/notification_repository.dart';
import 'package:parikesit/features/notifications/domain/notification_model.dart';
import 'package:parikesit/features/notifications/presentation/notification_list_screen.dart';

import '../../../helpers/test_wrapper.dart';

void main() {
  testWidgets('renders notifications from api-backed controller', (
    tester,
  ) async {
    final repository = _FakeNotificationRepository([
      AppNotification(
        id: '1',
        title: 'Reminder',
        body: 'Segera lengkapi formulir.',
        type: 'incomplete_form_reminder',
        data: const {
          'type': 'incomplete_form_reminder',
          'formulir_id': '7',
          'target_route': '/penilaian-kegiatan?formulirId=7',
        },
        createdAt: DateTime(2026, 3, 22, 9, 30),
      ),
    ]);

    await tester.pumpWidget(
      TestWrapper(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
        appShellBuilder: (child) => MaterialApp(home: child),
        child: const NotificationListScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Reminder'), findsOneWidget);
    expect(find.text('Segera lengkapi formulir.'), findsOneWidget);
    expect(find.text('Belum ada notifikasi'), findsNothing);
  });

  testWidgets('shows empty state and bulk delete action', (tester) async {
    final repository = _FakeNotificationRepository(const []);

    await tester.pumpWidget(
      TestWrapper(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
        appShellBuilder: (child) => MaterialApp(home: child),
        child: const NotificationListScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Belum ada notifikasi'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.moreVertical));
    await tester.pumpAndSettle();

    expect(find.text('Hapus yang sudah dibaca'), findsOneWidget);
  });

  testWidgets('bulk action failure shows friendly message', (tester) async {
    final repository = _FakeNotificationRepository(
      const [],
      throwOnDeleteRead: true,
    );

    await tester.pumpWidget(
      TestWrapper(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(repository),
        ],
        appShellBuilder: (child) => MaterialApp(home: child),
        child: const NotificationListScreen(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(LucideIcons.moreVertical));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus yang sudah dibaca'));
    await tester.pumpAndSettle();

    expect(
      find.text('Gagal memproses notifikasi. Silakan coba lagi.'),
      findsOneWidget,
    );
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('database failed'), findsNothing);
  });

  testWidgets(
    'pull to refresh works when notification list is not scrollable',
    (tester) async {
      final repository = _FakeNotificationRepository([
        AppNotification(
          id: '1',
          title: 'Reminder',
          body: 'Segera lengkapi formulir.',
          type: 'incomplete_form_reminder',
          data: const {
            'type': 'incomplete_form_reminder',
            'formulir_id': '7',
            'target_route': '/penilaian-kegiatan?formulirId=7',
          },
          createdAt: DateTime(2026, 3, 22, 9, 30),
        ),
      ]);

      await tester.pumpWidget(
        TestWrapper(
          overrides: [
            notificationRepositoryProvider.overrideWithValue(repository),
          ],
          appShellBuilder: (child) => MaterialApp(home: child),
          child: const NotificationListScreen(),
        ),
      );

      await tester.pumpAndSettle();
      expect(repository.fetchCount, 1);

      await tester.drag(find.byType(ListView), const Offset(0, 320));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(repository.fetchCount, 2);
    },
  );
}

class _FakeNotificationRepository extends NotificationRepository {
  _FakeNotificationRepository(
    this._notifications, {
    this.throwOnDeleteRead = false,
  }) : super(Dio());

  final List<AppNotification> _notifications;
  final bool throwOnDeleteRead;
  int fetchCount = 0;

  @override
  Future<PaginatedResponse<AppNotification>> fetchNotifications({
    int page = 1,
    int perPage = 10,
  }) async {
    fetchCount++;

    return PaginatedResponse<AppNotification>(
      data: _notifications,
      meta: PaginationMeta(
        currentPage: page,
        lastPage: 1,
        perPage: perPage,
        total: _notifications.length,
        from: _notifications.isEmpty ? null : 1,
        to: _notifications.length,
        path: '/notifications',
      ),
      links: const PaginationLinks(
        first: '/notifications?page=1',
        last: '/notifications?page=1',
      ),
    );
  }

  @override
  Future<AppNotification> markAsRead(String id) async {
    return _notifications.firstWhere((notification) => notification.id == id);
  }

  @override
  Future<void> deleteReadNotifications() async {
    if (throwOnDeleteRead) {
      throw Exception('database failed');
    }
  }
}
