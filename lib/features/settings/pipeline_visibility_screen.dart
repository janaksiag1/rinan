import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// FRS 104 — Pipeline Visibility. Local radio selection over 4 options.
class PipelineVisibilityScreen extends StatefulWidget {
  const PipelineVisibilityScreen({super.key});

  @override
  State<PipelineVisibilityScreen> createState() =>
      _PipelineVisibilityScreenState();
}

class _PipelineVisibilityScreenState extends State<PipelineVisibilityScreen> {
  int _selected = 0;

  static const _options = [
    (
      'Share with Everyone',
      'All connected agents and reviewers can view your full loan pipeline.'
    ),
    (
      'Share with Senior Only',
      'Only your senior or team lead can see your pipeline details.'
    ),
    (
      'Share with Team Only',
      'Visible to members of your team; hidden from outside the team.'
    ),
    (
      'Keep Private',
      'No one else can view your pipeline. Only you have access.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Pipeline Visibility'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(text: 'Controls who can see your loan pipeline.'),
            const SizedBox(height: AppSpacing.lg),
            for (var i = 0; i < _options.length; i++) ...[
              _RadioTile(
                title: _options[i].$1,
                description: _options[i].$2,
                selected: _selected == i,
                onTap: () => setState(() => _selected = i),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            const SizedBox(height: AppSpacing.sm),
            TealButton(
              'Save Preference',
              onPressed: () =>
                  showAppSnack(context, 'Visibility preference saved'),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  const _RadioTile({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.tealLight : null,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 2 : 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: selected ? AppColors.tealPrimary : AppColors.borderMid,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppText.bodyLG
                        .copyWith(color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(description,
                    style:
                        AppText.bodyMD.copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
