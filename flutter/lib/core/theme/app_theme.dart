import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Javanese Modern Heritage theme.
///
/// Palette pairs Javanese cultural tones (Sogan brown, Terakota) with a
/// shadcn-style minimalist surface system: cream background, white cards,
/// a single hairline border, no thick shadows. Light mode only.
class AppTheme {
  AppTheme._();

  // === Javanese-Shadcn Palette ===========================================
  // Surfaces
  static const Color cream = Color(0xFFFDFCF8); // page background
  static const Color surface = Color(0xFFFFFFFF); // cards / sheets
  static const Color borderColor = Color(0xFFE5E7EB); // hairline 1.0px

  // Brand
  static const Color soganBrown = Color(0xFF6F4E37); // primary
  static const Color terracotta = Color(0xFF964B00); // accent
  static const Color soganDeep = Color(0xFF3F2C20); // body / strong text
  static const Color soganSoft = Color(0xFF8B6F5A); // muted brown

  // Semantic
  static const Color jatiGreen = Color(0xFF486750);
  static const Color sogaRed = Color(0xFF8B0000);
  static const Color kunyit = Color(0xFFB8861B);
  static const Color info = Color(0xFF8B5E3C);

  // Text grades on cream
  static const Color textStrong = soganDeep;
  static const Color textMuted = Color(0xFF6B5A4F);
  static const Color textSubtle = Color(0xFF8C7B6E);

  // === Legacy aliases (kept so existing call-sites don't break) ===========
  // Old screens still reference these names; we remap their VALUES so the
  // whole app picks up the new palette without rename churn.
  static const Color navy = soganBrown; // primary
  static const Color orange = terracotta; // accent
  static const Color cyan = info; // supporting accent
  static const Color sogan = soganDeep; // dark text / strong surfaces
  static const Color gold = terracotta; // accent
  static const Color merang = cream; // background
  static const Color pusaka = soganDeep;
  static const Color lightBlue = Color(0xFFF1EBE3); // soft brown wash
  static const Color background = cream;

  static const Color success = jatiGreen;
  static const Color error = sogaRed;
  static const Color warning = kunyit;
  static const Color neutral = Color(0xFF9CA3AF);
  static const Color neutralGrey = borderColor;
  static const Color white = Colors.white;

  static const Color onPrimary = white;
  static const Color onSecondary = white;
  static const Color onTertiary = white;
  static const Color onSurface = soganDeep;
  static const Color onError = white;
  static const Color onSuccess = white;

  // === Shape tokens =======================================================
  static const double mobilePadding = 16.0;
  static const double borderRadius = 10.0; // shadcn rounding feel
  static const double radiusSm = 6.0;
  static const double radiusMd = 10.0;
  static const double radiusLg = 16.0;
  static const double hairline = 1.0;

  static Border get hairlineBorder =>
      Border.all(color: borderColor, width: hairline);
  static BorderSide get hairlineSide =>
      const BorderSide(color: borderColor, width: hairline);

