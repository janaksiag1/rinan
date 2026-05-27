import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 95 — Agent Network list (Reviewer). Renders inside the bottom-nav shell
/// so it provides NO Scaffold bottomNavigationBar / FAB.
class AgentsListScreen extends ConsumerStatefulWidget {
  const AgentsListScreen({super.key});

  @override
  ConsumerState<AgentsListScreen> createState() => _AgentsListScreenState();
}

class _AgentsListScreenState extends ConsumerState<AgentsListScreen> {
  String _query = '';
  String _filter = 'All';

  static const _filters = ['All', 'Active', 'Dormant', 'Not Connected'];

  bool _matchesFilter(Agent a) {
    switch (_filter) {
      case 'Active':
        return a.status == 'active';
      case 'Dormant':
        return a.status == 'dormant';
      case 'Not Connected':
        return a.status == 'not_connected';
      default:
        return true;
    }
  }

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
  Widget build(BuildContext context) {
    final agents = ref.watch(agentsProvider);
    final q = _query.trim().toLowerCase();
    final filtered = agents.where((a) {
      if (!_matchesFilter(a)) return false;
      if (q.isEmpty) return true;
      return a.name.toLowerCase().contains(q) ||
          a.dsaCode.toLowerCase().contains(q) ||
          a.city.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppAppBar(
        'Agent Network',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign_outlined),
            onPressed: () => context.push('/agents/announce'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: AppSearchField(
              hint: 'Search agents',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final f = _filters[i];
                return AppFilterChip(
                  label: f,
                  selected: _filter == f,
                  onTap: () => setState(() => _filter = f),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: filtered.isEmpty
                ? const AppEmptyState(
                    icon: Icons.people_outline,
                    title: 'No agents found',
                    message: 'Try a different search or filter.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, i) =>
                        _agentCard(context, filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _agentCard(BuildContext context, Agent a) {
    return AppCard(
      onTap: () => context.push('/agents/${a.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InitialsAvatar(a.initials, size: 44),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.name, style: AppText.headingMD),
                    const SizedBox(height: 2),
                    MonoText(
                      a.dsaCode,
                      style: AppText.monoSM,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.city,
                      style: AppText.bodyMD.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor(a.status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(_statusLabel(a.status), style: AppText.bodySM),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _PortalStatusChip(portal: a.portal),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              AppChip('${a.activeLoans} active', dense: true),
              const SizedBox(width: AppSpacing.sm),
              AppChip('${a.thisMonth} this month', dense: true),
              const SizedBox(width: AppSpacing.sm),
              AppChip('${a.approvalRate.toInt()}% approval', dense: true),
            ],
          ),
        ],
      ),
    );
  }
}

/// Portal connection chip used in the list & detail screens.
class _PortalStatusChip extends StatelessWidget {
  const _PortalStatusChip({required this.portal});
  final PortalStatus portal;

  @override
  Widget build(BuildContext context) {
    if (portal == PortalStatus.connected) {
      return const AppChip(
        'Connected ✓',
        bg: AppColors.successLight,
        fg: AppColors.successPrimary,
        dense: true,
      );
    }
    return const AppChip('Not Connected', dense: true);
  }
}

/// Exposed for the detail screen so the same chip styling is reused.
class PortalStatusChip extends StatelessWidget {
  const PortalStatusChip({super.key, required this.portal});
  final PortalStatus portal;

  @override
  Widget build(BuildContext context) => _PortalStatusChip(portal: portal);
}
