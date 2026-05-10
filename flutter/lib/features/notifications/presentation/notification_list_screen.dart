import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/helpers/async_view.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_card.dart';

import '../domain/notification_model.dart';
import 'notification_controller.dart';
import 'notification_inbox_state.dart';

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() =>
      _NotificationListScreenState();
}

class _NotificationListScreenState
    extends ConsumerState<NotificationListScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final currentState = ref.read(notificationControllerProvider).value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasNextPage) {
      return;
    }

    final triggerOffset = _scrollController.position.maxScrollExtent - 160;
    if (_scrollController.position.pixels >= triggerOffset) {
      ref.read(notificationControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _runAction(
    BuildContext context,
    Future<void> Function() action, {
    required String successMessage,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
      if (!mounted) {
        return;
      }
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal memproses notifikasi: $error')),
      );
    }
  }

  Future<bool> _confirmDeleteNotification(
    BuildContext context,
    AppNotification notification,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Hapus notifikasi?'),
            content: Text(
              'Notifikasi "${notification.title}" akan disembunyikan dari inbox.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      return false;
    }

    try {
      await ref
          .read(notificationControllerProvider.notifier)
          .deleteNotification(notification.id);
      if (!mounted) {
        return true;
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('Notifikasi dihapus dari inbox')),
      );
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }
      messenger.showSnackBar(
        SnackBar(content: Text('Gagal menghapus notifikasi: $error')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationControllerProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.checkCheck),
            onPressed: () => _runAction(
              context,
              () => ref
                  .read(notificationControllerProvider.notifier)
                  .markAllAsRead(),
              successMessage: 'Semua notifikasi ditandai sudah dibaca',
            ),
            tooltip: 'Tandai semua sudah dibaca',
          ),
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical, size: 20),
            onSelected: (value) {
              if (value != 'delete_read') {
                return;
              }

              _runAction(
                context,
                () => ref
                    .read(notificationControllerProvider.notifier)
                    .deleteReadNotifications(),
                successMessage: 'Semua notifikasi yang sudah dibaca dihapus',
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'delete_read',
                child: Text('Hapus yang sudah dibaca'),
              ),
            ],
          ),
        ],
      ),
      body: asyncView<NotificationInboxState>(
        notificationsAsync,
        onRetry: () =>
            ref.read(notificationControllerProvider.notifier).refresh(),
        data: (inboxState) {
          if (inboxState.notifications.isEmpty) {
            return _buildEmptyState(context, textTheme, inboxState);
          }

          final entries = _buildEntries(inboxState.notifications);
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(notificationControllerProvider.notifier).refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              itemCount: entries.length + 1,
              itemBuilder: (context, index) {
                if (index == entries.length) {
                  return _buildLoadMoreFooter(inboxState);
                }

                final entry = entries[index];
                if (entry.header != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 12),
                    child: Text(
                      entry.header!.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.sogan.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  );
                }

                return _buildNotificationItem(context, entry.notification!);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    TextTheme textTheme,
    NotificationInboxState inboxState,
  ) {
    final title = inboxState.hasMutated
        ? 'Inbox notifikasi sudah bersih'
        : 'Belum ada notifikasi';
    final subtitle = inboxState.hasMutated
        ? 'Notifikasi yang Anda hapus tidak lagi tampil di inbox.'
        : 'Notifikasi OPD akan muncul di sini saat ada aktivitas baru.';

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(notificationControllerProvider.notifier).refresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.bellOff,
                    size: 64,
                    color: AppTheme.sogan.withValues(alpha: 0.2),
                  ),
                  AppSpacing.gapH16,
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppTheme.neutral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.gapH8,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppTheme.sogan.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    AppNotification notification,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Dismissible(
      key: ValueKey('notification-${notification.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDeleteNotification(context, notification),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.error.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(LucideIcons.trash2, color: Colors.white),
      ),
      child: EthnoCard(
        isFlat: true,
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.zero,
        onTap: () {
          ref
              .read(notificationControllerProvider.notifier)
              .markAsRead(notification.id);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : AppTheme.info.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? AppTheme.merang
                        : AppTheme.gold.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification.isRead
                        ? LucideIcons.bell
                        : LucideIcons.bellRing,
                    color: notification.isRead
                        ? AppTheme.sogan.withValues(alpha: 0.5)
                        : AppTheme.sogan,
                    size: 22,
                  ),
                ),
                if (!notification.isRead)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              notification.title,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: notification.isRead
                    ? FontWeight.w600
                    : FontWeight.w800,
                color: AppTheme.sogan,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.gapH4,
                Text(
                  notification.body,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppTheme.sogan.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                AppSpacing.gapH8,
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 12,
                      color: AppTheme.sogan.withValues(alpha: 0.4),
                    ),
                    AppSpacing.gapW4,
                    Text(
                      DateFormat('HH:mm').format(notification.createdAt),
                      style: textTheme.labelSmall?.copyWith(
                        color: AppTheme.sogan.withValues(alpha: 0.45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreFooter(NotificationInboxState inboxState) {
    if (inboxState.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: CircularProgressIndicator(
            key: Key('notification-load-more-indicator'),
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.sogan),
          ),
        ),
      );
    }

    if (inboxState.hasNextPage) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('Memuat notifikasi berikutnya...')),
      );
    }

    return const SizedBox(height: 12);
  }

  List<_NotificationListEntry> _buildEntries(
    List<AppNotification> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<AppNotification>>{};

    for (final notification in notifications) {
      final notifDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      String key;
      if (notifDate == today) {
        key = 'Hari ini';
      } else if (notifDate == yesterday) {
        key = 'Kemarin';
      } else {
        key = 'Minggu lalu';
      }

      groups.putIfAbsent(key, () => []).add(notification);
    }

    final entries = <_NotificationListEntry>[];
    for (final entry in groups.entries) {
      entries.add(_NotificationListEntry.header(entry.key));
      for (final notification in entry.value) {
        entries.add(_NotificationListEntry.notification(notification));
      }
    }

    return entries;
  }
}

class _NotificationListEntry {
  const _NotificationListEntry._({this.header, this.notification});

  const _NotificationListEntry.header(String header) : this._(header: header);

  const _NotificationListEntry.notification(AppNotification notification)
    : this._(notification: notification);

  final String? header;
  final AppNotification? notification;
}
