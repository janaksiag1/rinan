import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// FRS Screen 15 — Verify Your Identity (agent KYC overview).
class KycOverviewScreen extends StatelessWidget {
  const KycOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppAppBar('Verify Your Identity', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),
            const InfoBox(
              bg: AppColors.navyLight,
              fg: AppColors.textPrimary,
              icon: Icons.verified_user,
              text:
                  'KYC Required — Verify your identity to send loan offers.',
            ),
            const SizedBox(height: AppSpacing.xl),
            const _KycStepCard(
              number: 1,
              title: 'PAN',
              description: 'Permanent Account Number verification.',
              status: KycStatus.verified,
              actionLabel: 'View',
            ),
            const SizedBox(height: AppSpacing.md),
            const _KycStepCard(
              number: 2,
              title: 'Bank Account',
              description: 'Penny-drop bank account verification.',
              status: KycStatus.verified,
              actionLabel: 'View',
            ),
            const SizedBox(height: AppSpacing.md),
            const _KycStepCard(
              number: 3,
              title: 'DSA Agreement',
              description: 'Sign your DSA partnership agreement.',
              status: KycStatus.inProgress,
              actionLabel: 'Resume',
            ),
            const SizedBox(height: AppSpacing.md),
            const _KycStepCard(
              number: 4,
              title: 'Selfie',
              description: 'Live selfie for face match.',
              status: KycStatus.pending,
              actionLabel: 'Start',
            ),
            const SizedBox(height: AppSpacing.xxl),
            TealButton(
              'Complete & Start →',
              onPressed: () => context.push('/auth/quickstart'),
            ),
          ],
        ),
      ),
    );
  }
}

class _KycStepCard extends StatelessWidget {
  const _KycStepCard({
    required this.number,
    required this.title,
    required this.description,
    required this.status,
    required this.actionLabel,
  });

  final int number;
  final String title;
  final String description;
  final KycStatus status;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.navyPrimary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: AppText.headingSM.copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.headingMD),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppChip(status.label, bg: status.bg, fg: status.fg),
                    TextActionButton(actionLabel, onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
