import 'package:flutter/material.dart';

/// Canonical color tokens for the Javanese Modern Heritage palette.
///
/// All color values in the app must originate here. Theme assembly and
/// component code consumes these via [AppColors] or via `Theme.of(context)`.
class AppColors {
  AppColors._();

  // Surfaces
  static const Color cream = Color(0xFFFDFCF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);

  // Brand
  static const Color soganBrown = Color(0xFF6F4E37);
  static const Color terracotta = Color(0xFF964B00);
  static const Color soganDeep = Color(0xFF3F2C20);
  static const Color soganSoft = Color(0xFF8B6F5A);

  // Semantic
  static const Color success = Color(0xFF486750); // jati green
  static const Color error = Color(0xFF8B0000); // soga red
  static const Color warning = Color(0xFFB8861B); // kunyit
  static const Color info = Color(0xFF8B5E3C);

  // Text grades on cream
  static const Color textStrong = soganDeep;
  static const Color textMuted = Color(0xFF6B5A4F);
  static const Color textSubtle = Color(0xFF8C7B6E);

  // Neutral
  static const Color neutral = Color(0xFF9CA3AF);
  static const Color softWash = Color(0xFFF1EBE3);

  // Inverse / always-light
  static const Color white = Colors.white;
}
