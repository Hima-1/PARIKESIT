import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Duration & curve tokens for animations.
///
/// Pick by intent, not by milliseconds: use [fast] for state changes
/// inside a single component (hover, ripple), [base] for content
/// transitions, and [slow] for entry/exit of large surfaces.
class AppMotion {
  AppMotion._();

  static const Duration instant = Duration(milliseconds: 80);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration base = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
  static const Curve decelerate = Curves.decelerate;

  /// Returns true when entrance animations should be skipped:
  ///  * the OS / accessibility settings request reduced motion
  ///    (`MediaQuery.disableAnimations`), or
  ///  * we're running inside `flutter test` — `flutter_animate` schedules
  ///    post-frame timers that leak as "pending timers" otherwise.
  ///
  /// Detected by inspecting the active [WidgetsBinding] runtime type so we
  /// don't have to import `package:flutter_test` from production code.
  static bool shouldDisable(BuildContext context) {
    if (_isInWidgetTest) return true;
    return MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }

  static bool? _isInWidgetTestCache;
  static bool get _isInWidgetTest {
    return _isInWidgetTestCache ??= WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
  }
}

/// Standard "fade in + slide" entrance for feedback widgets (empty /
/// error states, banners). Returns the child unchanged when the
/// surrounding [MediaQuery] disables animations, so widget tests don't
/// leak pending `flutter_animate` timers.
Widget motionEntrance(
  BuildContext context,
  Widget child, {
  double slideY = 0.04,
  Duration? fadeDuration,
  Duration? slideDuration,
  Curve curve = AppMotion.standard,
}) {
  if (AppMotion.shouldDisable(context)) return child;
  final fade = fadeDuration ?? AppMotion.base;
  final slide = slideDuration ?? AppMotion.base;
  return child
      .animate()
      .fadeIn(duration: fade)
      .slideY(begin: slideY, end: 0, duration: slide, curve: curve);
}
