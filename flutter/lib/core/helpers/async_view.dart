import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_error_mapper.dart';
import '../widgets/app_error_state.dart';
import '../widgets/app_loading_state.dart';

/// Renders an [AsyncValue] with the project's standard loading/error
/// widgets while letting callers focus on the data path.
///
/// Use this in screen [build] methods so empty/error/loading visuals stay
/// consistent without each screen reinventing the boilerplate. Pass
/// [skeleton] to override the default spinner with a layout-shaped
/// skeleton, and [onRetry] to expose a retry action on error.
Widget asyncView<T>(
  AsyncValue<T> async, {
  required Widget Function(T data) data,
  Widget? skeleton,
  String errorFallback = 'Gagal memuat data. Silakan coba lagi.',
  VoidCallback? onRetry,
}) {
  return async.when(
    data: data,
    loading: () => skeleton ?? const AppLoadingState(),
    error: (err, _) => AppErrorState(
      message: AppErrorMapper.toMessage(err, fallbackMessage: errorFallback),
      onRetry: onRetry,
    ),
  );
}

/// Variant that wraps the rendered output in a sliver. Useful inside
/// [CustomScrollView]s.
Widget asyncSliver<T>(
  AsyncValue<T> async, {
  required Widget Function(T data) data,
  Widget? skeleton,
  String errorFallback = 'Gagal memuat data. Silakan coba lagi.',
  VoidCallback? onRetry,
}) {
  return SliverToBoxAdapter(
    child: asyncView<T>(
      async,
      data: data,
      skeleton: skeleton,
      errorFallback: errorFallback,
      onRetry: onRetry,
    ),
  );
}
