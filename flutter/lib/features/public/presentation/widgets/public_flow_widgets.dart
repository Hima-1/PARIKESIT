import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_patterns.dart';

bool _isCompactWidth(double width) => width < 600;

/// Drop-in fade + slight slide-up reveal, sequenced via [delay].
class PublicStaggeredReveal extends StatelessWidget {
  const PublicStaggeredReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
  });

  final Widget child;
  final Duration delay;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.06,
          end: 0,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
  }
}

/// Surface used by every section on the public landing — flat white card,
/// hairline border, no thick shadow.
class PublicSectionShell extends StatelessWidget {
  const PublicSectionShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
    this.borderRadius = AppTheme.radiusMd,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: AppTheme.hairlineBorder,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Hero panel — Sogan brown gradient with subtle Kawung pattern overlay.
class PublicHeroPanel extends StatelessWidget {
  const PublicHeroPanel({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.chips,
    required this.primaryAction,
    this.actionsAlignment = WrapAlignment.start,
    this.secondaryAction,
    this.aside,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<String> chips;
  final Widget primaryAction;
  final WrapAlignment actionsAlignment;
  final Widget? secondaryAction;
  final Widget? aside;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = _isCompactWidth(constraints.maxWidth);
        final EdgeInsets contentPadding = EdgeInsets.all(isCompact ? 24 : 32);

        return ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.soganDeep,
                        AppTheme.soganBrown,
                        AppTheme.terracotta,
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: KawungPainter(
                      color: Colors.white,
                      opacity: isCompact ? 0.05 : 0.07,
                      size: isCompact ? 64 : 96,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: contentPadding,
                child: LayoutBuilder(
                  builder: (context, innerConstraints) {
                    final bool isWide = innerConstraints.maxWidth >= 720;
                    final Widget content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eyebrow,
                          style: textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        AppSpacing.gapH8,
                        Text(
                          title,
                          style:
                              (isCompact
                                      ? textTheme.headlineMedium
                                      : textTheme.displaySmall)
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                        ),
                        AppSpacing.gapH16,
                        Text(
                          description,
                          style:
                              (isCompact
                                      ? textTheme.bodyMedium
                                      : textTheme.bodyLarge)
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.82),
                                    height: 1.6,
                                  ),
                        ),
                        AppSpacing.gapH24,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: chips
                              .map((chip) => PublicToneChip(label: chip))
                              .toList(growable: false),
                        ),
                        AppSpacing.gapH24,
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: actionsAlignment,
                            spacing: 12,
                            runSpacing: 12,
                            children: [primaryAction, ?secondaryAction],
                          ),
                        ),
                      ],
                    );

                    if (!isWide || aside == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          content,
                          if (aside != null) ...[AppSpacing.gapH24, aside!],
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 5, child: content),
                        AppSpacing.gapW32,
                        Expanded(flex: 4, child: aside!),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Pill chip used inside the hero panel (white-on-brown).
class PublicToneChip extends StatelessWidget {
  const PublicToneChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Compact stat card — number + label + optional caption.
class PublicMetricCard extends StatelessWidget {
  const PublicMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.accentColor = AppTheme.terracotta,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? caption;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PublicSectionShell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: accentColor.withValues(alpha: 0.20)),
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          AppSpacing.gapH16,
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              color: AppTheme.textStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            label,
            style: textTheme.titleSmall?.copyWith(color: AppTheme.textStrong),
          ),
          if (caption != null) ...[
            AppSpacing.gapH8,
            Text(caption!, style: textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

/// Numbered process step card.
class PublicStepCard extends StatelessWidget {
  const PublicStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String stepNumber;
  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PublicSectionShell(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.terracotta.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                  border: Border.all(
                    color: AppTheme.terracotta.withValues(alpha: 0.20),
                  ),
                ),
                child: const Icon(
                  LucideIcons.sparkles,
                  color: AppTheme.terracotta,
                  size: 18,
                ),
              ),
              AppSpacing.gapW12,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(999),
                  border: AppTheme.hairlineBorder,
                ),
                child: Text(
                  stepNumber,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Icon(icon, color: AppTheme.soganSoft, size: 18),
            ],
          ),
          AppSpacing.gapH16,
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(color: AppTheme.textStrong),
          ),
          AppSpacing.gapH8,
          Text(description, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// Frame wrapper for read-only public flow screens.
class PublicReadOnlyFlowShell extends StatelessWidget {
  const PublicReadOnlyFlowShell({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return KawungBackground(
          opacity: 0.025,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: padding,
              child: SizedBox(
                width: double.infinity,
                height: constraints.maxHeight,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PublicReadOnlySectionBlock extends StatelessWidget {
  const PublicReadOnlySectionBlock({
    super.key,
    required this.child,
    this.title,
    this.description,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = AppTheme.radiusMd,
    this.backgroundColor,
  });

  final Widget child;
  final String? title;
  final String? description;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PublicSectionShell(
      borderRadius: borderRadius,
      padding: padding,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: textTheme.titleMedium?.copyWith(
                color: AppTheme.textStrong,
              ),
            ),
          if (description != null) ...[
            if (title != null) AppSpacing.gapH8,
            Text(description!, style: textTheme.bodyMedium),
          ],
          if (title != null || description != null) AppSpacing.gapH16,
          child,
        ],
      ),
    );
  }
}

class PublicReadOnlyHeaderCard extends StatelessWidget {
  const PublicReadOnlyHeaderCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.description,
    this.chips = const <String>[],
    this.aside,
  });

  final String eyebrow;
  final String title;
  final String description;
  final List<String> chips;
  final Widget? aside;

  @override
  Widget build(BuildContext context) {
    return PublicHeroPanel(
      eyebrow: eyebrow,
      title: title,
      description: description,
      chips: chips,
      primaryAction: const _PassivePublicActionChip(
        icon: LucideIcons.eye,
        label: 'Mode publik read-only',
      ),
      secondaryAction: const _PassivePublicActionChip(
        icon: LucideIcons.shieldCheck,
        label: 'Tanpa perubahan data',
        isSecondary: true,
      ),
      aside: aside,
    );
  }
}

class PublicReadOnlyBottomBar extends StatelessWidget {
  const PublicReadOnlyBottomBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.borderColor)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class _PassivePublicActionChip extends StatelessWidget {
  const _PassivePublicActionChip({
    required this.icon,
    required this.label,
    this.isSecondary = false,
  });

  final IconData icon;
  final String label;
  final bool isSecondary;

  @override
  Widget build(BuildContext context) {
    final Color background = isSecondary
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white;
    final Color foreground = isSecondary ? Colors.white : AppTheme.soganDeep;
    final Color borderTone = isSecondary
        ? Colors.white.withValues(alpha: 0.24)
        : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: borderTone, width: AppTheme.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 16),
          AppSpacing.gapW8,
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
