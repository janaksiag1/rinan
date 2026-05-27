import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 90 — Rates & Offers dashboard (Reviewer). Lives inside the bottom-nav
/// shell, so NO Scaffold bottomNavigationBar / floatingActionButton.
class RatesDashboardScreen extends ConsumerWidget {
  const RatesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rates = ref.watch(ratesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppAppBar(
          'Rates & Offers',
          showBack: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: TealButton(
                'Publish Rate',
                small: true,
                fullWidth: false,
                onPressed: () => context.push('/rates/new'),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.tealPrimary,
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActiveTab(rates: rates),
            _HistoryTab(rates: rates),
          ],
        ),
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  const _ActiveTab({required this.rates});
  final List<Rate> rates;

  @override
  Widget build(BuildContext context) {
    if (rates.isEmpty) {
      return AppEmptyState(
        icon: Icons.percent,
        title: 'No rates published',
        message: 'Publish your first rate to start sending offers to clients.',
        action: TealButton(
          'Publish Rate',
          fullWidth: false,
          onPressed: () => context.push('/rates/new'),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: rates.length,
      itemBuilder: (context, i) => _RateCard(rate: rates[i]),
    );
  }
}

class _RateCard extends StatelessWidget {
  const _RateCard({required this.rate});
  final Rate rate;

  void _openSheet(BuildContext context) {
    showAppSheet(
      context,
      title: rate.loanType,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined,
                color: AppColors.textSecondary),
            title: Text('Edit', style: AppText.bodyLG),
            onTap: () {
              Navigator.pop(context);
              context.push('/rates/${rate.id}/edit');
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.sync, color: AppColors.textSecondary),
            title: Text('Sync Status', style: AppText.bodyLG),
            onTap: () {
              Navigator.pop(context);
              context.push('/rates/${rate.id}/sync');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stale = rate.stale;
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: stale ? AppColors.warningLight : null,
      borderColor: stale ? AppColors.amberPrimary : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppChip(rate.loanType, bg: AppColors.navyLight,
                  fg: AppColors.indigoSoft),
              const SizedBox(width: AppSpacing.sm),
              MonoText('${rate.ratePct}%',
                  style: AppText.headingLG, color: AppColors.tealPrimary),
              const SizedBox(width: AppSpacing.xs),
              Text(rate.rateType, style: AppText.bodySM),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    color: AppColors.textTertiary),
                onPressed: () => _openSheet(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text('Effective ${Fmt.date(rate.effectiveFrom)}',
                    style: AppText.bodySM),
              ),
              rate.validUntil != null
                  ? Text('Until ${Fmt.date(rate.validUntil!)}',
                      style: AppText.bodySM)
                  : const AppChip('Ongoing'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text('${rate.offersSent} offers sent',
                    style: AppText.bodySM),
              ),
              if (stale)
                const AppChip('Update needed',
                    bg: AppColors.amberLight, fg: AppColors.amberPrimary),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.rates});
  final List<Rate> rates;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: rates.length,
      itemBuilder: (context, i) {
        final rate = rates[i];
        return AppCard(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              MonoText('${rate.ratePct}%',
                  style: AppText.headingSM, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rate.loanType, style: AppText.headingSM),
                    const SizedBox(height: 2),
                    Text('Effective ${Fmt.date(rate.effectiveFrom)}',
                        style: AppText.bodySM),
                  ],
                ),
              ),
              const AppChip('Expired',
                  bg: AppColors.bgTertiary, fg: AppColors.textTertiary),
            ],
          ),
        );
      },
    );
  }
}
