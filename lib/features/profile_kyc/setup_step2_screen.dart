import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS Screen 11 (agent) / 12 (reviewer) — Set Up Profile, Step 2.
class SetupStep2Screen extends ConsumerStatefulWidget {
  const SetupStep2Screen({super.key});

  @override
  ConsumerState<SetupStep2Screen> createState() => _SetupStep2ScreenState();
}

class _SetupStep2ScreenState extends ConsumerState<SetupStep2Screen> {
  final Set<String> _specialisations = {};

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppAppBar(
        'Set Up Profile',
        showBack: false,
        trailingText: 'Step 2 of 3',
      ),
      body: Column(
        children: [
          const AppProgressBar(value: 0.66),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: profile == ProfileType.reviewer
                  ? _reviewerBody(context)
                  : _agentBody(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agentBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Text('Select your specialisations', style: AppText.headingMD),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Choose at least one loan type you work with.',
          style: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in Mock.loanTypes)
              AppFilterChip(
                label: type,
                selected: _specialisations.contains(type),
                onTap: () => setState(() {
                  if (!_specialisations.add(type)) {
                    _specialisations.remove(type);
                  }
                }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxxl),
        TealButton('Next →', onPressed: () => context.push('/auth/setup/3')),
      ],
    );
  }

  Widget _reviewerBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(
          label: 'Bank Name',
          hint: 'e.g. HDFC Bank',
          required: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppDropdown<String>(
          label: 'Bank Type',
          items: Mock.bankTypes,
          itemLabel: (t) => t,
          required: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(label: 'Branch Name'),
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(label: 'City', required: true),
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(
          label: 'GSTIN (optional)',
          hint: '15-character alphanumeric',
        ),
        const SizedBox(height: AppSpacing.xxxl),
        TealButton('Next →', onPressed: () => context.push('/auth/setup/3')),
      ],
    );
  }
}
