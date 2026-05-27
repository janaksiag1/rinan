import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 92 — Edit an existing rate (Reviewer). Loan type is locked.
class RateEditScreen extends ConsumerWidget {
  const RateEditScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rate = ref.watch(rateByIdProvider(id));

    return Scaffold(
      appBar: const AppAppBar('Edit Rate'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Loan Type',
              readOnly: true,
              initialValue: rate.loanType,
              suffix: const Icon(Icons.lock_outline,
                  size: 18, color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Interest Rate %',
              hint: 'e.g. 11.25',
              initialValue: rate.ratePct.toString(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Rate Type', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.sm),
            _RateTypeTile(
              label: rate.rateType,
              selected: true,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Offer Label',
              hint: 'e.g. Summer Special',
              initialValue: rate.label ?? '',
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppDatePicker(label: 'Effective From', required: true),
            const SizedBox(height: AppSpacing.lg),
            const AppDatePicker(label: 'Valid Until'),
            const SizedBox(height: AppSpacing.xxl),
            DangerButton(
              'Deactivate Rate',
              onPressed: () async {
                final ok = await showConfirmSheet(
                  context,
                  title: 'Deactivate rate?',
                  message:
                      'This rate will stop being offered to clients. You can publish a new rate any time.',
                  confirmLabel: 'Deactivate',
                  destructive: true,
                );
                if (ok && context.mounted) {
                  showAppSnack(context, 'Rate deactivated');
                  context.pop();
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Save Changes',
          onPressed: () {
            showAppSnack(context, 'Rate updated ✓');
            context.pop();
          },
        ),
      ),
    );
  }
}

class _RateTypeTile extends StatelessWidget {
  const _RateTypeTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.tealLight : null,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 1.5 : 0.5,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color: selected ? AppColors.tealPrimary : AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
