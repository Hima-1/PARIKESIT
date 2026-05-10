import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// Typography token factory. Returns [TextStyle]s for the two fonts used
/// across the app: Philosopher (display / heading) and Plus Jakarta Sans
/// (body / label).
///
/// Components should prefer reading from `Theme.of(context).textTheme`,
/// but this class is the source of truth that [AppTheme] uses to assemble
/// the [TextTheme]. It is also exposed for one-off cases (e.g. PDF export
/// styling) where the Material theme is not available.
class AppTypography {
  AppTypography._();

  static TextStyle display({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) => GoogleFonts.philosopher(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
  );

  static TextStyle body({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
  }) => GoogleFonts.plusJakartaSans(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
  );

  /// The non-Material extension style used for tiny eyebrow labels.
  static TextStyle labelTiny({Color? color}) => body(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textSubtle,
    letterSpacing: 0.6,
  );
}
