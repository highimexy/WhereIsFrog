import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Kolorystyka bazy (Gliniany kompas i żaba)
  static const Color background = Color(0xFF1E221E); // Ciemna, zgaszona zieleń
  static const Color foreground = Color(0xFFEBE6D9); // Kremowa tarcza kompasu
  static const Color primary = Color(0xFF557C55); // Żabia, gliniana zieleń
  static const Color secondary = Color(0xFF8B5A2B); // Brąz/Miedź obudowy kompasu
  static const Color accent = Color(0xFFD93829); // Czerwień wskazówki

  static const Color error = Color(0xFFef4444);
  static const Color correct = Color(0xFF34d399);
  static const Color wrong = Color(0xFFf87171);
  static const Color roughCard = Color(0xFF262C27); // Lekko jaśniejsze tło pod widgety
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
        // Główne nagłówki - DynaPuff (Gliniany, zabawny vibe)
        displayLarge: GoogleFonts.dynaPuff(
          fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.foreground),
        headlineMedium: GoogleFonts.dynaPuff(
          fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.foreground),
        headlineSmall: GoogleFonts.dynaPuff(
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
        titleTextStyle: GoogleFonts.dynaPuff(
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
