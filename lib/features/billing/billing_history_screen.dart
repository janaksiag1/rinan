import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 64 — Billing History.
class BillingHistoryScreen extends ConsumerWidget {
  const BillingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(billingHistoryProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppAppBar(
          'Billing History',
          actions: [
            IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () => showAppSnack(context, 'Statement downloaded'),
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.tealPrimary,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Plans'),
              Tab(text: 'Credits'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _HistoryList(rows: all),
            _HistoryList(rows: all.where((r) => r.type == 'subscription').toList()),
            _HistoryList(rows: all.where((r) => r.type == 'credit').toList()),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.rows});
  final List<BillingRow> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const AppEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No transactions',
        message: 'Transactions in this category will appear here.',
      );
    }

    // Group by month, preserving the input (newest-first) order.
    final groups = <String, List<BillingRow>>{};
    for (final r in rows) {
      final key = DateFormat('MMMM yyyy').format(r.date);
      groups.putIfAbsent(key, () => []).add(r);
    }

    final children = <Widget>[];
    groups.forEach((month, list) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.md, 0, AppSpacing.sm),
        child: Text(month, style: AppText.headingSM.copyWith(color: AppColors.textTertiary)),
      ));
      children.addAll(list.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _BillingRowCard(row: r),
          )));
    });

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: children,
    );
  }
}

class _BillingRowCard extends StatelessWidget {
  const _BillingRowCard({required this.row});
  final BillingRow row;

  @override
  Widget build(BuildContext context) {
    final positive = row.amount > 0;
    final amtColor = positive
        ? AppColors.successPrimary
        : (row.type == 'refund' ? AppColors.errorPrimary : AppColors.indigoSoft);
    final amt = '${positive ? '+' : '-'}${Fmt.money(row.amount.abs())}';

    final (IconData icon, Color bg, Color fg) typeStyle;
    switch (row.type) {
      case 'credit':
        typeStyle = (Icons.bolt, AppColors.tealLight, AppColors.tealPrimary);
        break;
      case 'refund':
        typeStyle = (Icons.replay, AppColors.errorLight, AppColors.errorPrimary);
        break;
      default:
        typeStyle = (Icons.workspace_premium_outlined, AppColors.navyLight, AppColors.indigoSoft);
    }

    return AppCard(
      onTap: () => _openInvoiceSheet(context),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: typeStyle.$2, shape: BoxShape.circle),
            child: Icon(typeStyle.$1, size: 18, color: typeStyle.$3),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.description,
                    style: AppText.headingSM.copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(Fmt.date(row.date), style: AppText.bodySM),
              ],
            ),
          ),
          MonoText(amt, color: amtColor),
        ],
      ),
    );
  }

  void _openInvoiceSheet(BuildContext context) {
    final total = row.amount.abs();
    final gst = (total * 0.18).round();
    final base = total - gst;
    showAppSheet(
      context,
      title: 'Invoice',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InvoiceLine('Invoice No', 'INV-${row.id.toUpperCase()}-2026'),
          _InvoiceLine('Amount', Fmt.money(base)),
          _InvoiceLine('GST (18%)', Fmt.money(gst)),
          const Divider(color: AppColors.borderLight),
          _InvoiceLine('Total', Fmt.money(total), bold: true),
          const SizedBox(height: AppSpacing.lg),
          TealButton(
            'Download PDF Invoice',
            icon: Icons.download_outlined,
            onPressed: () => showAppSnack(context, 'Invoice downloaded'),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: TextActionButton(
              'Email Invoice',
              onPressed: () => showAppSnack(context, 'Invoice emailed'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceLine extends StatelessWidget {
  const _InvoiceLine(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: bold
                    ? AppText.bodyLG.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)
                    : AppText.bodyMD),
          ),
          MonoText(
            value,
            style: bold ? AppText.mono : AppText.monoSM,
            color: bold ? AppColors.textPrimary : null,
          ),
        ],
      ),
    );
  }
}
