import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/widgets.dart';

/// FRS 94 — Rate history with trend chart + table (Reviewer).
class RateHistoryScreen extends ConsumerWidget {
  const RateHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppAppBar('Rate History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<String>(
              label: 'Loan Type',
              value: Mock.loanTypes.first,
              items: Mock.loanTypes,
              itemLabel: (t) => t,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Rate Trend', style: AppText.headingSM),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: SizedBox(
                height: 200,
                child: _trendChart(),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('History', style: AppText.headingSM),
            const SizedBox(height: AppSpacing.md),
            _historyTable(),
          ],
        ),
      ),
    );
  }

  Widget _trendChart() {
    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
    const values = [10.5, 10.5, 11.0, 10.75, 11.25];
    final spots = <FlSpot>[
      for (int i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
    ];
    return LineChart(
      LineChartData(
        minY: 9,
        maxY: 13,
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
                final i = value.toInt();
                if (i < 0 || i >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(labels[i], style: AppText.bodySM),
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

  Widget _historyTable() {
    final rows = <_HistoryRow>[
      _HistoryRow('15 May', '11.25', 'Reducing', 'Ongoing', 'Active', '6', true),
      _HistoryRow('1 Apr', '10.75', 'Reducing', '14 May', 'Expired', '18', false),
      _HistoryRow('10 Mar', '11.00', 'Flat', '31 Mar', 'Expired', '12', false),
      _HistoryRow('5 Jan', '10.50', 'Reducing', '9 Mar', 'Expired', '24', false),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingTextStyle: AppText.bodySM.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        dataTextStyle: AppText.bodyMD,
        columnSpacing: AppSpacing.xl,
        columns: const [
          DataColumn(label: Text('Published')),
          DataColumn(label: Text('Rate %')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Valid Until')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Offers')),
        ],
        rows: [
          for (final r in rows)
            DataRow(
              color: WidgetStateProperty.resolveWith(
                (_) => r.active ? AppColors.successLight : null,
              ),
              cells: [
                DataCell(Text(r.published)),
                DataCell(MonoText(r.rate, style: AppText.monoSM)),
                DataCell(Text(r.type)),
                DataCell(Text(r.validUntil)),
                DataCell(Text(
                  r.status,
                  style: AppText.bodyMD.copyWith(
                    color: r.active
                        ? AppColors.successPrimary
                        : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                )),
                DataCell(MonoText(r.offers, style: AppText.monoSM)),
              ],
            ),
        ],
      ),
    );
  }
}

class _HistoryRow {
  const _HistoryRow(
    this.published,
    this.rate,
    this.type,
    this.validUntil,
    this.status,
    this.offers,
    this.active,
  );
  final String published;
  final String rate;
  final String type;
  final String validUntil;
  final String status;
  final String offers;
  final bool active;
}
