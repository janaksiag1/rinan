import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// FRS 45 — Offer Sent confirmation.
class OfferSentScreen extends StatelessWidget {
  const OfferSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.check_circle,
                      size: 48,
                      color: AppColors.successPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Offer Sent! ✓',
                    style: AppText.headingXL,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'WhatsApp message sent to Rahul Sharma',
                    style: AppText.bodyLG,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            MonoText('RIN-2026-0099', style: AppText.monoSM),
                            const Spacer(),
                            const AppChip('Copy', dense: true),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'HDFC Bank · ₹8,00,000',
                          style: AppText.bodyMD
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rahul Sharma',
                          style: AppText.bodyMD
                              .copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Sent just now', style: AppText.bodySM),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          'View Loan',
                          small: true,
                          onPressed: () => context.go('/loans'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TealButton(
                          'Send Another',
                          small: true,
                          onPressed: () => context.go('/offer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
