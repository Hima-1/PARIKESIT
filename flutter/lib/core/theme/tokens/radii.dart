import 'package:flutter/material.dart';

/// Border-radius tokens. Use [AppRadii.r*] for raw doubles and
/// [AppRadii.rr*] for ready-to-use [BorderRadius] values.
class AppRadii {
  AppRadii._();

  static const double r4 = 4.0;
  static const double r6 = 6.0;
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r24 = 24.0;
  static const double rPill = 999.0;

  // Semantic aliases
  static const double sm = r6;
  static const double md = r10;
  static const double lg = r16;

  static final BorderRadius rrSm = BorderRadius.circular(sm);
  static final BorderRadius rrMd = BorderRadius.circular(md);
  static final BorderRadius rrLg = BorderRadius.circular(lg);
  static final BorderRadius rrPill = BorderRadius.circular(rPill);
}
