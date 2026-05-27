import 'package:flutter/material.dart';

/// Riण Design System — Colors (DARK theme).
///
/// The app uses a dark navy palette: deep navy backgrounds, light text, teal
/// accent. `textPrimary` is the LIGHT text used on every surface (the design
/// pivoted from the original light spec to the dark mockups). Status/badge
/// tints are dark-blended so colored or light labels stay legible on them.
class AppColors {
  AppColors._();

  // — BRAND / PRIMARY —
  static const Color navyPrimary = Color(0xFF1A3560); // AppBar/header, PrimaryButton, deep surfaces
  static const Color tealPrimary = Color(0xFF0D9488); // TealButton, FAB, focus, agent, active nav
  static const Color amberPrimary = Color(0xFFE08C2B); // warnings, low-credit, 4-7d
  static const Color errorPrimary = Color(0xFFEF4444); // Danger, rejection, reviewer, 8+d
  static const Color successPrimary = Color(0xFF10B981); // approved, disbursed, <3d
  static const Color infoPrimary = Color(0xFF3B82F6); // APPLIED / SUBMITTED blue
  static const Color warningPrimary = amberPrimary;
  static const Color purplePrimary = Color(0xFF8B5CF6);
  static const Color indigoSoft = Color(0xFF8FB0E8); // disbursed badge text on dark

  // — BACKGROUNDS (dark) —
  static const Color bgPrimary = Color(0xFF0A1628); // Scaffold bg every screen
  static const Color bgSecondary = Color(0xFF14233B); // cards, sheets, dialogs (elevated)
  static const Color bgTertiary = Color(0xFF1C2E49); // inputs, alt rows, search bg

  /// Gradient pair used behind headers / hero areas (top → bottom).
  static const Color gradientTop = Color(0xFF1E3A66);
  static const Color gradientBottom = Color(0xFF0A1628);

  // — TEXT (light on dark) —
  static const Color textPrimary = Color(0xFFF1F5F9); // ALL primary text, button labels, headings
  static const Color textSecondary = Color(0xFFAEBACE); // body, descriptions, values
  static const Color textTertiary = Color(0xFF7E8DA6); // hints, timestamps, metadata
  static const Color textLink = Color(0xFF2DD4BF); // links (bright teal)

  // — BORDERS —
  static const Color borderLight = Color(0xFF243650); // card outline, unfocused inputs
  static const Color borderMid = Color(0xFF35496B); // dashed zones, inactive dots
  static const Color borderFocus = tealPrimary;

  // — TINTS (dark-blended chip / banner / badge backgrounds) —
  static const Color navyLight = Color(0xFF20375E);
  static const Color tealLight = Color(0xFF0E3B37);
  static const Color amberLight = Color(0xFF3A2B12);
  static const Color warningLight = Color(0xFF3A2B12);
  static const Color errorLight = Color(0xFF3A1A1D);
  static const Color successLight = Color(0xFF0E3328);
  static const Color infoLight = Color(0xFF15294C);
  static const Color purbg = Color(0xFF241C44);

  // — Semantic aliases used verbatim in screens —
  static const Color okbg = successLight;
  static const Color oktx = successPrimary;
  static const Color infoBg = infoLight;
  static const Color tealLightBg = tealLight;
}
