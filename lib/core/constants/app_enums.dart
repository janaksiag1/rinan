import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Which profile is active. The whole app is profile-aware (FRS Rule 8).
enum ProfileType {
  agent('Agent', AppColors.tealPrimary),
  reviewer('Reviewer', AppColors.errorPrimary);

  const ProfileType(this.label, this.color);
  final String label;
  final Color color;
}

/// Loan / application lifecycle status. Colors per FRS Rule 6 (StatusBadge).
enum LoanStatus {
  draft('DRAFT', 'Draft', AppColors.textTertiary, AppColors.bgTertiary),
  applied('APPLIED', 'Applied', AppColors.infoPrimary, AppColors.infoLight),
  submitted(
    'SUBMITTED',
    'Submitted',
    AppColors.infoPrimary,
    AppColors.infoLight,
  ),
  underReview(
    'UNDER_REVIEW',
    'Under Review',
    AppColors.warningPrimary,
    AppColors.warningLight,
  ),
  approved(
    'APPROVED',
    'Approved',
    AppColors.successPrimary,
    AppColors.successLight,
  ),
  rejected('REJECTED', 'Rejected', AppColors.errorPrimary, AppColors.errorLight),
  sanctioned(
    'SANCTIONED',
    'Sanctioned',
    AppColors.tealPrimary,
    AppColors.tealLight,
  ),
  disbursed(
    'DISBURSED',
    'Disbursed',
    AppColors.indigoSoft,
    AppColors.navyLight,
  );

  const LoanStatus(this.code, this.label, this.fg, this.bg);
  final String code;
  final String label;
  final Color fg;
  final Color bg;
}

/// Urgency band for a loan, drives the 4px left border of cards.
enum UrgencyBand {
  fresh(AppColors.successPrimary), // < 3 days
  warning(AppColors.amberPrimary), // 4-7 days
  overdue(AppColors.errorPrimary); // 8+ days

  const UrgencyBand(this.color);
  final Color color;

  static UrgencyBand fromDays(int days) {
    if (days < 3) return UrgencyBand.fresh;
    if (days <= 7) return UrgencyBand.warning;
    return UrgencyBand.overdue;
  }
}

/// Document review state.
enum DocStatus {
  pending('Pending', AppColors.borderMid),
  uploaded('Uploaded', AppColors.tealPrimary),
  accepted('Accepted', AppColors.successPrimary),
  rejected('Rejected', AppColors.errorPrimary),
  reuploadNeeded('Re-upload Needed', AppColors.amberPrimary);

  const DocStatus(this.label, this.color);
  final String label;
  final Color color;
}

/// KYC step state for the agent KYC overview.
enum KycStatus {
  pending('Pending', AppColors.textTertiary, AppColors.bgTertiary),
  inProgress('In Progress', AppColors.amberPrimary, AppColors.warningLight),
  verified('Verified', AppColors.successPrimary, AppColors.successLight),
  rejected('Rejected', AppColors.errorPrimary, AppColors.errorLight);

  const KycStatus(this.label, this.fg, this.bg);
  final String label;
  final Color fg;
  final Color bg;
}

/// Bank ↔ customer-portal connection state.
enum PortalStatus { connected, notConnected }

/// Generic async view state used by every screen (FRS Rule 10).
enum ViewState { loading, error, empty, data }
