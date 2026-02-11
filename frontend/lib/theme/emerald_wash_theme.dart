import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmeraldWashTheme {
  static const Color aquaMist = Color(0xFFE8F7F5);
  static const Color emeraldCore = Color(0xFF1DBA9D);
  static const Color primaryText = Color(0xFF1C3E3A);
  static const Color secondaryText = Color(0xFF4F7470);
  static const Color captionText = Color(0xFF7FA7A3);
  static const Color mutedCoral = Color(0xFFC98B8B);
  static const Color surface = Color(0xFFD9F1EE);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: aquaMist,
      colorScheme: ColorScheme.light(
        primary: emeraldCore,
        secondary: emeraldCore,
        surface: surface,
        onSurface: primaryText,
        error: mutedCoral,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          color: primaryText,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: primaryText,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.outfit(
          color: secondaryText,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.outfit(
          color: captionText,
          fontSize: 12,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: emeraldCore,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
