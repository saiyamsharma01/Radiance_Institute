import 'package:flutter/material.dart';

/// Design tokens matching Radiance Institute official brochure & visual identity.
class AppColors {
  AppColors._();

  // Official Brand Palette
  static const Color primaryRoyalBlue = Color(0xFF2059A5);
  static const Color deepNavy = Color(0xFF172B4D);
  static const Color lightBlueBackground = Color(0xFFEAF2FF);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Accent & Tonal Colors
  static const Color accentGold = Color(0xFFD97706);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color softBlueSurface = Color(0xFFF4F8FD);
  static const Color borderSubtle = Color(0xFFE2E8F0);

  // Feedback & Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Neutral Scales
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Dark Mode Equivalents
  static const Color darkBackground = Color(0xFF0B132B);
  static const Color darkSurface = Color(0xFF1C2541);
  static const Color darkCard = Color(0xFF243054);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
}
