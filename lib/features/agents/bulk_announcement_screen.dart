import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// FRS 97 — Bulk announcement to connected agents (Reviewer).
class BulkAnnouncementScreen extends StatefulWidget {
  const BulkAnnouncementScreen({super.key});

  @override
  State<BulkAnnouncementScreen> createState() => _BulkAnnouncementScreenState();
}

class _BulkAnnouncementScreenState extends State<BulkAnnouncementScreen> {
  final _subjectCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        'Announce to Agents',
        showBack: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(
              text: 'Message will be sent to all 12 connected agents.',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Subject',
              controller: _subjectCtrl,
              maxLength: 100,
              required: true,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Message Body',
              controller: _bodyCtrl,
              maxLines: 8,
              maxLength: 1000,
              required: true,
            ),
            const SizedBox(height: 16),
            AppCard(
              borderColor: AppColors.borderMid,
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    size: 20,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Add attachment (optional)',
                    style: AppText.bodyMD.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextActionButton(
              'Preview Message ↓',
              onPressed: () => showAppSnack(context, 'Preview'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Send to All 12 Agents →',
          onPressed: () {
            showAppSnack(context, 'Sent to 12 agents ✓');
            context.pop();
          },
        ),
      ),
    );
  }
}
