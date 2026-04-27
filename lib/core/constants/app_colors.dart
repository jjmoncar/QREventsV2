import 'package:flutter/material.dart';

/// Guestly brand colors based on logo and mockup designs
/// Navy/Teal/Green palette
class AppColors {
  AppColors._();

  // ─── Primary (Navy) ───
  static const Color primaryNavy = Color(0xFF0D3B66);
  static const Color primaryNavyLight = Color(0xFF1A5276);
  static const Color primaryNavyDark = Color(0xFF082A4D);

  // ─── Secondary (Teal/Green) ───
  static const Color secondaryTeal = Color(0xFF2E8B57);
  static const Color secondaryTealLight = Color(0xFF3CB371);
  static const Color secondaryTealDark = Color(0xFF1E6B42);

  // ─── Accent ───
  static const Color accent = Color(0xFF28A745);
  static const Color accentLight = Color(0xFF34C759);

  // ─── Backgrounds ───
  static const Color backgroundLight = Color(0xFFF0F4F8);
  static const Color backgroundDark = Color(0xFF121212);

  // ─── Surfaces ───
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantLight = Color(0xFFE8ECF0);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);

  // ─── Text ───
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF6C757D);
  static const Color textPrimaryDark = Color(0xFFE8E8E8);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);

  // ─── Status Colors ───
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFA500);
  static const Color info = Color(0xFF17A2B8);

  // ─── Status Colors (Dark) ───
  static const Color successDark = Color(0xFF34C759);
  static const Color errorDark = Color(0xFFFF6B6B);
  static const Color warningDark = Color(0xFFFFB347);
  static const Color infoDark = Color(0xFF5BC0DE);

  // ─── Chart Colors ───
  static const Color chartBar1 = Color(0xFF0D3B66);
  static const Color chartBar2 = Color(0xFF2E8B57);
  static const Color chartBar3 = Color(0xFF6C757D);

  // ─── Gradients ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryNavy, primaryNavyLight],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryTeal, secondaryTealLight],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D3B66), Color(0xFF164B7E)],
  );
}
