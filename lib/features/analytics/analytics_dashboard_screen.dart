import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 56 — Analytics Dashboard. UI/UX only, mock data.
class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState
    extends ConsumerState<AnalyticsDashboardScreen> {
  static const _periods = ['This Month', '3M', '6M', 'Year'];
  String _period = 'This Month';

  // — Funnel —
  static const _funnel = <String, double>{
    'Offers': 120,
    'Applied': 80,
    'Approved': 54,
    'Disbursed': 40,
  };

  // — Monthly volume (8 static points) —
  static const _volume = <double>[12, 18, 15, 22, 19, 26, 24, 31];

  // — Bank approval rates —
  static const _bankRates = <String, double>{
    'HDFC': 0.78,
    'ICICI': 0.71,
    'Axis': 0.66,
    'SBI': 0.58,
  };

  // — Lead source —
  late final List<_PieSlice> _leadSources = const [
    _PieSlice('Referral', 38, AppColors.tealPrimary),
    _PieSlice('Social', 24, AppColors.infoPrimary),
    _PieSlice('Walk-in', 18, AppColors.amberPrimary),
    _PieSlice('Existing', 12, AppColors.purplePrimary),
    _PieSlice('Other', 8, AppColors.textTertiary),
  ];

  void _openFilterSheet() {
    Bank? bank;
    showAppSheet<void>(
      context,
      title: 'Filter Analytics',
      child: StatefulBuilder(
        builder: (ctx, setSheet) {
          final banks = ref.read(banksProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppDropdown<Bank>(
                label: 'Bank',
                items: banks,
                itemLabel: (b) => b.name,
                value: bank,
                hint: 'All banks',
                onChanged: (b) => setSheet(() => bank = b),
              ),
              const SizedBox(height: AppSpacing.xl),
              TealButton(
                'Apply',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  showAppSnack(context, 'Filter applied');
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        'Analytics',
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period chips
            Row(
              children: [
                for (final p in _periods) ...[
                  AppFilterChip(
                    label: p,
                    selected: _period == p,
                    onTap: () => setState(() => _period = p),
                  ),
                  if (p != _periods.last) const SizedBox(width: AppSpacing.sm),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Conversion Funnel —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Conversion Funnel', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(height: 200, child: _funnelChart()),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Monthly Volume —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Volume', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(height: 200, child: _volumeChart()),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Bank Approval Rate —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bank Approval Rate', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.md),
                  for (final e in _bankRates.entries) _bankRateRow(e.key, e.value),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Lead Source —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lead Source', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(height: 200, child: _leadSourceChart()),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final s in _leadSources) _legendDot(s),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Commission Summary —
            AppCard(
              color: AppColors.navyLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commission Summary', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.md),
                  Text('Total Earned', style: AppText.bodySM),
                  MonoText(Fmt.money(30000), style: AppText.headingXL),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Received', style: AppText.bodySM),
                            MonoText(Fmt.money(18000), style: AppText.headingMD),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pending', style: AppText.bodySM),
                            MonoText(
                              Fmt.money(12000),
                              style: AppText.headingMD,
                              color: AppColors.amberPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextActionButton(
                    'View Full Statement →',
                    onPressed: () => context.push('/analytics/commission'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Charts ─────────────────────────

  Widget _funnelChart() {
    final labels = _funnel.keys.toList();
    final values = _funnel.values.toList();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 140,
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
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= labels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i], style: AppText.bodySM),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (int i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: AppColors.tealPrimary,
                  width: 24,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _volumeChart() {
    final spots = <FlSpot>[
      for (int i = 0; i < _volume.length; i++)
        FlSpot(i.toDouble(), _volume[i]),
    ];
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 40,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 32),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A'];
                final i = value.toInt();
                if (i < 0 || i >= months.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(months[i], style: AppText.bodySM),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.tealPrimary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.tealPrimary.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leadSourceChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          for (final s in _leadSources)
            PieChartSectionData(
              value: s.value,
              color: s.color,
              title: '${s.value.toInt()}%',
              radius: 56,
              titleStyle: AppText.bodySM.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Widget _bankRateRow(String name, double rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(name, style: AppText.bodyMD),
          ),
          Expanded(
            child: AppProgressBar(
              value: rate,
              color: AppColors.successPrimary,
              height: 8,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 44,
            child: Text(
              '${(rate * 100).round()}%',
              textAlign: TextAlign.right,
              style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(_PieSlice s) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(s.label, style: AppText.bodySM),
      ],
    );
  }
}

class _PieSlice {
  final String label;
  final double value;
  final Color color;
  const _PieSlice(this.label, this.value, this.color);
}
