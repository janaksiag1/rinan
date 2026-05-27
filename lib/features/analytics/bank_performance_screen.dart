import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 58 — Bank Performance. UI/UX only, mock data.
class BankPerformanceScreen extends ConsumerWidget {
  const BankPerformanceScreen({super.key, required this.id});
  final String id;

  static const _monthly = <double>[3, 5, 4, 6, 4, 7];
  static const _byType = <String, double>{
    'Personal Loan': 0.74,
    'Home Loan': 0.81,
    'Car Loan': 0.62,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(bankByIdProvider(id));

    return Scaffold(
      appBar: AppAppBar('${bank.shortName} Performance'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            Row(
              children: [
                Expanded(child: _statsCard('Applications', '24')),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _statsCard('Approvals', '17')),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _statsCard('Disbursed', '₹1.8Cr', mono: true)),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Monthly applications chart
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Applications', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(height: 180, child: _monthlyChart()),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Approval by loan type
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Approval by Loan Type', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.md),
                  for (final e in _byType.entries) _typeRow(e.key, e.value),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Recent applications
            Text('Recent Applications', style: AppText.headingSM),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingTextStyle: AppText.bodySM.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  dataTextStyle: AppText.bodyMD,
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(label: Text('Client')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Amount'), numeric: true),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: [
                    _recentRow('Amit Kumar', 'Personal', '₹5,00,000', 'Approved'),
                    _recentRow('Rahul Sharma', 'Home', '₹15,00,000', 'Disbursed'),
                    _recentRow('Sneha Reddy', 'Car', '₹8,00,000', 'Under Review'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextActionButton(
              'View all loans →',
              onPressed: () => context.go('/loans'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  // ───────────────────────── Helpers ─────────────────────────

  Widget _statsCard(String label, String value, {bool mono = false}) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.bodySM),
          const SizedBox(height: AppSpacing.xs),
          mono
              ? MonoText(value, style: AppText.headingMD)
              : Text(value, style: AppText.headingMD),
        ],
      ),
    );
  }

  Widget _monthlyChart() {
    final values = _monthly;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 8,
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
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
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
        barGroups: [
          for (int i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  color: AppColors.tealPrimary,
                  width: 18,
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

  Widget _typeRow(String name, double rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
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

  DataRow _recentRow(String client, String type, String amount, String status) {
    return DataRow(cells: [
      DataCell(Text(client)),
      DataCell(Text(type)),
      DataCell(MonoText(amount, style: AppText.monoSM.copyWith(
        color: AppColors.textPrimary,
      ))),
      DataCell(Text(status)),
    ]);
  }
}
