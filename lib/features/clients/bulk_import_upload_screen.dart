import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

class BulkImportUploadScreen extends StatelessWidget {
  const BulkImportUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Import Clients'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(
              text: 'Download our template first to ensure correct format.',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 16),
            TealButton(
              'Download Template',
              icon: Icons.download_outlined,
              onPressed: () =>
                  showAppSnack(context, 'Template downloaded ✓'),
            ),
            const SizedBox(height: 20),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgTertiary,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: AppColors.borderMid,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload,
                      size: 48, color: AppColors.textTertiary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Drag and drop your CSV here',
                    style: AppText.bodyLG
                        .copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 4),
                  Text('or', style: AppText.bodySM),
                  const SizedBox(height: 4),
                  TealButton(
                    'Choose File',
                    small: true,
                    fullWidth: false,
                    onPressed: () =>
                        context.push('/clients/import/review'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Supported: .csv',
              style: AppText.bodySM.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
