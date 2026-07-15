import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Kolorystyka bazy (Few Bears — drewno, mosiądz, kość słoniowa)
  static const Color background = Color(0xFF2B2620); // Ciemny grafit-drewno
  static const Color foreground = Color(0xFFEFE9DC); // Kość słoniowa (tekst/tarcza)
  static const Color primary = Color(0xFFB08D4C); // Mosiądz
  static const Color secondary = Color(0xFF3A342B); // Ciemny orzech / drewno
  static const Color accent = Color(0xFF6E2A26); // Bordo — igła kompasu

  static const Color error = Color(0xFFef4444);
  static const Color correct = Color(0xFF34d399);
  static const Color wrong = Color(0xFFf87171);
  static const Color roughCard = Color(0xFF241F19); // Karty na ciemnym tle

  // Nowe: jasne tło / spiżarnia / akcenty
  static const Color ivory = Color(0xFFF4F1EA); // Studio white (splash/hero jasny)
  static const Color ivoryDeep = Color(0xFFE8E4D8); // Dół gradientu / marmur tarczy
  static const Color brassLight = Color(0xFFD9B87A); // Highlight, aktywna igła
  static const Color fur = Color(0xFF8B5E3C); // Łapki misia
  static const Color textOnDark = Color(0xFFEFE9DC);
  static const Color textOnLight = Color(0xFF211D18);
  static const Color textSecondary = Color(0xFF6B6152);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final nunitoTextTheme = GoogleFonts.nunitoTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        error: AppColors.error,
        surface: AppColors.background,
        onPrimary: AppColors.foreground,
        onSecondary: AppColors.foreground,
        onTertiary: AppColors.foreground,
        onError: AppColors.foreground,
        onSurface: AppColors.foreground,
      ),
      textTheme: nunitoTextTheme.copyWith(
        // Główne nagłówki - Fraunces (vintage, render-realistyczny vibe)
        displayLarge: GoogleFonts.fraunces(
          fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.foreground),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.foreground),
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.foreground),

        // Tekst użytkowy - Nunito (Miękki, ale czytelny)
        titleLarge: GoogleFonts.nunito(
          fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.foreground),
        titleMedium: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.foreground),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.foreground),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.foreground),
        bodySmall: GoogleFonts.nunito(
          fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.foreground),
        labelLarge: GoogleFonts.nunito(
          fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.foreground),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.roughCard,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.foreground),
      ),
      cardColor: AppColors.roughCard,
      dividerColor: AppColors.secondary.withValues(alpha: 0.3),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.secondary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.roughCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        type: BottomNavigationBarType.fixed,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.roughCard,
        contentTextStyle: TextStyle(color: AppColors.foreground),
      ),
    );
  }
}
