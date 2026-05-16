import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';

typedef _ErrorWidgetBuilder = Widget Function(FlutterErrorDetails details);

class GlobalErrorBoundary extends StatefulWidget {
  const GlobalErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  final Widget child;
  final Widget Function(FlutterErrorDetails details)? errorBuilder;

  @override
  State<GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<GlobalErrorBoundary> {
  late final _ErrorWidgetBuilder _previousBuilder;

  @override
  void initState() {
    super.initState();
    _previousBuilder = ErrorWidget.builder;

    ErrorWidget.builder = (FlutterErrorDetails details) {
      final builder = widget.errorBuilder;
      if (builder != null) {
        return builder(details);
      }

      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.alertCircle,
                  color: Theme.of(context).colorScheme.error,
                  size: 64,
                ),
                AppSpacing.gapH16,
                Text(
                  'Terjadi Kesalahan Kritis',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                AppSpacing.gapH8,
                const Text(
                  'Aplikasi mengalami masalah teknis. Silakan coba buka kembali aplikasi.',
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapH24,
                EthnoButton(
                  onPressed: () {
                    // Logika untuk mencoba kembali atau restart
                  },
                  label: 'Tutup Aplikasi',
                  style: EthnoButtonStyle.primary,
                ),
              ],
            ),
          ),
        ),
      );
    };
  }

  @override
  void dispose() {
    ErrorWidget.builder = _previousBuilder;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
