import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

class ClientDetailScreen extends ConsumerStatefulWidget {
  const ClientDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ClientDetailScreen> createState() =>
      _ClientDetailScreenState();
}

class _ClientDetailScreenState extends ConsumerState<ClientDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final client = ref.watch(clientByIdProvider(widget.id));
    final loans = ref
        .watch(loansProvider)
        .where((l) => l.clientId == widget.id)
        .toList();
    final activity = ref.watch(activityProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppAppBar(
          client.name,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: () => context.push('/clients/${widget.id}/edit'),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.tealPrimary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.tealPrimary,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Loans'),
              Tab(text: 'Activity'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: _Header(client: client),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TealButton(
                      'Send Offer',
                      small: true,
                      onPressed: () => context.push('/offer'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SecondaryButton(
                      'View Loans',
                      small: true,
                      onPressed: () {
                        DefaultTabController.of(context).animateTo(1);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(client: client, loans: loans),
                  _LoansTab(loans: loans),
                  _ActivityTab(activity: activity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.client});
  final Client client;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          InitialsAvatar(client.initials, size: 56),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.name, style: AppText.headingLG),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone,
                        size: 16, color: AppColors.tealPrimary),
                    const SizedBox(width: 6),
                    Text(
                      client.maskedMobile,
                      style:
                          AppText.bodyLG.copyWith(color: AppColors.textLink),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${client.city} · Joined ${Fmt.date(client.addedOn)}',
                  style: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.client, required this.loans});
  final Client client;
  final List<Loan> loans;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact Info', style: AppText.headingSM),
              const SizedBox(height: 4),
              DetailRow('Mobile', client.maskedMobile),
              DetailRow('Email', client.email ?? '—'),
              DetailRow('City', client.city),
              DetailRow('Lead Source', client.leadSource),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loan Stats', style: AppText.headingSM),
              const SizedBox(height: 8),
              DetailRow('Active', '${client.activeLoans}',
                  valueStyle: AppText.mono),
              DetailRow('Completed', '${client.completedLoans}'),
              DetailRow(
                'Total Disbursed',
                Fmt.money(client.totalDisbursed),
                valueStyle: AppText.mono
                    .copyWith(color: AppColors.tealPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lead Info', style: AppText.headingSM),
              const SizedBox(height: 4),
              DetailRow('Source', client.leadSource),
              DetailRow('Added Date', Fmt.date(client.addedOn)),
              DetailRow(
                'Last Active',
                client.lastActive != null
                    ? Fmt.ago(client.lastActive!)
                    : '—',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('Notes', style: AppText.headingSM)),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.textTertiary),
                    onPressed: () =>
                        showAppSnack(context, 'Edit notes (mock)'),
                  ),
                ],
              ),
              Text(
                client.notes ?? 'No notes yet.',
                style: AppText.bodyMD,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoansTab extends StatelessWidget {
  const _LoansTab({required this.loans});
  final List<Loan> loans;

  @override
  Widget build(BuildContext context) {
    if (loans.isEmpty) {
      return AppEmptyState(
        icon: Icons.assignment_outlined,
        title: 'No loans yet',
        message: 'Send an offer to get this client started.',
        action: TealButton(
          'Send Offer →',
          fullWidth: false,
          onPressed: () => context.push('/offer'),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: loans.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final l = loans[i];
        return AppCard(
          onTap: () => context.push('/loans/${l.id}'),
          leftBorderColor: l.urgency.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BankInitialAvatar(l.bankName.substring(0, 1), size: 36),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      l.bankName,
                      style: AppText.headingSM
                          .copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                  AppChip(l.loanType, dense: true),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: MonoText(Fmt.money(l.amount))),
                  StatusBadge(l.status),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    Fmt.date(l.submittedOn),
                    style: AppText.bodySM,
                  ),
                  const SizedBox(width: 8),
                  Text('·', style: AppText.bodySM),
                  const SizedBox(width: 8),
                  Text(
                    '${l.daysOpen} days open',
                    style: AppText.bodySM.copyWith(color: l.urgency.color),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivityTab extends StatelessWidget {
  const _ActivityTab({required this.activity});
  final List<ActivityItem> activity;

  @override
  Widget build(BuildContext context) {
    final items = activity.take(6).toList();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: AppColors.borderLight),
      itemBuilder: (context, i) {
        final a = items[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.tealLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(_iconFor(a.type),
                    size: 18, color: AppColors.tealPrimary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.description,
                      style: AppText.bodyMD
                          .copyWith(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      a.subject,
                      style: AppText.bodySM
                          .copyWith(color: AppColors.tealPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(Fmt.ago(a.at), style: AppText.bodySM),
            ],
          ),
        );
      },
    );
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'offer_sent':
        return Icons.send_outlined;
      case 'status_change':
        return Icons.sync_alt;
      case 'doc_uploaded':
        return Icons.description_outlined;
      case 'payment':
        return Icons.payments_outlined;
      case 'client_added':
        return Icons.person_add_outlined;
      default:
        return Icons.bolt_outlined;
    }
  }
}
