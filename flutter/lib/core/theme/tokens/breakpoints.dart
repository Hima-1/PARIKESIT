import 'package:flutter/widgets.dart';

/// Responsive breakpoints aligned with Material 3 window size classes.
///
/// Compact   < 600   → phones
/// Medium    600-905 → small tablets, foldables
/// Expanded  >= 905  → large tablets, desktop
enum AppBreakpoint { compact, medium, expanded }

class AppBreakpoints {
  AppBreakpoints._();

  static const double compactMax = 600;
  static const double mediumMax = 905;

  static AppBreakpoint of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < compactMax) return AppBreakpoint.compact;
    if (w < mediumMax) return AppBreakpoint.medium;
    return AppBreakpoint.expanded;
  }

  static bool isCompact(BuildContext context) =>
      of(context) == AppBreakpoint.compact;

  static bool isAtLeastMedium(BuildContext context) =>
      of(context) != AppBreakpoint.compact;
}
