import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logger.dart';

abstract class BaseRepository {
  /// Safely execute a request and handle common errors/logging.
  Future<T> safeRequest<T>(
    Future<T> Function() request, {
    String? label,
  }) async {
    try {
      if (label != null) {
        AppLogger.debug('[$label] Starting request...');
      }
      final result = await request();
      if (label != null) {
        AppLogger.debug('[$label] Request successful.');
      }
      return result;
    } catch (e, stack) {
      if (label != null) {
        AppLogger.error('[$label] Request failed', e, stack);
      } else {
        AppLogger.error('Request failed', e, stack);
      }
      rethrow;
    }
  }

  /// Convert a future to an AsyncValue.
  Future<AsyncValue<T>> toAsyncValue<T>(Future<T> Function() request) async {
    try {
      final result = await request();
      return AsyncValue.data(result);
    } catch (e, stack) {
      return AsyncValue.error(e, stack);
    }
  }
}
