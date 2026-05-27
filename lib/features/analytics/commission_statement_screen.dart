import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 57 — Commission Statement. UI/UX only, mock data.
class CommissionStatementScreen extends ConsumerWidget {
  const CommissionStatementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(commissionsProvider);

    final totalGross = rows.fold<int>(0, (s, r) => s + r.gross);
    final totalNet = rows.fold<int>(0, (s, r) => s + r.net);
    const received = 18000;
    final pending = (totalNet - received).clamp(0, totalNet);

    final mono = AppText.monoSM.copyWith(color: AppColors.textPrimary);

    return Scaffold(
      appBar: AppAppBar(
        'Commission Statement',
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => showAppSnack(context, 'Exporting CSV…'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period chips
            const _PeriodChips(),
            const SizedBox(height: AppSpacing.lg),

            // Summary
            AppCard(
              color: AppColors.navyLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Earned', style: AppText.bodySM),
                  MonoText(Fmt.money(totalGross), style: AppText.headingXL),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Received', style: AppText.bodySM),
                            MonoText(Fmt.money(received),
                                style: AppText.headingMD),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pending', style: AppText.bodySM),
                            MonoText(
                              Fmt.money(pending),
                              style: AppText.headingMD,
                              color: AppColors.amberPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text('Transactions', style: AppText.headingSM),
            const SizedBox(height: AppSpacing.sm),

            // Data table
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
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Client')),
                    DataColumn(label: Text('Bank')),
                    DataColumn(label: Text('Disbursed'), numeric: true),
                    DataColumn(label: Text('Rate%'), numeric: true),
                    DataColumn(label: Text('Gross'), numeric: true),
                    DataColumn(label: Text('TDS'), numeric: true),
                    DataColumn(label: Text('Net'), numeric: true),
                  ],
                  rows: [
                    for (final CommissionRow r in rows)
                      DataRow(cells: [
                        DataCell(Text(Fmt.date(r.date))),
                        DataCell(Text(r.client)),
                        DataCell(Text(r.bank)),
                        DataCell(MonoText(Fmt.money(r.disbursed), style: mono)),
                        DataCell(MonoText(r.rate.toStringAsFixed(1), style: mono)),
                        DataCell(MonoText(Fmt.money(r.gross), style: mono)),
                        DataCell(MonoText(Fmt.money(r.tds), style: mono)),
                        DataCell(MonoText(Fmt.money(r.net), style: mono)),
                      ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _PeriodChips extends StatefulWidget {
  const _PeriodChips();

  @override
  State<_PeriodChips> createState() => _PeriodChipsState();
}

class _PeriodChipsState extends State<_PeriodChips> {
  static const _periods = ['This Month', '3M', '6M', 'Year'];
  String _period = 'This Month';

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
