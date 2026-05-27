import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 7 · FRS 50 — Bank rates: live rates, history chart & table.
class BankRatesScreen extends ConsumerWidget {
  const BankRatesScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(bankByIdProvider(id));
    final entries = bank.rates.entries.toList();

    return Scaffold(
      appBar: AppAppBar('${bank.shortName} Rates'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Rates
            AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Rates', style: AppText.headingMD),
                  const SizedBox(height: AppSpacing.md),
                  if (entries.isEmpty)
                    Text('No rates configured yet.', style: AppText.bodyMD)
                  else
                    for (final e in entries)
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          children: [
                            Expanded(child: AppChip(e.key, dense: true)),
                            const SizedBox(width: AppSpacing.sm),
                            MonoText(
                              '${e.value}%',
                              style: AppText.headingLG,
                              color: AppColors.tealPrimary,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              'Effective ${Fmt.date(DateTime.now())}',
                              style: AppText.bodySM,
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
            // Rate History chart
            AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rate History', style: AppText.headingMD),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        minY: 7,
                        maxY: 12,
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 32),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 24),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: AppColors.tealPrimary,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            spots: const [
                              FlSpot(0, 8.4),
                              FlSpot(1, 8.6),
                              FlSpot(2, 8.5),
                              FlSpot(3, 9.0),
                              FlSpot(4, 8.8),
                              FlSpot(5, 8.4),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // History table
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Change Log', style: AppText.headingMD),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Rate%')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Offers Sent')),
                      ],
                      rows: _mockRows
                          .map(
                            (r) => DataRow(cells: [
                              DataCell(Text(r.date, style: AppText.bodySM)),
                              DataCell(MonoText(r.rate, style: AppText.monoSM)),
                              DataCell(Text(r.type, style: AppText.bodySM)),
                              DataCell(
                                  MonoText(r.offers, style: AppText.monoSM)),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _mockRows = [
    _RateRow('12 May 2026', '8.4%', 'Home Loan', '12'),
    _RateRow('28 Apr 2026', '8.8%', 'Home Loan', '9'),
    _RateRow('10 Apr 2026', '9.0%', 'Home Loan', '6'),
    _RateRow('22 Mar 2026', '8.5%', 'Home Loan', '4'),
  ];
}

class _RateRow {
  const _RateRow(this.date, this.rate, this.type, this.offers);
  final String date;
  final String rate;
  final String type;
  final String offers;
}
