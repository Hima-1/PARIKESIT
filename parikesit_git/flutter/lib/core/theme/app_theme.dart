import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color navy = Color(0xFF0B5C9E);
  static const Color orange = Color(0xFFF28C28);
  static const Color cyan = Color(0xFF00A2E8);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color background = Color(0xFFF5F5F5);

  static const Color sogan = Color(0xFF3E2723);
  static const Color gold = Color(0xFFD4AF37);
  static const Color merang = Color(0xFFFDFBF7);
  static const Color pusaka = Color(0xFF455A64);
  static const Color sogaRed = Color(0xFF8B0000);
  static const Color jatiGreen = Color(0xFF486750);
  static const Color kunyit = Color(0xFFBF9000);

  // Semantic Colors
  static const Color success = jatiGreen;
  static const Color error = sogaRed;
  static const Color warning = orange;
  static const Color info = cyan;
  static const Color neutral = Color(0xFF9E9E9E);
  static const Color neutralGrey = Color(0xFFF0F0F0);
  static const Color white = Colors.white;

  // Semantic Contrast Colors
  static const Color onPrimary = white;
  static const Color onSecondary = white;
  static const Color onTertiary = white;
  static const Color onSurface = sogan;
  static const Color onError = white;
  static const Color onSuccess = white;

  static BoxDecoration get errorContainerDecoration => BoxDecoration(
    color: error.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: error.withValues(alpha: 0.25)),
  );

  static BoxDecoration get successContainerDecoration => BoxDecoration(
    color: success.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: success.withValues(alpha: 0.25)),
  );

  static BoxDecoration get warningContainerDecoration => BoxDecoration(
    color: warning.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: warning.withValues(alpha: 0.25)),
  );

  static BoxDecoration get neutralContainerDecoration => BoxDecoration(
    color: sogan.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: sogan.withValues(alpha: 0.15)),
  );

  static BoxDecoration get brandingContainerDecoration => BoxDecoration(
    color: gold.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(32),
    border: Border.all(color: gold.withValues(alpha: 0.35)),
    boxShadow: [
      BoxShadow(
        color: sogan.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );

  static Color get shellSurface => Colors.white.withValues(alpha: 0.9);
  static Color get shellSurfaceSoft => merang.withValues(alpha: 0.94);

  // Shared constants for mobile
  static const double mobilePadding = 16.0;
  static const double borderRadius = 12.0;

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.montserratTextTheme();

    const colorScheme = ColorScheme.light(
      primary: navy,
      onPrimary: onPrimary,
      secondary: orange,
      onSecondary: onSecondary,
      tertiary: cyan,
      onTertiary: onTertiary,
      surface: merang,
      onSurface: onSurface,
      error: error,
      onError: onError,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: sogan,
        ),
        displayMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: sogan,
        ),
        displaySmall: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: sogan,
        ),
        headlineMedium: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: sogan,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: sogan,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          color: sogan.withValues(alpha: 0.8),
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 14,
          color: sogan.withValues(alpha: 0.8),
        ),
        bodySmall: GoogleFonts.montserrat(
          fontSize: 12,
          color: sogan.withValues(alpha: 0.7),
        ),
        labelSmall: GoogleFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: sogan.withValues(alpha: 0.6),
        ),
      ),
      extensions: [
        EthnoTextTheme(
          labelTiny: GoogleFonts.montserrat(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: sogan.withValues(alpha: 0.6),
          ),
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: sogan,
        foregroundColor: gold,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: gold),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: sogan.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(color: sogan.withValues(alpha: 0.05)),
        ),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: merang,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius * 1.5),
          ),
        ),
        showDragHandle: true,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: cyan.withValues(alpha: 0.18),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: navy);
          }
          return IconThemeData(color: sogan.withValues(alpha: 0.6));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: sogan,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
          }
          return TextStyle(color: sogan.withValues(alpha: 0.6), fontSize: 12);
        }),
      ),
      dividerColor: sogan.withValues(alpha: 0.1),
      scaffoldBackgroundColor: merang,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: sogan.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: sogan.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: sogan, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: sogaRed),
        ),
        labelStyle: TextStyle(color: sogan.withValues(alpha: 0.6)),
        floatingLabelStyle: const TextStyle(
          color: sogan,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: navy,
        unselectedItemColor: sogan.withValues(alpha: 0.5),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: navy,
        selectedIconTheme: IconThemeData(color: cyan),
        unselectedIconTheme: IconThemeData(color: Colors.white70),
        selectedLabelTextStyle: TextStyle(
          color: white,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: TextStyle(color: Colors.white70),
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
          labelTiny: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppTheme.sogan.withValues(alpha: 0.6),
          ),
        );
  }
}
