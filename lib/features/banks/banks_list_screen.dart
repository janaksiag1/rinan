import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 7 · FRS 46 — Bank Partners list (renders inside the bottom-nav shell).
class BanksListScreen extends ConsumerWidget {
  const BanksListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(banksProvider);

    return Scaffold(
      appBar: AppAppBar(
        'Bank Partners',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/banks/new'),
          ),
        ],
      ),
      body: banks.isEmpty
          ? AppEmptyState(
              icon: Icons.account_balance,
              title: 'No bank partners yet',
              message: 'Add your first bank to start sending offers.',
              action: TealButton(
                'Add Bank →',
                fullWidth: false,
                onPressed: () => context.push('/banks/new'),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: banks.length,
              itemBuilder: (context, i) => _BankPartnerCard(bank: banks[i]),
            ),
    );
  }
}

class _BankPartnerCard extends StatelessWidget {
  const _BankPartnerCard({required this.bank});
  final Bank bank;

  @override
  Widget build(BuildContext context) {
    final extra = bank.loanTypes.length > 3 ? bank.loanTypes.length - 3 : 0;
    final shown = bank.loanTypes.take(3).toList();

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      onTap: () => _openSheet(context, bank),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BankInitialAvatar(bank.initial, size: 44),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bank.name, style: AppText.headingMD),
                    const SizedBox(height: 2),
                    Text('${bank.rmName} · RM', style: AppText.bodyMD),
                    Text(bank.city, style: AppText.bodySM),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _PortalStatusChip(status: bank.portal),
                  IconButton(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.textTertiary),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _openSheet(context, bank),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final t in shown) AppChip(t, dense: true),
              if (extra > 0) AppChip('+$extra more', dense: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _PortalStatusChip extends StatelessWidget {
  const _PortalStatusChip({required this.status});
  final PortalStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == PortalStatus.connected) {
      return const AppChip(
        'Connected ✓',
        bg: AppColors.successLight,
        fg: AppColors.successPrimary,
      );
    }
    return const AppChip('Not Connected');
  }
}

void _openSheet(BuildContext context, Bank bank) {
  showAppSheet<void>(
    context,
    title: bank.name,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SheetTile(
          icon: Icons.edit_outlined,
          label: 'Edit Bank Details',
          onTap: () {
            Navigator.of(context).pop();
            context.push('/banks/${bank.id}/edit');
          },
        ),
        _SheetTile(
          icon: Icons.show_chart,
          label: 'View Rate History',
          onTap: () {
            Navigator.of(context).pop();
            context.push('/banks/${bank.id}/rates');
          },
        ),
        _SheetTile(
          icon: Icons.link,
          label: 'Connect Customer Portal',
          onTap: () {
            Navigator.of(context).pop();
            context.push('/banks/${bank.id}/connect');
          },
        ),
        ListTile(
          leading: const Icon(Icons.wifi_tethering,
              color: AppColors.textSecondary),
          title: Text('Portal Status', style: AppText.bodyLG),
          trailing: _PortalStatusChip(status: bank.portal),
        ),
        _SheetTile(
          icon: Icons.account_balance_wallet_outlined,
          label: 'View Active Loans',
          onTap: () {
            Navigator.of(context).pop();
            context.go('/loans');
          },
        ),
        _SheetTile(
          icon: Icons.pause_circle_outline,
          label: 'Pause Offers',
          onTap: () {
            Navigator.of(context).pop();
            showAppSnack(context, 'Offers paused for ${bank.name}');
          },
        ),
        const Divider(color: AppColors.borderLight),
        _SheetTile(
          icon: Icons.delete_outline,
          label: 'Delete Bank',
          color: AppColors.errorPrimary,
          onTap: () async {
            Navigator.of(context).pop();
            final ok = await showConfirmSheet(
              context,
              title: 'Delete ${bank.name}?',
              message:
                  'This will remove the bank partner and its rate history. This cannot be undone.',
              confirmLabel: 'Delete Bank',
              destructive: true,
            );
            if (ok && context.mounted) {
              showAppSnack(context, '${bank.name} deleted');
            }
          },
        ),
      ],
    ),
  );
}

class _SheetTile extends StatelessWidget {
  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return ListTile(
      leading: Icon(icon, color: c),
      title: Text(label, style: AppText.bodyLG.copyWith(color: c)),
      onTap: onTap,
    );
  }
}