  // === Container decorations =============================================
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radiusMd),
    border: hairlineBorder,
  );

  static BoxDecoration get errorContainerDecoration => BoxDecoration(
    color: error.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: error.withValues(alpha: 0.3), width: hairline),
  );

  static BoxDecoration get successContainerDecoration => BoxDecoration(
    color: success.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: success.withValues(alpha: 0.3), width: hairline),
  );

  static BoxDecoration get warningContainerDecoration => BoxDecoration(
    color: warning.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(radiusMd),
    border: Border.all(color: warning.withValues(alpha: 0.3), width: hairline),
  );

  static BoxDecoration get neutralContainerDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radiusMd),
    border: hairlineBorder,
  );

  static BoxDecoration get brandingContainerDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(radiusLg),
    border: hairlineBorder,
  );

  static Color get shellSurface => surface;
  static Color get shellSurfaceSoft => surface;

  // === Theme =============================================================
  static ThemeData get lightTheme {
    TextStyle display({
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

    TextStyle body({
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

    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme().apply(
      bodyColor: textStrong,
      displayColor: textStrong,
    );

    const colorScheme = ColorScheme.light(
      primary: soganBrown,
      onPrimary: onPrimary,
      secondary: terracotta,
      onSecondary: onSecondary,
      tertiary: info,
      onTertiary: onTertiary,
      surface: surface,
      onSurface: textStrong,
      surfaceContainerHighest: cream,
      outline: borderColor,
      outlineVariant: borderColor,
      error: sogaRed,
      onError: onError,
    );

    final textTheme = baseTextTheme.copyWith(
      displayLarge: display(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: textStrong,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      displayMedium: display(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: textStrong,
        height: 1.2,
        letterSpacing: -0.4,
      ),
      displaySmall: display(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: textStrong,
        height: 1.25,
      ),
      headlineLarge: display(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textStrong,
      ),
      headlineMedium: display(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textStrong,
      ),
      headlineSmall: display(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textStrong,
      ),
      titleLarge: display(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textStrong,
      ),
      titleMedium: body(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textStrong,
      ),
      titleSmall: body(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textStrong,
      ),
      bodyLarge: body(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textMuted,
        height: 1.55,
      ),
      bodyMedium: body(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textMuted,
        height: 1.55,
      ),
      bodySmall: body(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: textSubtle,
        height: 1.5,
      ),
      labelLarge: body(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textStrong,
        letterSpacing: 0.1,
      ),
      labelMedium: body(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textStrong,
        letterSpacing: 0.2,
      ),
      labelSmall: body(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textMuted,
        letterSpacing: 0.4,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      canvasColor: cream,
      dividerColor: borderColor,
      splashFactory: InkRipple.splashFactory,
      textTheme: textTheme,
      extensions: [
        EthnoTextTheme(
          labelTiny: body(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textSubtle,
            letterSpacing: 0.6,
          ),
        ),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: textStrong,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: soganDeep, size: 20),
        titleTextStyle: display(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textStrong,
        ),
        shape: const Border(bottom: BorderSide(color: borderColor)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderColor, width: hairline),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
        ),
        showDragHandle: true,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderColor, width: hairline),
        ),
        titleTextStyle: display(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textStrong,
        ),
        contentTextStyle: body(
          fontSize: 14,
          color: textMuted,
          height: 1.55,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: terracotta,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: body(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: soganBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: body(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textStrong,
          backgroundColor: surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          side: const BorderSide(color: borderColor, width: hairline),
          textStyle: body(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: terracotta,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: body(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: textStrong,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: terracotta.withValues(alpha: 0.10),
        elevation: 0,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: terracotta, size: 22);
          }
          return const IconThemeData(color: textMuted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return body(
              color: textStrong,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return body(
            color: textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: terracotta,
        unselectedItemColor: textMuted,
        elevation: 0,
        selectedLabelStyle: body(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: body(fontWeight: FontWeight.w500, fontSize: 12),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: surface,
        selectedIconTheme: const IconThemeData(color: terracotta),
        unselectedIconTheme: const IconThemeData(color: textMuted),
        selectedLabelTextStyle: body(
          color: textStrong,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: body(color: textMuted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: body(color: textSubtle, fontSize: 14),
        labelStyle: body(color: textMuted, fontSize: 14),
        floatingLabelStyle: body(
          color: textStrong,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: borderColor, width: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: borderColor, width: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: soganBrown, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: sogaRed, width: hairline),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          borderSide: const BorderSide(color: sogaRed, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cream,
        selectedColor: terracotta.withValues(alpha: 0.10),
        side: const BorderSide(color: borderColor, width: hairline),
        labelStyle: body(
          color: textStrong,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: hairline,
        space: hairline,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: soganDeep,
          borderRadius: BorderRadius.circular(radiusSm),
        ),
        textStyle: body(color: Colors.white, fontSize: 12),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: terracotta,
        linearTrackColor: borderColor,
        circularTrackColor: borderColor,
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
        EthnoTextTheme(
          labelTiny: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSubtle,
            letterSpacing: 0.6,
          ),
        );
  }
}
