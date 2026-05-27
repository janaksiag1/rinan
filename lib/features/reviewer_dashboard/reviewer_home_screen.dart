import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 11 — Reviewer Home Dashboard (FRS screens 67–71). Rendered INSIDE the
/// bottom-nav shell, so no bottomNavigationBar / floatingActionButton here.
class ReviewerHomeScreen extends ConsumerWidget {
  const ReviewerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pipeline = Mock.reviewerPipeline;
    final kpis = Mock.reviewerKpis;
    final agents = ref.watch(agentsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.navyPrimary,
            elevation: 0,
            titleSpacing: AppSpacing.lg,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('HDFC Bank',
                    style: AppText.headingMD
                        .copyWith(color: AppColors.textPrimary)),
                Text('Suresh Iyer · RM',
                    style: AppText.bodySM
                        .copyWith(color: AppColors.textTertiary)),
              ],
            ),
            actions: const [NotificationBell()],
          ),

          // — Pipeline tiles —
          SliverToBoxAdapter(child: _PipelineTiles(pipeline: pipeline)),

          // — KPI cards —
          SliverToBoxAdapter(child: _ReviewerKpiRow(kpis: kpis)),

          // — Quick Actions —
          const SliverToBoxAdapter(child: SectionHeader('Quick Actions')),
          const SliverToBoxAdapter(child: _QuickActions()),

          // — Agent Activity —
          SliverToBoxAdapter(
            child: SectionHeader(
              'Agent Activity',
              trailing: TextActionButton(
                'See all →',
                onPressed: () => context.go('/agents'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  for (final entry in agents.take(5).toList().asMap().entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _AgentActivityRow(
                        agent: entry.value,
                        index: entry.key,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

class _PipelineTiles extends StatelessWidget {
  const _PipelineTiles({required this.pipeline});
  final Map<LoanStatus, int> pipeline;

  @override
  Widget build(BuildContext context) {
    final entries = pipeline.entries.toList();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            for (final e in entries)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: SizedBox(
                  width: 110,
                  height: 90,
                  child: AppCard(
                    onTap: () => context.go('/applications'),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MonoText('${e.value}',
                            style: AppText.headingLG.copyWith(color: e.key.fg)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          e.key.label,
                          textAlign: TextAlign.center,
                          style: AppText.bodyMD,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewerKpiRow extends StatelessWidget {
  const _ReviewerKpiRow({required this.kpis});
  final List<KpiCard> kpis;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            for (final k in kpis)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: SizedBox(
                  width: 150,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MonoText(k.value,
                            style: AppText.headingLG
                                .copyWith(color: AppColors.textPrimary)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(k.label, style: AppText.bodyMD),
                        const SizedBox(height: AppSpacing.sm),
                        if (k.delta != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                k.deltaUp
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 14,
                                color: k.deltaUp
                                    ? AppColors.successPrimary
                                    : AppColors.errorPrimary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                k.delta!,
                                style: AppText.bodySM.copyWith(
                                  color: k.deltaUp
                                      ? AppColors.successPrimary
                                      : AppColors.errorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final actions = <_QuickAction>[
      _QuickAction(Icons.fact_check_outlined, 'Pending Review',
          () => context.go('/applications')),
      _QuickAction(Icons.percent_outlined, 'Publish Rate',
          () => context.push('/rates/new')),
      _QuickAction(Icons.groups_outlined, 'Agent Network',
          () => context.go('/agents')),
      _QuickAction(Icons.insert_chart_outlined, 'Reports',
          () => context.push('/analytics')),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            Expanded(child: _QuickActionCard(action: actions[i])),
            if (i < actions.length - 1) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: action.onTap,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, size: 22, color: AppColors.navyPrimary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: AppText.bodySM.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AgentActivityRow extends StatelessWidget {
  const _AgentActivityRow({required this.agent, required this.index});
  final Agent agent;
  final int index;

  static const _verbs = [
    'submitted an application',
    'uploaded documents',
  ];
  // Static recent times so the feed reads naturally.
  static const _hoursAgo = [1, 3, 6, 22, 30];

  @override
  Widget build(BuildContext context) {
    final verb = _verbs[index % _verbs.length];
    final at = DateTime.now()
        .subtract(Duration(hours: _hoursAgo[index % _hoursAgo.length]));
    return InkWell(
      onTap: () => context.go('/applications'),
      child: Row(
        children: [
          InitialsAvatar(agent.initials, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(verb,
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.textPrimary)),
                Text(agent.name,
                    style: AppText.bodySM
                        .copyWith(color: AppColors.tealPrimary)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(Fmt.ago(at),
              style: AppText.bodySM.copyWith(color: AppColors.textTertiary)),
        ],
      ),
    );
  }
}
