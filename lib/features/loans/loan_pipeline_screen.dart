import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 5 — FRS 32: Loan Pipeline. Renders inside the bottom-nav shell, so it
/// supplies no Scaffold bottom bar / FAB (the shell provides the FAB).
class LoanPipelineScreen extends ConsumerStatefulWidget {
  const LoanPipelineScreen({super.key});

  @override
  ConsumerState<LoanPipelineScreen> createState() => _LoanPipelineScreenState();
}

class _LoanPipelineScreenState extends ConsumerState<LoanPipelineScreen> {
  String? _selectedBankId; // null = All Banks

  // Tab definitions: label + optional status (null = "All").
  static const List<({String label, LoanStatus? status})> _tabs = [
    (label: 'All', status: null),
    (label: 'Draft', status: LoanStatus.draft),
    (label: 'Applied', status: LoanStatus.applied),
    (label: 'Submitted', status: LoanStatus.submitted),
    (label: 'Under Review', status: LoanStatus.underReview),
    (label: 'Approved', status: LoanStatus.approved),
    (label: 'Rejected', status: LoanStatus.rejected),
    (label: 'Sanctioned', status: LoanStatus.sanctioned),
    (label: 'Disbursed', status: LoanStatus.disbursed),
  ];

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(loansProvider);
    final banks = ref.watch(banksProvider);
    final counts = ref.watch(loanStatusCountsProvider);

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppAppBar(
          'Loan Pipeline',
          showBack: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showAppSnack(context, 'Search'),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => showAppSnack(context, 'Filters'),
            ),
          ],
        ),
        body: Column(
          children: [
            // — Bank filter chips —
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  AppFilterChip(
                    label: 'All Banks',
                    count: loans.length,
                    selected: _selectedBankId == null,
                    selectedColor: AppColors.tealPrimary,
                    onTap: () => setState(() => _selectedBankId = null),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  for (final b in banks) ...[
                    AppFilterChip(
                      label: b.shortName,
                      count: loans.where((l) => l.bankId == b.id).length,
                      selected: _selectedBankId == b.id,
                      selectedColor: AppColors.tealPrimary,
                      onTap: () => setState(() => _selectedBankId = b.id),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                ],
              ),
            ),
            // — Status tabs with count badges —
            TabBar(
              isScrollable: true,
              labelColor: AppColors.tealPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.tealPrimary,
              labelStyle: AppText.bodyMD.copyWith(fontWeight: FontWeight.w600),
              tabs: [
                for (final t in _tabs)
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(t.label),
                        const SizedBox(width: 6),
                        CountBadge(
                          t.status == null
                              ? loans.length
                              : (counts[t.status] ?? 0),
                          color: AppColors.navyPrimary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  for (final t in _tabs) _tabList(t.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabList(LoanStatus? status) {
    final loans = ref.watch(loansProvider).where((l) {
      final bankOk = _selectedBankId == null || l.bankId == _selectedBankId;
      final statusOk = status == null || l.status == status;
      return bankOk && statusOk;
    }).toList();

    if (loans.isEmpty) {
      return const AppEmptyState(
        icon: Icons.inbox_outlined,
        title: 'No applications',
        message: 'No loans match this filter yet.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: loans.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) => _LoanCard(loans[i]),
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard(this.loan);
  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final urgency = loan.urgency.color;
    return AppCard(
      onTap: () => context.push('/loans/${loan.id}'),
      leftBorderColor: urgency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: bank avatar + bank name + loan type chip
          Row(
            children: [
              BankInitialAvatar(loan.bankName[0], size: 36),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(loan.bankName, style: AppText.bodySM),
              ),
              AppChip(loan.loanType, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Row 2: client name + amount
          Row(
            children: [
              Expanded(
                child: Text(
                  loan.clientName,
                  style: AppText.headingSM.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              MonoText(Fmt.money(loan.amount), style: AppText.headingMD),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Row 3: submitted date + days open
          Row(
            children: [
              Text(Fmt.date(loan.submittedOn), style: AppText.bodySM),
              const Spacer(),
              Text(
                '${loan.daysOpen}d open',
                style: AppText.bodySM.copyWith(color: urgency),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: StatusBadge(loan.status),
          ),
        ],
      ),
    );
  }
}
