import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_patterns.dart';

bool _isCompactWidth(double width) => width < 600;

class PublicStaggeredReveal extends StatefulWidget {
  const PublicStaggeredReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.offsetY = 0.08,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  @override
  State<PublicStaggeredReveal> createState() => _PublicStaggeredRevealState();
}

class _PublicStaggeredRevealState extends State<PublicStaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(0, widget.offsetY),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }
    if (!mounted) {
      return;
    }
    await _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class PublicSectionShell extends StatelessWidget {
  const PublicSectionShell({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor,
    this.borderRadius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = _isCompactWidth(constraints.maxWidth);
        final double effectiveRadius = isCompact
            ? borderRadius.clamp(18, 24).toDouble()
            : borderRadius;

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppTheme.shellSurfaceSoft,
            borderRadius: BorderRadius.circular(effectiveRadius),
            border: Border.all(color: AppTheme.sogan.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: AppTheme.sogan.withValues(alpha: 0.06),
                blurRadius: isCompact ? 16 : 24,
                offset: Offset(0, isCompact ? 8 : 12),
              ),
            ],
          ),
          child: Padding(padding: padding, child: child),
        );
      },
    );
  }
}

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
        final double radius = isCompact ? 24 : 32;
        final EdgeInsets contentPadding = EdgeInsets.all(isCompact ? 20 : 28);

        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.sogan,
                        AppTheme.sogan.withValues(alpha: 0.94),
                        Color.lerp(AppTheme.sogan, AppTheme.pusaka, 0.32)!,
                      ],
                    ),
                  ),
                ),
              ),
              if (!isCompact) ...[
                Positioned(
                  top: -40,
                  right: -30,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.gold.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                Positioned(
                  left: -40,
                  bottom: -60,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.merang.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ],
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: KawungPainter(
                      color: Colors.white,
                      opacity: isCompact ? 0.04 : 0.06,
                      size: isCompact ? 64 : 88,
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
                            color: AppTheme.gold,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
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
                                    fontWeight: FontWeight.w900,
                                    height: 1.1,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          style:
                              (isCompact
                                      ? textTheme.bodyMedium
                                      : textTheme.bodyLarge)
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.84),
                                    height: isCompact ? 1.5 : 1.6,
                                  ),
                        ),
                        AppSpacing.gapH16,
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: chips
                              .map((chip) => PublicToneChip(label: chip))
                              .toList(growable: false),
                        ),
                        AppSpacing.gapH20,
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
                          if (aside != null) ...[AppSpacing.gapH16, aside!],
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 5, child: content),
                        AppSpacing.gapW24,
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

class PublicToneChip extends StatelessWidget {
  const PublicToneChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = _isCompactWidth(constraints.maxWidth);
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 10 : 12,
            vertical: isCompact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: AppTheme.merang.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.16)),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.merang,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
    );
  }
}

class PublicMetricCard extends StatelessWidget {
  const PublicMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.accentColor = AppTheme.sogan,
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
      padding: const EdgeInsets.all(18),
      borderRadius: 24,
      backgroundColor: AppTheme.shellSurfaceSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          AppSpacing.gapH12,
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w900,
            ),
          ),
          AppSpacing.gapH4,
          Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (caption != null) ...[
            AppSpacing.gapH6,
            Text(
              caption!,
              style: textTheme.bodySmall?.copyWith(
                color: AppTheme.pusaka.withValues(alpha: 0.78),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

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
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      backgroundColor: Color.alphaBlend(
        AppTheme.gold.withValues(alpha: 0.05),
        AppTheme.merang,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: AppTheme.sogan),
              ),
              AppSpacing.gapW12,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.sogan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  stepNumber,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppTheme.sogan,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH16,
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.sogan,
              fontWeight: FontWeight.w800,
            ),
          ),
          AppSpacing.gapH8,
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.pusaka.withValues(alpha: 0.82),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

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
          opacity: 0.03,
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
    this.borderRadius = 24,
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
      backgroundColor: backgroundColor ?? Colors.white.withValues(alpha: 0.92),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: textTheme.titleMedium?.copyWith(
                color: AppTheme.sogan,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
          if (description != null) ...[
            if (title != null) AppSpacing.gapH8,
            Text(
              description!,
              style: textTheme.bodyMedium?.copyWith(
                color: AppTheme.pusaka.withValues(alpha: 0.82),
                height: 1.5,
              ),
            ),
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
        icon: Icons.visibility_outlined,
        label: 'Mode publik read-only',
      ),
      secondaryAction: const _PassivePublicActionChip(
        icon: Icons.verified_outlined,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        border: Border(
          top: BorderSide(color: AppTheme.sogan.withValues(alpha: 0.08)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sogan.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
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
    final Color backgroundColor = isSecondary
        ? Colors.white.withValues(alpha: 0.08)
        : AppTheme.gold;
    final Color foregroundColor = isSecondary ? Colors.white : AppTheme.sogan;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSecondary
              ? Colors.white.withValues(alpha: 0.12)
              : AppTheme.gold.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foregroundColor, size: 18),
          AppSpacing.gapW8,
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
