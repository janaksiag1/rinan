import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 61 — Plans & Billing overview.
class BillingOverviewScreen extends ConsumerWidget {
  const BillingOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(creditsProvider);
    final history = ref.watch(billingHistoryProvider);
    final lastThree = history.take(3).toList();

    return Scaffold(
      appBar: const AppAppBar('Plans & Billing'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Current plan card —
            AppCard(
              color: AppColors.navyLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Plan', style: AppText.bodySM),
                  const SizedBox(height: 2),
                  Text(Mock.planName, style: AppText.headingXL),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Text('Renews 28 Jun 2026', style: AppText.bodySM),
                      const Spacer(),
                      TextActionButton(
                        'Change Plan →',
                        onPressed: () => _openPlanChangeSheet(context),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.xxl, color: AppColors.borderLight),
                  // — Credits section —
                  Row(
                    children: [
                      CircularGauge(
                        value: (credits / 500).clamp(0, 1),
                        centerLabel: '$credits',
                        subLabel: 'credits',
                        size: 80,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TealButton(
                              'Top Up →',
                              small: true,
                              fullWidth: false,
                              onPressed: () => context.push('/billing/topup'),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text('500 credits/month', style: AppText.bodySM),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader('Compare Plans', padding: EdgeInsets.only(bottom: AppSpacing.sm)),
            SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Mock.plans.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, i) => _PlanCompareCard(plan: Mock.plans[i]),
              ),
            ),
            const SectionHeader(
              'Billing History',
              padding: EdgeInsets.fromLTRB(0, AppSpacing.xl, 0, AppSpacing.sm),
            ),
            ...lastThree.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _CompactBillingRow(row: row),
                )),
            Center(
              child: TextActionButton(
                'View all →',
                onPressed: () => context.push('/billing/history'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPlanChangeSheet(BuildContext context) {
    showAppSheet(
      context,
      title: 'Change Plan',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...Mock.plans.map((p) {
            final isCurrent = p.name == 'Growth';
            final String action;
            final Color bg;
            final Color fg;
            if (isCurrent) {
              action = 'Current';
              bg = AppColors.navyLight;
              fg = AppColors.navyPrimary;
            } else if (p.credits > 500) {
              action = 'Upgrade';
              bg = AppColors.tealLight;
              fg = AppColors.tealPrimary;
            } else {
              action = 'Downgrade';
              bg = AppColors.bgTertiary;
              fg = AppColors.textTertiary;
            }
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(p.name,
                          style: AppText.headingSM.copyWith(color: AppColors.textPrimary)),
                    ),
                    MonoText(p.price, style: AppText.monoSM),
                    const SizedBox(width: AppSpacing.md),
                    AppChip(action, bg: bg, fg: fg),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),
          TealButton(
            'Confirm Plan Change',
            onPressed: () {
              Navigator.pop(context);
              showAppSnack(context, 'Plan change requested');
            },
          ),
        ],
      ),
    );
  }
}

class _PlanCompareCard extends StatelessWidget {
  const _PlanCompareCard({required this.plan});
  final Plan plan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(plan.name, style: AppText.headingMD)),
                if (plan.badge != null)
                  AppChip(plan.badge!, bg: AppColors.amberLight, fg: AppColors.amberPrimary, dense: true),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            MonoText(plan.price, style: AppText.mono),
            const SizedBox(height: AppSpacing.md),
            Text('${plan.credits} credits/month', style: AppText.bodySM),
            const SizedBox(height: AppSpacing.xs),
            Text(plan.banks, style: AppText.bodySM),
          ],
        ),
      ),
    );
  }
}

class _CompactBillingRow extends StatelessWidget {
  const _CompactBillingRow({required this.row});
  final BillingRow row;

  @override
  Widget build(BuildContext context) {
    final positive = row.amount > 0;
    final color = positive
        ? AppColors.successPrimary
        : (row.type == 'refund' ? AppColors.errorPrimary : AppColors.navyPrimary);
    final amt = '${positive ? '+' : '-'}${Fmt.money(row.amount.abs())}';
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.description,
                    style: AppText.bodyMD.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(Fmt.date(row.date), style: AppText.bodySM),
              ],
            ),
          ),
          MonoText(amt, color: color),
        ],
      ),
    );
  }
}
