import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// FRS Screen 16 — Welcome to Riण quick-start guide.
class QuickstartScreen extends StatelessWidget {
  const QuickstartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppAppBar('Welcome to Riण', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Icon(
                Icons.celebration,
                size: 64,
                color: AppColors.tealPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "You're all set! 🎉",
              textAlign: TextAlign.center,
              style: AppText.headingXL,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              "Here's how to make your first loan offer in 3 steps:",
              textAlign: TextAlign.center,
              style: AppText.bodyLG.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            const _QuickstartTile(
              number: 1,
              title: 'Add a bank partner',
              description: 'Connect a bank so you can send offers at their rates.',
              actionLabel: 'Add a bank partner',
            ),
            const SizedBox(height: AppSpacing.lg),
            const _QuickstartTile(
              number: 2,
              title: 'Add your first client',
              description: 'Save a client to start tracking their loan journey.',
              actionLabel: 'Add your first client',
            ),
            const SizedBox(height: AppSpacing.lg),
            const _QuickstartTile(
              number: 3,
              title: 'Send a loan offer',
              description: 'Pick a client and bank, then send the offer on WhatsApp.',
              actionLabel: 'Send a loan offer',
            ),
            const SizedBox(height: AppSpacing.xxxl),
            PrimaryButton(
              'Go to Dashboard →',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickstartTile extends StatelessWidget {
  const _QuickstartTile({
    required this.number,
    required this.title,
    required this.description,
    this.actionLabel,
  });

  final int number;
  final String title;
  final String description;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                style:
                    AppText.bodyMD.copyWith(color: AppColors.textSecondary),
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: AppSpacing.sm),
                TealButton(
                  actionLabel!,
                  small: true,
                  fullWidth: false,
                  onPressed: () {},
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
