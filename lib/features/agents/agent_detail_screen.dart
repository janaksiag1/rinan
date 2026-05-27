import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';
import 'agents_list_screen.dart' show PortalStatusChip;

/// FRS 96 — Agent detail (Reviewer).
class AgentDetailScreen extends ConsumerWidget {
  const AgentDetailScreen({super.key, required this.id});
  final String id;

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
  static const _monthlyApps = <double>[5, 7, 4, 8, 6, 9];

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return AppColors.successPrimary;
      case 'dormant':
        return AppColors.amberPrimary;
      default:
        return AppColors.textTertiary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'dormant':
        return 'Dormant';
      default:
        return 'Not Connected';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agent = ref.watch(agentByIdProvider(id));
    final loans = ref.watch(loansProvider);
    final history = loans.take(5).toList();

    return Scaffold(
      appBar: AppAppBar(
        agent.name,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showPerformanceSheet(context, agent),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Header card —
            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InitialsAvatar(agent.initials, size: 56),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(agent.name, style: AppText.headingLG),
                        const SizedBox(height: 2),
                        MonoText(
                          agent.dsaCode,
                          style: AppText.monoSM,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          agent.city,
                          style: AppText.bodyMD.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppChip(
                          _statusLabel(agent.status),
                          bg: _statusColor(agent.status)
                              .withValues(alpha: 0.12),
                          fg: _statusColor(agent.status),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Metrics —
            Row(
              children: [
                Expanded(
                  child: _StatsCard(
                    label: 'Active Loans',
                    value: '${agent.activeLoans}',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatsCard(
                    label: 'This Month',
                    value: '${agent.thisMonth}',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatsCard(
                    label: 'Approval Rate',
                    value: '${agent.approvalRate.toInt()}%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Performance chart —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Performance', style: AppText.headingMD),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(height: 180, child: _performanceChart()),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Application history —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Application History', style: AppText.headingMD),
                  const SizedBox(height: AppSpacing.sm),
                  for (final l in history) _historyRow(l),
                  const SizedBox(height: AppSpacing.xs),
                  TextActionButton(
                    'View all →',
                    onPressed: () => context.go('/applications'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Connection —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Connection', style: AppText.headingMD),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      PortalStatusChip(portal: agent.portal),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Connected ${agent.connectedAt != null ? Fmt.date(agent.connectedAt!) : '—'}',
                          style: AppText.bodyMD.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DangerButton(
                    'Disconnect',
                    onPressed: () async {
                      final ok = await showConfirmSheet(
                        context,
                        title: 'Disconnect ${agent.name}?',
                        message:
                            'This agent will lose access to the portal and can no longer submit applications.',
                        confirmLabel: 'Disconnect',
                        destructive: true,
                      );
                      if (ok && context.mounted) {
                        showAppSnack(context, 'Agent disconnected');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyRow(Loan l) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MonoText(l.id, style: AppText.monoSM),
                const SizedBox(height: 2),
                Text(
                  l.clientName,
                  style: AppText.bodyMD.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          MonoText(Fmt.moneyCompact(l.amount), style: AppText.monoSM),
          const SizedBox(width: AppSpacing.md),
          StatusBadge(l.status),
        ],
      ),
    );
  }

  Widget _performanceChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 12,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= _months.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(_months[i], style: AppText.bodySM),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < _monthlyApps.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _monthlyApps[i],
                  color: AppColors.tealPrimary,
                  width: 20,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showPerformanceSheet(BuildContext context, Agent agent) {
    showAppSheet(
      context,
      title: agent.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _PerformanceRow(
            label: 'Active Loans',
            value: '${agent.activeLoans}',
          ),
          _PerformanceRow(
            label: 'Approval Rate',
            value: '${agent.approvalRate.toInt()}%',
          ),
          const _PerformanceRow(
            label: 'Avg Submission-to-Approval',
            value: '5.4 days',
          ),
          _PerformanceRow(
            label: 'Total Disbursed This Year',
            value: Fmt.money(8200000),
            mono: true,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(height: 120, child: _performanceChart()),
          const SizedBox(height: AppSpacing.sm),
          TextActionButton(
            'View All Applications →',
            onPressed: () {
              Navigator.of(context).maybePop();
              context.go('/applications');
            },
          ),
        ],
      ),
    );
  }
}

/// Compact metric card used in the metrics row.
class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.headingLG),
          const SizedBox(height: 2),
          Text(label, style: AppText.bodySM),
        ],
      ),
    );
  }
}

/// Label/value row used inside the performance sheet.
class _PerformanceRow extends StatelessWidget {
  const _PerformanceRow({
    required this.label,
    required this.value,
    this.mono = false,
  });
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppText.bodyMD.copyWith(color: AppColors.textSecondary),
            ),
          ),
          mono
              ? MonoText(value)
              : Text(
                  value,
                  style: AppText.bodyLG.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ],
      ),
    );
  }
}
