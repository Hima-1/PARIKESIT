import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // Raw Tokens (4-point grid)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Horizontal Gaps
  static const gapW4 = SizedBox(width: xs);
  static const gapW6 = SizedBox(width: 6);
  static const gapW8 = SizedBox(width: sm);
  static const gapW12 = SizedBox(width: 12);
  static const gapW16 = SizedBox(width: md);
  static const gapW24 = SizedBox(width: lg);
  static const gapW32 = SizedBox(width: xl);
  static const gapW48 = SizedBox(width: xxl);

  // Vertical Gaps
  static const gapH2 = SizedBox(height: 2);
  static const gapH4 = SizedBox(height: xs);
  static const gapH6 = SizedBox(height: 6);
  static const gapH8 = SizedBox(height: sm);
  static const gapH12 = SizedBox(height: 12);
  static const gapH16 = SizedBox(height: md);
  static const gapH20 = SizedBox(height: 20);
  static const gapH24 = SizedBox(height: lg);
  static const gapH32 = SizedBox(height: xl);
  static const gapH48 = SizedBox(height: xxl);

  // Padding Edge Insets
  static const pAll4 = EdgeInsets.all(xs);
  static const pAll8 = EdgeInsets.all(sm);
  static const pAll12 = EdgeInsets.all(12);
  static const pAll16 = EdgeInsets.all(md);
  static const pAll20 = EdgeInsets.all(20);
  static const pAll24 = EdgeInsets.all(lg);
  static const pAll32 = EdgeInsets.all(xl);
  static const pAll48 = EdgeInsets.all(xxl);

  static const pH8 = EdgeInsets.symmetric(horizontal: sm);
  static const pH16 = EdgeInsets.symmetric(horizontal: md);
  static const pH24 = EdgeInsets.symmetric(horizontal: lg);

  static const pV8 = EdgeInsets.symmetric(vertical: sm);
  static const pV16 = EdgeInsets.symmetric(vertical: md);
  static const pV24 = EdgeInsets.symmetric(vertical: lg);

  static const pH16V8 = EdgeInsets.symmetric(horizontal: md, vertical: sm);
  static const pH12V6 = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const pH8V4 = EdgeInsets.symmetric(horizontal: sm, vertical: xs);

  // Semantic Padding
  static const pPage = EdgeInsets.all(md);
  static const pPageHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const pPageVertical = EdgeInsets.symmetric(vertical: md);
}
