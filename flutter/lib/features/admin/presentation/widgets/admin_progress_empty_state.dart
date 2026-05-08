import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/widgets/app_empty_state.dart';

class AdminProgressEmptyState extends StatelessWidget {
  const AdminProgressEmptyState({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: 'Tidak Ada Data',
      message: message,
      actionLabel: onRetry != null ? 'Coba lagi' : null,
      onAction: onRetry,
      icon: LucideIcons.clipboardX,
    );
  }
}
