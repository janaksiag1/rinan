import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// Change Mobile Number (routed, not in FRS table by name).
class ChangeMobileScreen extends StatelessWidget {
  const ChangeMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Change Mobile Number'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(
              text: "You'll need to verify the new number with an OTP.",
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Current Number',
                style: AppText.bodyMD.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.bgTertiary,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const MonoText('+91 ·····3210'),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppPhoneField(label: 'New Mobile Number'),
            const SizedBox(height: AppSpacing.xl),
            TealButton(
              'Send OTP',
              onPressed: () => showAppSnack(context, 'OTP sent ✓'),
            ),
          ],
        ),
      ),
    );
  }
}
