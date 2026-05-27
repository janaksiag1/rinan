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

/// Module 12 — FRS 72: Applications list (Reviewer side). Renders inside the
/// bottom-nav shell, so NO bottomNavigationBar / floatingActionButton.
class ApplicationsListScreen extends ConsumerStatefulWidget {
  const ApplicationsListScreen({super.key});

  @override
  ConsumerState<ApplicationsListScreen> createState() =>
      _ApplicationsListScreenState();
}

class _ApplicationsListScreenState
    extends ConsumerState<ApplicationsListScreen> {
  bool _showFilters = false;
  final Set<LoanStatus> _statusFilter = {};
  String _sort = 'Newest';

  static const _sortOptions = ['Newest', 'Oldest', 'Most Urgent', 'Amount'];

  List<Loan> _apply(List<Loan> loans) {
    var list = loans.toList();
    if (_statusFilter.isNotEmpty) {
      list = list.where((l) => _statusFilter.contains(l.status)).toList();
    }
    switch (_sort) {
      case 'Newest':
        list.sort((a, b) => a.daysOpen.compareTo(b.daysOpen));
        break;
      case 'Oldest':
        list.sort((a, b) => b.daysOpen.compareTo(a.daysOpen));
        break;
      case 'Most Urgent':
        list.sort((a, b) => b.daysOpen.compareTo(a.daysOpen));
        break;
      case 'Amount':
        list.sort((a, b) => b.amount.compareTo(a.amount));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final loans = _apply(ref.watch(loansProvider));

    return Scaffold(
      appBar: AppAppBar(
        'Applications',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showAppSnack(context, 'Search applications'),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _statusFilter.isEmpty
                  ? AppColors.textPrimary
                  : AppColors.tealPrimary,
            ),
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
        ],
      ),
      body: Column(
        children: [
          _filterPanel(),
          _sortBar(),
          Expanded(
            child: loans.isEmpty
                ? const AppEmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No applications',
                    message: 'No applications match the selected filters.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: loans.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, i) => _ApplicationCard(loan: loans[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: _showFilters ? null : 0,
      child: !_showFilters
          ? const SizedBox.shrink()
          : Container(
              width: double.infinity,
              color: AppColors.bgSecondary,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filter by status',
                      style: AppText.bodyMD.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      for (final s in LoanStatus.values)
                        AppFilterChip(
                          label: s.label,
                          selected: _statusFilter.contains(s),
                          selectedColor: s.fg,
                          onTap: () => setState(() {
                            if (_statusFilter.contains(s)) {
                              _statusFilter.remove(s);
                            } else {
                              _statusFilter.add(s);
                            }
                          }),
                        ),
                    ],
                  ),
                  if (_statusFilter.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Text('Applied:', style: AppText.bodySM),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.xs,
                            children: [
                              for (final s in _statusFilter)
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _statusFilter.remove(s)),
                                  child: AppChip(
                                    s.label,
                                    bg: s.bg,
                                    fg: s.fg,
                                    icon: Icons.close,
                                    dense: true,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        TextActionButton('Clear',
                            onPressed: () =>
                                setState(() => _statusFilter.clear())),
                      ],
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _sortBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.sort, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: AppSpacing.sm),
          Text('Sort', style: AppText.bodySM),
          const SizedBox(width: AppSpacing.sm),
          DropdownButton<String>(
            value: _sort,
            underline: const SizedBox.shrink(),
            isDense: true,
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textTertiary),
            style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            items: [
              for (final o in _sortOptions)
                DropdownMenuItem(value: o, child: Text(o)),
            ],
            onChanged: (v) => setState(() => _sort = v ?? _sort),
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.loan});
  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final urgency = loan.urgency;
    final overdue = loan.daysOpen >= 8;
    return AppCard(
      onTap: () => context.push('/applications/${loan.id}'),
      leftBorderColor: urgency.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1 — app id + status
          Row(
            children: [
              MonoText(loan.id,
                  style: AppText.monoSM, color: AppColors.textTertiary),
              const Spacer(),
              StatusBadge(loan.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Row 2 — client name + loan type
          Row(
            children: [
              Expanded(
                child: Text(loan.clientName,
                    style: AppText.headingSM
                        .copyWith(color: AppColors.textPrimary)),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppChip(loan.loanType, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          // Row 3 — agent name + amount
          Row(
            children: [
              Text(loan.agentName ?? 'Agent',
                  style: AppText.bodySM.copyWith(color: AppColors.tealPrimary)),
              const Spacer(),
              MonoText(Fmt.money(loan.amount), style: AppText.headingMD),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Row 4 — days open + docs
          Row(
            children: [
              Text('${loan.daysOpen}d open',
                  style: AppText.bodySM.copyWith(color: urgency.color)),
              if (overdue) ...[
                const SizedBox(width: AppSpacing.sm),
                const AppChip('Overdue',
                    bg: AppColors.warningLight,
                    fg: AppColors.amberPrimary,
                    icon: Icons.schedule,
                    dense: true),
              ],
              const Spacer(),
              Text('${loan.docsUploaded}/${loan.documents.length} docs ✓',
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
