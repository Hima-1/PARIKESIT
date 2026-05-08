import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'ethno_patterns.dart';

class EthnoCard extends StatelessWidget {
  const EthnoCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.showBatikAccent = false,
    this.onTap,
    this.borderRadius = AppTheme.borderRadius,
    this.elevation = 0,
    this.isFlat = true,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBatikAccent;
  final VoidCallback? onTap;
  final double borderRadius;
  final double elevation;
  final bool isFlat;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    Widget current = Padding(
      padding: padding ?? AppSpacing.pAll16,
      child: child,
    );

    if (showBatikAccent) {
      current = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: CustomPaint(
                size: const Size(100, 100),
                painter: KawungPainter(
                  color: AppTheme.sogan,
                  opacity: 0.04,
                  size: 40,
                ),
              ),
            ),
            current,
          ],
        ),
      );
    }

    final card = Card(
      elevation: 0,
      margin: margin ?? AppSpacing.pV8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor ?? AppTheme.borderColor,
          width: AppTheme.hairline,
        ),
      ),
      color: AppTheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: current,
      ),
    );

    return card;
  }
}
