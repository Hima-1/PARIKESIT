import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/paginated_response.dart';
import '../theme/app_spacing.dart';
import 'app_empty_state.dart';
import 'app_error_state.dart';
import 'app_pagination_footer.dart';
import 'skeleton_loader.dart';

/// Renders an [AsyncValue] of [PaginatedResponse] with a consistent
/// loading/empty/error/data lifecycle and the standard pagination footer.
///
/// Screens that just need "list of T plus paginate buttons" should use
/// this widget instead of duplicating the loading-skeleton + empty-state +
/// error-retry + footer wiring on every list view.
class PagedListView<T> extends StatelessWidget {
  const PagedListView({
    super.key,
    required this.async,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onPrevious,
    required this.onNext,
    this.emptyTitle = 'Belum ada data',
    this.emptyMessage = 'Data akan muncul di sini setelah tersedia.',
    this.errorFallbackMessage = 'Gagal memuat data. Silakan coba lagi.',
    this.padding = AppSpacing.pAll16,
    this.separator,
    this.skeleton,
    this.onRetry,
  });

  final AsyncValue<PaginatedResponse<T>> async;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Future<void> Function() onRefresh;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String emptyTitle;
  final String emptyMessage;
  final String errorFallbackMessage;
  final EdgeInsetsGeometry padding;
  final Widget? separator;
  final Widget? skeleton;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => skeleton ?? const AssessmentListSkeleton(),
      error: (err, _) => RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.6,
              child: AppErrorState(
                message: err.toString().isEmpty
                    ? errorFallbackMessage
                    : errorFallbackMessage,
                onRetry: onRetry,
              ),
            ),
          ],
        ),
      ),
      data: (page) {
        if (page.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: AppEmptyState(
                    title: emptyTitle,
                    message: emptyMessage,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: padding,
                  itemCount: page.items.length,
                  separatorBuilder: (_, _) => separator ?? AppSpacing.gapH12,
                  itemBuilder: (context, index) =>
                      itemBuilder(context, page.items[index]),
                ),
              ),
              if (page.meta.lastPage > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AppPaginationFooter(
                    currentPage: page.meta.currentPage,
                    lastPage: page.meta.lastPage,
                    hasPreviousPage: page.hasPreviousPage,
                    hasNextPage: page.hasNextPage,
                    onPrevious: onPrevious,
                    onNext: onNext,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
