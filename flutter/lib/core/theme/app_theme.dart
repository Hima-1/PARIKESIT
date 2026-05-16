import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens/colors.dart';
import 'tokens/radii.dart';
import 'tokens/typography.dart';

/// Javanese Modern Heritage theme.
///
/// Palette pairs Javanese cultural tones (Sogan brown, Terakota) with a
/// shadcn-style minimalist surface system: cream background, white cards,
/// a single hairline border, no thick shadows.
///
/// New code should consume tokens from `tokens/` directly. The static
/// fields below are kept as backward-compat aliases for existing call
/// sites — they delegate to [AppColors]/[AppRadii] under the hood.
class AppTheme {
  AppTheme._();

  // === Backward-compat color aliases =====================================
  //
  // ⚠️  DO NOT USE THESE FOR NEW CODE.
  //
  // The aliases below remain only so the ~300 existing call sites compile
  // unchanged. New code MUST consume `Theme.of(context).colorScheme` for
  // brand-aware values, or `AppColors.*` (from tokens/colors.dart) for raw
  // semantic colors. Migration mapping is documented in
  // `docs/design-system.md` §6 — replacing each alias is a one-line change.
  //
  // We can't add `@Deprecated` annotations here without flooding the
  // analyzer; cleanup happens organically per file (see design-system.md).
  static const Color cream = AppColors.cream;
  static const Color surface = AppColors.surface;
  static const Color borderColor = AppColors.border;

  static const Color soganBrown = AppColors.soganBrown;
  static const Color terracotta = AppColors.terracotta;
  static const Color soganDeep = AppColors.soganDeep;
  static const Color soganSoft = AppColors.soganSoft;

  static const Color jatiGreen = AppColors.success;
  static const Color sogaRed = AppColors.error;
  static const Color kunyit = AppColors.warning;
  static const Color info = AppColors.info;

  static const Color textStrong = AppColors.textStrong;
  static const Color textMuted = AppColors.textMuted;
  static const Color textSubtle = AppColors.textSubtle;

  static const Color navy = AppColors.soganBrown;
  static const Color orange = AppColors.terracotta;
  static const Color cyan = AppColors.info;
  static const Color sogan = AppColors.soganDeep;
  static const Color gold = AppColors.terracotta;
  static const Color merang = AppColors.cream;
  static const Color pusaka = AppColors.soganDeep;
  static const Color lightBlue = AppColors.softWash;
  static const Color background = AppColors.cream;

  static const Color success = AppColors.success;
  static const Color error = AppColors.error;
  static const Color warning = AppColors.warning;
  static const Color neutral = AppColors.neutral;
  static const Color neutralGrey = AppColors.border;
  static const Color white = AppColors.white;

  static const Color onPrimary = AppColors.white;
  static const Color onSecondary = AppColors.white;
  static const Color onTertiary = AppColors.white;
  static const Color onSurface = AppColors.soganDeep;
  static const Color onError = AppColors.white;
  static const Color onSuccess = AppColors.white;

  // === Shape token aliases ===============================================
  static const double mobilePadding = 16.0;
  static const double borderRadius = AppRadii.md;
  static const double radiusSm = AppRadii.sm;
  static const double radiusMd = AppRadii.md;
  static const double radiusLg = AppRadii.lg;
  static const double hairline = 1.0;

  static Border get hairlineBorder =>
      Border.all(color: borderColor, width: hairline);
  static BorderSide get hairlineSide =>
      const BorderSide(color: borderColor, width: hairline);

