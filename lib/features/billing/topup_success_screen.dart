import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/widgets.dart';

/// FRS 63 — Top Up success.
class TopUpSuccessScreen extends StatelessWidget {
  const TopUpSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: PopScope(
        canPop: false,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt, size: 48, color: AppColors.tealPrimary),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text('Credits Added! ✓', style: AppText.headingXL, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '+500 credits added to your account',
                    style: AppText.bodyLG,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('New Balance', style: AppText.bodySM),
                        const SizedBox(height: 2),
                        MonoText('820 credits',
                            style: AppText.headingXL, color: AppColors.tealPrimary),
                        const SizedBox(height: AppSpacing.md),
                        MonoText('Transaction ID: TXN-88213',
                            style: AppText.monoSM, color: AppColors.textTertiary),
                        const SizedBox(height: AppSpacing.xs),
                        Text('Date: ${Fmt.date(DateTime.now())}', style: AppText.bodyMD),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'GST Invoice will be sent to your email within 24 hours',
                    style: AppText.bodySM,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  PrimaryButton(
                    'Go to Dashboard →',
                    onPressed: () => context.go('/home'),
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
