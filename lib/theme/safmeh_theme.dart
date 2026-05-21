import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SafMehTheme {
  // Primary palette — white & pink
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color softWhite = Color(0xFFFFF8FA);
  static const Color blushPink = Color(0xFFFFB6C8);
  static const Color deepPink = Color(0xFFFF6B9D);
  static const Color palePink = Color(0xFFFFE4EE);
  static const Color roseWhite = Color(0xFFFFF0F5);
  static const Color dustyRose = Color(0xFFFFCDD8);
  static const Color textDark = Color(0xFF3D1A26);
  static const Color textMuted = Color(0xFFAA7788);

  // Semantic colors
  static const Color safeGreen = Color(0xFFA8E6CF);
  static const Color warningPeach = Color(0xFFFFD3A5);
  static const Color emergencyRose = Color(0xFFFF8FAB);

  static BoxDecoration card() => BoxDecoration(
        color: palePink,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: dustyRose, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: blushPink.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
          )
        ],
      );

  static BoxDecoration glassCard() => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: blushPink.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
          )
        ],
      );

  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: softWhite,
        colorScheme: ColorScheme.light(
          primary: blushPink,
          secondary: deepPink,
          surface: pureWhite,
          // ignore: deprecated_member_use
          background: softWhite,
          onPrimary: pureWhite,
          onSecondary: pureWhite,
          onSurface: textDark,
        ),
        textTheme: GoogleFonts.nunitoTextTheme().copyWith(
          displayLarge:
              GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w700),
          displayMedium:
              GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w700),
          headlineMedium:
              GoogleFonts.nunito(color: textDark, fontWeight: FontWeight.w600),
          bodyLarge: GoogleFonts.nunito(color: textDark),
          bodyMedium: GoogleFonts.nunito(color: textMuted),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: blushPink,
            foregroundColor: pureWhite,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32)),
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: roseWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: dustyRose),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: dustyRose),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: deepPink, width: 2),
          ),
          labelStyle: GoogleFonts.nunito(color: textMuted),
          hintStyle: GoogleFonts.nunito(color: textMuted),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: pureWhite,
          foregroundColor: textDark,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.nunito(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        useMaterial3: true,
      );
}
