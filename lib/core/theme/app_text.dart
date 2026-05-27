import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Riण Design System — Typography.
///
/// Plus Jakarta Sans for all UI text; DM Mono for ALL money, IDs, OTP,
/// reference numbers and credit balances (FRS Rules 2 & 3).
class AppText {
  AppText._();

  static TextStyle _jakarta({
    required double size,
    required FontWeight weight,
    required Color color,
    double? height,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  static TextStyle _mono({
    required double size,
    required FontWeight weight,
    required Color color,
  }) => GoogleFonts.dmMono(fontSize: size, fontWeight: weight, color: color);

  // — HEADINGS —
  static final TextStyle headingXL = _jakarta(
    size: 24,
    weight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static final TextStyle headingLG = _jakarta(
    size: 20,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static final TextStyle headingMD = _jakarta(
    size: 18,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static final TextStyle headingSM = _jakarta(
    size: 16,
    weight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // — BODY —
  static final TextStyle bodyLG = _jakarta(
    size: 16,
    weight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static final TextStyle bodyMD = _jakarta(
    size: 14,
    weight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static final TextStyle bodySM = _jakarta(
    size: 12,
    weight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  // — MONO (money / IDs / OTP) —
  static final TextStyle mono = _mono(
    size: 16,
    weight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static final TextStyle monoSM = _mono(
    size: 13,
    weight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static final TextStyle displayMedium = _mono(
    size: 36,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
  ); // countdown timers

  // — BUTTONS —
  static final TextStyle buttonLG = _jakarta(
    size: 16,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static final TextStyle buttonMD = _jakarta(
    size: 14,
    weight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
