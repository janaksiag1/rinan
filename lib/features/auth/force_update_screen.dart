import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// Module 1 — Force update gate. Blocks the app until updated.
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.navyPrimary,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.tealPrimary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Riण',
                    style: AppText.headingXL
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  'App Update Required',
                  textAlign: TextAlign.center,
                  style: AppText.headingXL
                      .copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'A new version of Riण is available. Please update to '
                    'continue.',
                    textAlign: TextAlign.center,
                    style: AppText.bodyLG
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: AppSpacing.huge),
                TealButton(
                  'Update Now →',
                  onPressed: () => showAppSnack(context, 'Opening store…'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
