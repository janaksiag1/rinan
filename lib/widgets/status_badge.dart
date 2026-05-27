import 'package:flutter/material.dart';

import '../core/constants/app_enums.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

/// Pill status badge with the EXACT color mapping from FRS Rule 6.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key, this.onTap});
  final LoanStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: status.bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        status.label,
        style: AppText.bodySM.copyWith(
          color: status.fg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    if (onTap == null) return pill;
    return GestureDetector(onTap: onTap, child: pill);
  }
}
