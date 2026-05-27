import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// Module 16 · FRS 100 — Notification preferences (full-screen, pushed).
class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _statusChanges = true;
  bool _newApplications = true;
  bool _creditLow = true;
  bool _documentUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Notification Preferences'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Push', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _switch(
                    title: 'Status changes',
                    subtitle: 'When a loan application moves to a new stage.',
                    value: _statusChanges,
                    onChanged: (v) => setState(() => _statusChanges = v),
                  ),
                  _switch(
                    title: 'New applications',
                    subtitle: 'When a new loan application is created.',
                    value: _newApplications,
                    onChanged: (v) => setState(() => _newApplications = v),
                  ),
                  _switch(
                    title: 'Credit low',
                    subtitle: 'When your credit balance is running low.',
                    value: _creditLow,
                    onChanged: (v) => setState(() => _creditLow = v),
                  ),
                  _switch(
                    title: 'Document updates',
                    subtitle: 'When documents are uploaded or reviewed.',
                    value: _documentUpdates,
                    onChanged: (v) => setState(() => _documentUpdates = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('WhatsApp', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.sm),
            const InfoBox(
              text:
                  'WhatsApp notifications are sent by your agent platform and cannot be disabled here.',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            TealButton(
              'Save Preferences',
              onPressed: () => showAppSnack(context, 'Preferences saved ✓'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      activeColor: AppColors.tealPrimary,
      title: Text(
        title,
        style: AppText.headingSM.copyWith(color: AppColors.textPrimary),
      ),
      subtitle: Text(subtitle, style: AppText.bodyMD),
      value: value,
      onChanged: onChanged,
    );
  }
}