  // === Container decorations =============================================
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surface,
    borderRadius: AppRadii.rrMd,
    border: hairlineBorder,
  );

  static BoxDecoration get errorContainerDecoration => BoxDecoration(
    color: error.withValues(alpha: 0.06),
    borderRadius: AppRadii.rrMd,
    border: Border.all(color: error.withValues(alpha: 0.3), width: hairline),
  );

  static BoxDecoration get successContainerDecoration => BoxDecoration(
    color: success.withValues(alpha: 0.06),
    borderRadius: AppRadii.rrMd,
    border: Border.all(color: success.withValues(alpha: 0.3), width: hairline),
  );

  static BoxDecoration get warningContainerDecoration => BoxDecoration(
    color: warning.withValues(alpha: 0.08),
    borderRadius: AppRadii.rrMd,
    border: Border.all(color: warning.withValues(alpha: 0.3), width: hairline),
  );

  static BoxDecoration get neutralContainerDecoration => BoxDecoration(
    color: surface,
    borderRadius: AppRadii.rrMd,
    border: hairlineBorder,
  );

  static BoxDecoration get brandingContainerDecoration => BoxDecoration(
    color: surface,
    borderRadius: AppRadii.rrLg,
    border: hairlineBorder,
  );

  static Color get shellSurface => surface;
  static Color get shellSurfaceSoft => surface;

  // === Themes ============================================================
  static ThemeData get lightTheme => _build(brightness: Brightness.light);

  /// Minimal viable dark theme. Mirrors the light theme structure with
  /// inverted surfaces. Component-level polish (alpha overlays, custom
  /// shadows) will follow in a later sprint — current goal is to make
  /// `themeMode: ThemeMode.dark` render coherently.
  static ThemeData get darkTheme => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final scaffoldBg = isDark ? AppColors.darkScaffold : AppColors.cream;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final borderTone = isDark ? AppColors.darkBorder : AppColors.border;
    final strongText = isDark ? AppColors.darkTextStrong : AppColors.textStrong;
    final mutedText = isDark ? AppColors.darkTextMuted : AppColors.textMuted;
    final subtleText = isDark ? AppColors.darkTextSubtle : AppColors.textSubtle;
    final primary = isDark ? AppColors.darkPrimary : AppColors.soganBrown;
    final accent = isDark ? AppColors.darkSecondary : AppColors.terracotta;

    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: strongText,
      displayColor: strongText,
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: AppColors.white,
      secondary: accent,
      onSecondary: AppColors.white,
      tertiary: AppColors.info,
      onTertiary: AppColors.white,
      surface: surfaceColor,
      onSurface: strongText,
      surfaceContainerHighest: scaffoldBg,
      outline: borderTone,
      outlineVariant: borderTone,
      error: AppColors.error,
      onError: AppColors.white,
    );

    final textTheme = baseTextTheme.copyWith(
      displayLarge: AppTypography.display(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: strongText,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displayMedium: AppTypography.display(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: strongText,
        height: 1.2,
        letterSpacing: -0.4,
      ),
      displaySmall: AppTypography.display(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: strongText,
        height: 1.25,
      ),
      headlineLarge: AppTypography.display(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: strongText,
      ),
      headlineMedium: AppTypography.display(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: strongText,
      ),
      headlineSmall: AppTypography.display(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: strongText,
      ),
      titleLarge: AppTypography.display(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: strongText,
      ),
      titleMedium: AppTypography.body(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: strongText,
      ),
      titleSmall: AppTypography.body(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: strongText,
      ),
      bodyLarge: AppTypography.body(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: mutedText,
        height: 1.55,
      ),
      bodyMedium: AppTypography.body(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: mutedText,
        height: 1.55,
      ),
      bodySmall: AppTypography.body(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: subtleText,
        height: 1.5,
      ),
      labelLarge: AppTypography.body(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: strongText,
        letterSpacing: 0.1,
      ),
      labelMedium: AppTypography.body(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: strongText,
        letterSpacing: 0.2,
      ),
      labelSmall: AppTypography.body(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: mutedText,
        letterSpacing: 0.4,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: scaffoldBg,
      dividerColor: borderTone,
      splashFactory: InkRipple.splashFactory,
      textTheme: textTheme,
      extensions: [
        EthnoTextTheme(labelTiny: AppTypography.labelTiny(color: subtleText)),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: strongText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: strongText, size: 20),
        titleTextStyle: AppTypography.display(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: strongText,
        ),
        shape: Border(bottom: BorderSide(color: borderTone)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.rrMd,
          side: BorderSide(color: borderTone, width: hairline),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.lg),
          ),
        ),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.rrMd,
          side: BorderSide(color: borderTone, width: hairline),
        ),
        titleTextStyle: AppTypography.display(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: strongText,
        ),
        contentTextStyle: AppTypography.body(
          fontSize: 14,
          color: mutedText,
          height: 1.55,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
          textStyle: AppTypography.body(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
          textStyle: AppTypography.body(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: strongText,
          backgroundColor: surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
          side: BorderSide(color: borderTone, width: hairline),
          textStyle: AppTypography.body(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
          textStyle: AppTypography.body(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: strongText,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.rrSm),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        indicatorColor: accent.withValues(alpha: 0.10),
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: accent, size: 22);
          }
          return IconThemeData(color: mutedText, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.body(
              color: strongText,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return AppTypography.body(
            color: mutedText,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: accent,
        unselectedItemColor: mutedText,
        elevation: 0,
        selectedLabelStyle: AppTypography.body(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: AppTypography.body(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surfaceColor,
        selectedIconTheme: IconThemeData(color: accent),
        unselectedIconTheme: IconThemeData(color: mutedText),
        selectedLabelTextStyle: AppTypography.body(
          color: strongText,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: AppTypography.body(color: mutedText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: AppTypography.body(color: subtleText, fontSize: 14),
        labelStyle: AppTypography.body(color: mutedText, fontSize: 14),
        floatingLabelStyle: AppTypography.body(
          color: strongText,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.rrSm,
          borderSide: BorderSide(color: borderTone, width: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.rrSm,
          borderSide: BorderSide(color: borderTone, width: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.rrSm,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.rrSm,
          borderSide: const BorderSide(color: AppColors.error, width: hairline),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadii.rrSm,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scaffoldBg,
        selectedColor: accent.withValues(alpha: 0.10),
        side: BorderSide(color: borderTone, width: hairline),
        labelStyle: AppTypography.body(
          color: strongText,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.rrPill),
      ),
      dividerTheme: DividerThemeData(
        color: borderTone,
        thickness: hairline,
        space: hairline,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkTooltip : AppColors.soganDeep,
          borderRadius: AppRadii.rrSm,
        ),
        textStyle: AppTypography.body(color: Colors.white, fontSize: 12),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: borderTone,
        circularTrackColor: borderTone,
      ),
    );
  }
}

class EthnoTextTheme extends ThemeExtension<EthnoTextTheme> {
  const EthnoTextTheme({required this.labelTiny});

  final TextStyle labelTiny;

  @override
  ThemeExtension<EthnoTextTheme> copyWith({TextStyle? labelTiny}) {
    return EthnoTextTheme(labelTiny: labelTiny ?? this.labelTiny);
  }

  @override
  ThemeExtension<EthnoTextTheme> lerp(
    ThemeExtension<EthnoTextTheme>? other,
    double t,
  ) {
    if (other is! EthnoTextTheme) {
      return this;
    }
    return EthnoTextTheme(
      labelTiny: TextStyle.lerp(labelTiny, other.labelTiny, t)!,
    );
  }

  static EthnoTextTheme of(BuildContext context) {
    return Theme.of(context).extension<EthnoTextTheme>() ??
        EthnoTextTheme(labelTiny: AppTypography.labelTiny());
  }
}
