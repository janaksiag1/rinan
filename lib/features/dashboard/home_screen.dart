import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';
import '../reviewer_dashboard/reviewer_home_screen.dart';

/// Module 3 — Agent Home Dashboard (FRS screens 17–23) and the profile switch
/// to the Reviewer dashboard. Rendered INSIDE the bottom-nav shell, so no
/// bottomNavigationBar / floatingActionButton here.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    if (profile == ProfileType.reviewer) {
      return const ReviewerHomeScreen();
    }
    return const _AgentHome();
  }
}

class _AgentHome extends ConsumerWidget {
  const _AgentHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credits = ref.watch(creditsProvider);
    final pending = ref.watch(pendingActionsProvider);
    final activity = ref.watch(activityProvider);
    final kpis = Mock.agentKpis;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.navyPrimary,
            elevation: 0,
            titleSpacing: AppSpacing.lg,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Good morning, Rahul 👋',
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.textPrimary)),
                Text(Fmt.date(DateTime.now()),
                    style: AppText.bodySM
                        .copyWith(color: AppColors.textTertiary)),
              ],
            ),
            actions: const [NotificationBell()],
          ),

          // — Credit bar —
          SliverToBoxAdapter(child: _CreditBar(credits: credits)),

          // — Low-credit banner (only < 50) —
          if (credits < 50)
            const SliverToBoxAdapter(child: _LowCreditBanner()),

          // — KPI row —
          SliverToBoxAdapter(child: _KpiRow(kpis: kpis)),

          // — Pending Actions —
          const SliverToBoxAdapter(child: SectionHeader('Pending Actions')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  for (final a in pending.take(5))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _PendingActionCard(action: a),
                    ),
                ],
              ),
            ),
          ),

          // — Recent Activity —
          SliverToBoxAdapter(
            child: SectionHeader(
              'Recent Activity',
              trailing: TextActionButton(
                'See all →',
                onPressed: () => context.push('/notifications'),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: [
                  for (final item in activity)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _ActivityRow(item: item),
                    ),
                ],
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

class _CreditBar extends StatelessWidget {
  const _CreditBar({required this.credits});
  final int credits;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navyPrimary,
      height: 64,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.bolt, size: 20, color: AppColors.tealPrimary),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MonoText('$credits',
                  style: AppText.headingMD
                      .copyWith(color: AppColors.textPrimary)),
              Text(Mock.planName,
                  style: AppText.bodySM
                      .copyWith(color: AppColors.textTertiary)),
            ],
          ),
          const Spacer(),
          TealButton(
            'Top Up',
            small: true,
            fullWidth: false,
            onPressed: () => context.push('/billing/topup'),
          ),
        ],
      ),
    );
  }
}

class _LowCreditBanner extends StatelessWidget {
  const _LowCreditBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
      child: InfoBox(
        text: 'Running low — top up now',
        bg: AppColors.warningLight,
        fg: AppColors.amberPrimary,
        icon: Icons.warning_amber_rounded,
      ),
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({required this.kpis});
  final List<KpiCard> kpis;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            for (final k in kpis)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: SizedBox(
                  width: 150,
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MonoText(k.value,
                            style: AppText.headingLG
                                .copyWith(color: AppColors.textPrimary)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(k.label, style: AppText.bodyMD),
                        const SizedBox(height: AppSpacing.sm),
                        if (k.delta != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                k.deltaUp
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 14,
                                color: k.deltaUp
                                    ? AppColors.successPrimary
                                    : AppColors.errorPrimary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                k.delta!,
                                style: AppText.bodySM.copyWith(
                                  color: k.deltaUp
                                      ? AppColors.successPrimary
                                      : AppColors.errorPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PendingActionCard extends StatelessWidget {
  const _PendingActionCard({required this.action});
  final PendingAction action;

  Color get _tint {
    switch (action.type) {
      case 'loan_status_change':
        return AppColors.tealLight;
      case 'doc_reuploaded':
        return AppColors.infoLight;
      case 'offer_not_opened_48h':
        return AppColors.warningLight;
      case 'idle_loan_7d':
        return AppColors.amberLight;
      case 'kyc_pending':
        return AppColors.errorLight;
      default:
        return AppColors.bgTertiary;
    }
  }

  IconData get _icon {
    switch (action.type) {
      case 'loan_status_change':
        return Icons.trending_up;
      case 'doc_reuploaded':
        return Icons.description_outlined;
      case 'offer_not_opened_48h':
        return Icons.mark_email_unread_outlined;
      case 'idle_loan_7d':
        return Icons.hourglass_empty;
      case 'kyc_pending':
        return Icons.badge_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => context.push('/applications'),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
            child: Icon(_icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action.title,
                    style: AppText.headingSM
                        .copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(action.subtitle, style: AppText.bodyMD),
                const SizedBox(height: 4),
                Text(Fmt.ago(action.at),
                    style: AppText.bodySM
                        .copyWith(color: AppColors.tealPrimary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});
  final ActivityItem item;

  Color get _tint {
    switch (item.type) {
      case 'offer_sent':
        return AppColors.tealLight;
      case 'status_change':
        return AppColors.warningLight;
      case 'doc_uploaded':
        return AppColors.infoLight;
      case 'payment':
        return AppColors.successLight;
      case 'client_added':
        return AppColors.purbg;
      default:
        return AppColors.bgTertiary;
    }
  }

  IconData get _icon {
    switch (item.type) {
      case 'offer_sent':
        return Icons.send_outlined;
      case 'status_change':
        return Icons.swap_horiz;
      case 'doc_uploaded':
        return Icons.upload_file_outlined;
      case 'payment':
        return Icons.payments_outlined;
      case 'client_added':
        return Icons.person_add_alt_1_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: _tint, shape: BoxShape.circle),
          child: Icon(_icon, size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.description,
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textPrimary)),
              Text(item.subject,
                  style: AppText.bodySM
                      .copyWith(color: AppColors.tealPrimary)),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(Fmt.ago(item.at),
            style: AppText.bodySM.copyWith(color: AppColors.textTertiary)),
      ],
    );
  }
}
