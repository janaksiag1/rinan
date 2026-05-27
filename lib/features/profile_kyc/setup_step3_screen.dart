import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS Screen 13 (agent) / 14 (reviewer) — Set Up Profile, Step 3.
class SetupStep3Screen extends ConsumerStatefulWidget {
  const SetupStep3Screen({super.key});

  @override
  ConsumerState<SetupStep3Screen> createState() => _SetupStep3ScreenState();
}

class _SetupStep3ScreenState extends ConsumerState<SetupStep3Screen> {
  int _selectedPlan = 0;
  final Set<String> _products = {};

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppAppBar(
        'Set Up Profile',
        showBack: false,
        trailingText: 'Step 3 of 3',
      ),
      body: Column(
        children: [
          const AppProgressBar(value: 1.0),
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
        Text('Choose your plan', style: AppText.headingMD),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Start free, upgrade anytime.',
          style: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: Mock.plans.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) => _PlanCard(
              plan: Mock.plans[i],
              selected: _selectedPlan == i,
              onTap: () => setState(() => _selectedPlan = i),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        TealButton(
          'Complete Setup →',
          onPressed: () => context.push('/auth/kyc'),
        ),
      ],
    );
  }

  Widget _reviewerBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(
          label: 'Your Full Name',
          hint: 'RM or processor name',
          required: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(
          label: 'Designation',
          hint: 'e.g. Senior Relationship Manager',
          required: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppTextField(
          label: 'Work Email',
          hint: 'your@bank.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Loan products you manage', style: AppText.headingMD),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in Mock.loanTypes)
              AppFilterChip(
                label: type,
                selected: _products.contains(type),
                onTap: () => setState(() {
                  if (!_products.add(type)) _products.remove(type);
                }),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxxl),
        TealButton(
          'Complete Setup →',
          onPressed: () => context.go('/home'),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final Plan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: AppCard(
        onTap: onTap,
        borderColor: selected ? AppColors.navyPrimary : AppColors.borderLight,
        borderWidth: selected ? 2 : 0.5,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(plan.name, style: AppText.headingMD),
                ),
                if (plan.badge != null)
                  AppChip(
                    plan.badge!,
                    bg: AppColors.navyLight,
                    fg: AppColors.navyPrimary,
                    dense: true,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            MonoText(plan.price, style: AppText.mono),
            const SizedBox(height: AppSpacing.md),
            _line(Icons.bolt_outlined, '${plan.credits} credits'),
            const SizedBox(height: AppSpacing.xs),
            _line(Icons.account_balance_outlined, plan.banks),
          ],
        ),
      ),
    );
  }

  Widget _line(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: AppText.bodyMD.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
