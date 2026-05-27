import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/constants/app_enums.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

class ClientsListScreen extends ConsumerStatefulWidget {
  const ClientsListScreen({super.key});

  @override
  ConsumerState<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends ConsumerState<ClientsListScreen> {
  // null selected = "All"
  LoanStatus? _selected; // null means All
  bool _allSelected = true;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientsProvider);

    int countFor(LoanStatus s) =>
        clients.where((c) => c.latestStatus == s).length;

    final filterDefs = <_FilterDef>[
      _FilterDef('All', null, clients.length),
      _FilterDef('Applied', LoanStatus.applied, countFor(LoanStatus.applied)),
      _FilterDef('Under Review', LoanStatus.underReview,
          countFor(LoanStatus.underReview)),
      _FilterDef(
          'Approved', LoanStatus.approved, countFor(LoanStatus.approved)),
      _FilterDef(
          'Rejected', LoanStatus.rejected, countFor(LoanStatus.rejected)),
      _FilterDef(
          'Disbursed', LoanStatus.disbursed, countFor(LoanStatus.disbursed)),
    ];

    final q = _query.trim().toLowerCase();
    final filtered = clients.where((c) {
      final matchesChip = _allSelected || c.latestStatus == _selected;
      final matchesSearch = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.mobile.contains(q) ||
          c.maskedMobile.toLowerCase().contains(q);
      return matchesChip && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppAppBar(
        'My Clients',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Import',
            onPressed: () => context.push('/clients/import'),
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Client',
            onPressed: () => context.push('/clients/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: AppSearchField(
              hint: 'Search by name or mobile',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: filterDefs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final f = filterDefs[i];
                final isAll = f.status == null;
                final selected =
                    isAll ? _allSelected : (!_allSelected && _selected == f.status);
                return Center(
                  child: AppFilterChip(
                    label: f.label,
                    count: f.count,
                    selected: selected,
                    onTap: () => setState(() {
                      if (isAll) {
                        _allSelected = true;
                        _selected = null;
                      } else {
                        _allSelected = false;
                        _selected = f.status;
                      }
                    }),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.borderLight),
          Expanded(
            child: filtered.isEmpty
                ? const AppEmptyState(
                    icon: Icons.people_outline,
                    title: 'No clients found',
                    message: 'Try a different filter or search term.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        _ClientCard(client: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterDef {
  const _FilterDef(this.label, this.status, this.count);
  final String label;
  final LoanStatus? status;
  final int count;
}

class _ClientCard extends StatelessWidget {
  const _ClientCard({required this.client});
  final Client client;

  @override
  Widget build(BuildContext context) {
    final c = client;
    return AppCard(
      onTap: () => context.push('/clients/${c.id}'),
      leftBorderColor:
          c.activeLoans > 0 ? AppColors.tealPrimary : AppColors.borderLight,
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            InitialsAvatar(c.initials, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.headingSM
                              .copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                      if (c.unread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.tealPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      const Spacer(),
                      if (c.latestStatus != null)
                        StatusBadge(c.latestStatus!),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        c.maskedMobile,
                        style:
                            AppText.bodySM.copyWith(color: AppColors.textLink),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          c.city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySM
                              .copyWith(color: AppColors.textTertiary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppChip('${c.activeLoans} active', dense: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
