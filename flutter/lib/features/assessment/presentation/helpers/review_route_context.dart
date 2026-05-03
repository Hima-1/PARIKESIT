import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String missingReviewOpdContextMessage =
    'Konteks OPD tidak tersedia. Buka ulang detail OPD untuk melanjutkan review.';

String? resolveReviewOpdId(
  BuildContext context, {
  required bool isSelfReview,
  String? opdId,
}) {
  if (isSelfReview) {
    return null;
  }

  final String? explicitOpdId = _normalizeOpdId(opdId);
  if (explicitOpdId != null) {
    return explicitOpdId;
  }

  try {
    return _normalizeOpdId(GoRouterState.of(context).pathParameters['opdId']);
  } catch (_) {
    return null;
  }
}

void showMissingReviewOpdContextFeedback(BuildContext context) {
  final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) {
    return;
  }

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(content: Text(missingReviewOpdContextMessage)),
    );
}

String? _normalizeOpdId(String? value) {
  final String? trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }

  return trimmed;
}
