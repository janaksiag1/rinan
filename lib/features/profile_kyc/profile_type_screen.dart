import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS Screen 9 — "What best describes you?" profile-type chooser.
class ProfileTypeScreen extends ConsumerStatefulWidget {
  const ProfileTypeScreen({super.key});

  @override
  ConsumerState<ProfileTypeScreen> createState() => _ProfileTypeScreenState();
}

class _ProfileTypeScreenState extends ConsumerState<ProfileTypeScreen> {
  ProfileType? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.huge),
              Text('What best describes you?', style: AppText.headingXL),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You can have both profiles on the same account later.',
                style: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _ProfileOptionCard(
                selected: _selected == ProfileType.agent,
                bg: AppColors.tealLight,
                accent: AppColors.tealPrimary,
                icon: Icons.person_outline,
                title: 'I am a Loan Agent',
                subtitle:
                    'I generate leads and send loan offers to clients',
                onTap: () => setState(() => _selected = ProfileType.agent),
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProfileOptionCard(
                selected: _selected == ProfileType.reviewer,
                bg: AppColors.errorLight,
                accent: AppColors.errorPrimary,
                icon: Icons.fact_check_outlined,
                title: 'I am a Reviewer',
                subtitle:
                    'I review and process loan applications at a bank',
                onTap: () => setState(() => _selected = ProfileType.reviewer),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              PrimaryButton(
                'Continue →',
                onPressed: _selected == null
                    ? null
                    : () {
                        ref.read(profileProvider.notifier).state = _selected!;
                        context.push('/auth/setup/1');
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOptionCard extends StatelessWidget {
  const _ProfileOptionCard({
    required this.selected,
    required this.bg,
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final Color bg;
  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: selected ? bg : AppColors.bgSecondary,
      borderColor: selected ? accent : AppColors.borderLight,
      borderWidth: selected ? 2 : 0.5,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(
        height: 160 - 2 * AppSpacing.lg,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: accent),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppText.headingMD),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle,
                        style: AppText.bodyMD
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.check_circle, color: accent, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}
