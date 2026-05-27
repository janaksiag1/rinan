import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// Module 1 — Account locked after too many wrong OTP attempts.
class AccountLockedScreen extends StatelessWidget {
  const AccountLockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: AppColors.errorPrimary,
                ),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  'Account Temporarily Locked',
                  textAlign: TextAlign.center,
                  style: AppText.headingXL
                      .copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Too many wrong OTP attempts.',
                  textAlign: TextAlign.center,
                  style: AppText.bodyLG
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Unlocks in:',
                        style: AppText.bodyMD
                            .copyWith(color: AppColors.textTertiary),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '04:59',
                        style: AppText.displayMedium
                            .copyWith(color: AppColors.errorPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.huge),
                TealButton(
                  'Try Again',
                  onPressed: () => context.go('/auth/login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
