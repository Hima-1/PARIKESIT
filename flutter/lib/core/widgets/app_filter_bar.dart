import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_spacing.dart';
import '../theme/tokens/breakpoints.dart';

/// Slot-based filter bar shared by list screens.
///
/// Layout adapts at [narrowWidth]: below the threshold, [search] stacks
/// above [filters] on a separate row; above it, [search] takes the
/// dominant flex and [filters] sit beside it. [trailing] (e.g. an icon
/// button to flip sort direction) always renders to the right.
///
/// All slots are optional, so the same widget covers screens with just a
/// search field, just filters, or all three.
class AppFilterBar extends StatelessWidget {
  const AppFilterBar({
    super.key,
    this.search,
    this.filters = const [],
    this.trailing,
    this.narrowWidth = 720,
  });

  final Widget? search;
  final List<Widget> filters;
  final Widget? trailing;
  final double narrowWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < narrowWidth;

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ?search,
              if (search != null && filters.isNotEmpty) AppSpacing.gapH12,
              if (filters.isNotEmpty || trailing != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < filters.length; i++) ...[
                      if (i > 0) AppSpacing.gapW12,
                      Expanded(child: filters[i]),
                    ],
                    if (trailing != null) ...[AppSpacing.gapW12, trailing!],
                  ],
                ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (search != null) ...[
              Expanded(flex: 3, child: search!),
              AppSpacing.gapW12,
            ],
            for (var i = 0; i < filters.length; i++) ...[
              if (i > 0) AppSpacing.gapW12,
              Expanded(flex: 2, child: filters[i]),
            ],
            if (trailing != null) ...[AppSpacing.gapW12, trailing!],
          ],
        );
      },
    );
  }
}

/// Convenience text field with the standard search affordance + debounce.
/// Use as the [AppFilterBar.search] slot to avoid reimplementing the
/// debounce timer in each screen.
class AppFilterSearchField extends StatefulWidget {
  const AppFilterSearchField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hintText = 'Cari…',
    this.debounce = const Duration(milliseconds: 400),
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final String hintText;
  final Duration debounce;

  @override
  State<AppFilterSearchField> createState() => _AppFilterSearchFieldState();
}

class _AppFilterSearchFieldState extends State<AppFilterSearchField> {
  late final TextEditingController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant AppFilterSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(LucideIcons.search),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        _timer?.cancel();
        _timer = Timer(widget.debounce, () => widget.onChanged(value.trim()));
      },
    );
  }
}

/// Helper that decides the sensible default narrowWidth based on the
/// active breakpoint. Useful when callers want the bar to collapse on
/// compact regardless of inner constraints.
double defaultFilterNarrowWidth(BuildContext context) =>
    AppBreakpoints.isCompact(context) ? double.infinity : 720;
