import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
class C {
  C._();

  // Backgrounds
  static const bg = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E7EB);

  // Brand Colors
  static const violet = Color(0xFF7C3AED); // Primary Purple
  static const rose = Color(0xFFEC4899);   // Accent Pink

  // Supporting Colors
  static const indigo = Color(0xFF8B5CF6);
  static const amber = Color(0xFFF59E0B);  // Warning
  static const teal = Color(0xFF22C55E);   // Success
  static const sky = Color(0xFF60A5FA);
  static const orange = Color(0xFFF97316);

  // Text Colors
  static const t1 = Color(0xFF1F2937);
  static const t2 = Color(0xFF6B7280);
  static const t3 = Color(0xFF9CA3AF);

  // Role Colors
  static const admin = violet;
  static const org = violet;
  static const attendee = rose;

  // Gradients
  static const LinearGradient gPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFFEC4899),
    ],
  );

  static const LinearGradient gRose = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEC4899),
      Color(0xFFF472B6),
    ],
  );

  static const LinearGradient gTeal = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF22C55E),
      Color(0xFF4ADE80),
    ],
  );

  static const LinearGradient gAmber = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFFBBF24),
    ],
  );

  static const LinearGradient gBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFFFFFFF),
    ],
  );
}

// ── Theme ────────────────────────────────────────────────────────────────────
class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: C.bg,
      colorScheme: const ColorScheme.light(
        primary: C.violet,
        secondary: C.rose,
        surface: C.surface,
        error: C.rose,
        onPrimary: Colors.white,
        onSurface: C.t1,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
            fontSize: 34, fontWeight: FontWeight.w800, color: C.t1),
        displayMedium: GoogleFonts.inter(
            fontSize: 28, fontWeight: FontWeight.w700, color: C.t1),
        headlineLarge: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w700, color: C.t1),
        headlineMedium: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.w600, color: C.t1),
        titleLarge: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w600, color: C.t1),
        bodyLarge: GoogleFonts.inter(fontSize: 15, color: C.t1),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: C.t2),
        bodySmall: GoogleFonts.inter(fontSize: 11, color: C.t3),
        labelLarge: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: C.surface,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.violet, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: C.rose),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: C.t2),
        hintStyle: GoogleFonts.inter(fontSize: 13, color: C.t3),
        errorStyle: GoogleFonts.inter(fontSize: 11, color: C.rose),
      ),
      cardTheme: CardThemeData(
        color: C.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: C.surface,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: C.t1,
        ),
        iconTheme: const IconThemeData(color: C.t1),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: C.violet,
        selectedItemColor: C.rose,
        unselectedItemColor: C.indigo,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: C.violet,
          foregroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w600),
          elevation: 0,
        ),
      ),
      dividerTheme:
      const DividerThemeData(color: C.border, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: C.card,
        contentTextStyle:
        GoogleFonts.inter(color: C.t1, fontSize: 13),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}