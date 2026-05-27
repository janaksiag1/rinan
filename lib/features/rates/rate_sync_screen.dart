import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 93 — Rate sync status across connected agents (Reviewer).
class RateSyncScreen extends ConsumerWidget {
  const RateSyncScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rate = ref.watch(rateByIdProvider(id));
    final agents = ref.watch(agentsProvider);

    return Scaffold(
      appBar: AppAppBar('Rate Sync — ${rate.loanType}'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RateInfoCard(rate: rate),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Text('Agent Sync Status', style: AppText.headingMD),
                const Spacer(),
                TealButton(
                  'Force Sync All',
                  small: true,
                  fullWidth: false,
                  onPressed: () =>
                      showAppSnack(context, 'Syncing rate to all agents…'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: agents.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) =>
                  _AgentSyncRow(agent: agents[i], index: i),
            ),
          ],
        ),
      ),
    );
  }
}

class _RateInfoCard extends StatelessWidget {
  const _RateInfoCard({required this.rate});
  final Rate rate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              MonoText('${rate.ratePct}%',
                  style: AppText.headingLG, color: AppColors.tealPrimary),
              const SizedBox(width: AppSpacing.sm),
              Text(rate.rateType, style: AppText.bodySM),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Effective ${Fmt.date(rate.effectiveFrom)}',
              style: AppText.bodyMD),
          if (rate.validUntil != null)
            Text('Valid until ${Fmt.date(rate.validUntil!)}',
                style: AppText.bodyMD),
        ],
      ),
    );
  }
}

class _AgentSyncRow extends StatelessWidget {
  const _AgentSyncRow({required this.agent, required this.index});
  final Agent agent;
  final int index;

  @override
  Widget build(BuildContext context) {
    // Mock: treat connected portals as synced; vary a couple as not synced.
    final connected =
        agent.portal == PortalStatus.connected && index % 3 != 1;
    return AppCard(
      child: Row(
        children: [
          InitialsAvatar(agent.initials, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(agent.name, style: AppText.headingSM),
                MonoText(agent.dsaCode,
                    style: AppText.monoSM, color: AppColors.textTertiary),
              ],
            ),
          ),
          if (connected)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle,
                    size: 18, color: AppColors.successPrimary),
                const SizedBox(width: AppSpacing.xs),
                Text('Synced ✓',
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.successPrimary)),
              ],
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sync_problem,
                    size: 18, color: AppColors.amberPrimary),
                const SizedBox(width: AppSpacing.xs),
                Text('Not Synced',
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.amberPrimary)),
                const SizedBox(width: AppSpacing.xs),
                TextActionButton(
                  'Resync',
                  onPressed: () =>
                      showAppSnack(context, 'Resyncing ${agent.name}…'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
