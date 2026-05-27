import 'package:flutter/material.dart';

/// Riण Design System — Colors.
///
/// FRS Rule 1 (NON-NEGOTIABLE): ALL text on colored backgrounds is
/// [textPrimary] (#0A1628). NEVER white. There is no white text token here on
/// purpose.
class AppColors {
  AppColors._();

  // — BRAND / PRIMARY —
  static const Color navyPrimary = Color(0xFF1A3560); // AppBar, PrimaryButton, headers
  static const Color tealPrimary = Color(0xFF0D9488); // TealButton, FAB, focus, agent
  static const Color amberPrimary = Color(0xFFD97706); // warnings, low-credit, 4-7d
  static const Color errorPrimary = Color(0xFFDC2626); // Danger, rejection, reviewer, 8+d
  static const Color successPrimary = Color(0xFF059669); // approved, disbursed, <3d
  static const Color infoPrimary = Color(0xFF2563EB); // APPLIED / SUBMITTED blue
  static const Color warningPrimary = amberPrimary; // alias used throughout spec
  static const Color purplePrimary = Color(0xFF7C3AED); // note_added timeline events

  // — BACKGROUNDS —
  static const Color bgPrimary = Color(0xFFF8FAFC); // Scaffold bg every screen
  static const Color bgSecondary = Color(0xFFFFFFFF); // cards, sheets, dialogs
  static const Color bgTertiary = Color(0xFFF1F5F9); // shimmer, alt rows, search bg

  // — TEXT —
  static const Color textPrimary = Color(0xFF0A1628); // ALL text on colored bg, labels
  static const Color textSecondary = Color(0xFF334155); // body, descriptions, values
  static const Color textTertiary = Color(0xFF64748B); // hints, timestamps, metadata
  static const Color textLink = tealPrimary; // masked mobile, resend OTP links

  // — BORDERS —
  static const Color borderLight = Color(0xFFE2E8F0); // unfocused inputs, card outline
  static const Color borderMid = Color(0xFFCBD5E1); // dashed zones, dots inactive
  static const Color borderFocus = tealPrimary; // focused input 2px

  // — TINTS (light backgrounds for chips / banners / badges) —
  static const Color navyLight = Color(0xFFE8EDF5);
  static const Color tealLight = Color(0xFFCCFBF1);
  static const Color amberLight = Color(0xFFFDE9C8);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color infoLight = Color(0xFFDBEAFE);
  static const Color purbg = Color(0xFFEDE9FE); // purple bg (client_added etc.)

  // — Semantic aliases used verbatim in the FRS spec text —
  static const Color okbg = successLight; // payment / disbursed bg
  static const Color oktx = successPrimary; // ok text
  static const Color infoBg = infoLight;
  static const Color tealLightBg = tealLight;
}
