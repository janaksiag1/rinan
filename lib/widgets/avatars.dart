import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';

/// Circular avatar showing client/agent initials on a tinted background.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(
    this.initials, {
    super.key,
    this.size = 40,
    this.bg,
    this.fg,
  });
  final String initials;
  final double size;
  final Color? bg;
  final Color? fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg ?? AppColors.tealLight,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: AppText.headingSM.copyWith(
          color: fg ?? AppColors.tealPrimary,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Bank avatar — first letter of the bank name on a navy-tinted circle.
class BankInitialAvatar extends StatelessWidget {
  const BankInitialAvatar(this.initial, {super.key, this.size = 40});
  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.navyLight,
        shape: BoxShape.circle,
      ),
      child: Text(
        initial,
        style: AppText.headingSM.copyWith(
          color: AppColors.navyPrimary,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
