import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 7 · FRS 49 — Connect Customer Portal (full-screen, 4 steps).
class PortalConnectScreen extends ConsumerWidget {
  const PortalConnectScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(bankByIdProvider(id));

    return Scaffold(
      appBar: const AppAppBar('Connect Customer Portal'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Step 1 — Share Setup Link
            _StepCard(
              step: 1,
              title: 'Share Setup Link',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InfoBox(
                    icon: Icons.info_outline,
                    text:
                        'Send this secure link to the bank team. They use it to configure the customer portal connection.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TealButton(
                    'Copy Setup Link',
                    icon: Icons.copy,
                    onPressed: () =>
                        showAppSnack(context, 'Setup link copied to clipboard'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.bgTertiary,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(Icons.qr_code,
                          size: 64, color: AppColors.textTertiary),
                    ),
                  ),
                ],
              ),
            ),
            // Step 2 — Bank Team Configures
            _StepCard(
              step: 2,
              title: 'Bank Team Configures',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.hourglass_empty,
                      color: AppColors.amberPrimary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Waiting for ${bank.name} team to configure the portal…',
                      style: AppText.bodyMD,
                    ),
                  ),
                ],
              ),
            ),
            // Step 3 — Verify Connection
            _StepCard(
              step: 3,
              title: 'Verify Connection',
              child: Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.tealPrimary),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Checking connection…', style: AppText.bodyMD),
                ],
              ),
            ),
            // Step 4 — Done! Start Offering
            _StepCard(
              step: 4,
              title: 'Done! Start Offering',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portal connected. You can now send offers from ${bank.name}.',
                      style: AppText.bodyMD
                          .copyWith(color: AppColors.successPrimary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TealButton(
                      'Start Sending Offers →',
                      onPressed: () => context.go('/offer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.title,
    required this.child,
  });
  final int step;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.navyLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$step',
                  style: AppText.bodyMD.copyWith(
                    color: AppColors.navyPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(title, style: AppText.headingMD)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
