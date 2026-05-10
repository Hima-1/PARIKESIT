import 'package:flutter/material.dart';

/// Elevation tokens. The Javanese-Shadcn design favors hairline borders over
/// drop shadows, so most surfaces use [e0]. [e1]/[e2] exist for transient
/// surfaces (popovers, dialogs in motion) where lift is intentional.
class AppElevation {
  AppElevation._();

  static const List<BoxShadow> e0 = [];

  static const List<BoxShadow> e1 = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> e2 = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> e3 = [
    BoxShadow(color: Color(0x22000000), blurRadius: 24, offset: Offset(0, 8)),
  ];
}
