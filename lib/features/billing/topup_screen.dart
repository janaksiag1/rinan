import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/models.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 62 — Top Up Credits.
class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen> {
  int _selectedPack = 1; // default to "Popular"
  int _payMethod = 0;

  static const _methods = [
    (Icons.account_balance_wallet_outlined, 'UPI'),
    (Icons.credit_card, 'Card'),
    (Icons.account_balance_outlined, 'Net Banking'),
    (Icons.wallet_outlined, 'Wallet'),
  ];

  @override
  Widget build(BuildContext context) {
    final packs = Mock.creditPacks;
    final selected = packs[_selectedPack];
    final balance = ref.watch(creditsProvider);
    final newBalance = balance + selected.credits;

    return Scaffold(
      appBar: const AppAppBar('Top Up Credits'),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Pay ₹${selected.price} →',
          onPressed: () => context.go('/billing/topup/success'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a credit pack', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              children: [
                for (int i = 0; i < packs.length; i++)
                  _CreditPackCard(
                    pack: packs[i],
                    selected: i == _selectedPack,
                    onTap: () => setState(() => _selectedPack = i),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.tealPrimary),
                  const SizedBox(width: AppSpacing.sm),
                  Text('After top up: ', style: AppText.bodyMD),
                  MonoText('$newBalance credits', color: AppColors.textPrimary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader('Payment Method', padding: EdgeInsets.only(bottom: AppSpacing.sm)),
            for (int i = 0; i < _methods.length; i++)
              _PaymentRow(
                icon: _methods[i].$1,
                name: _methods[i].$2,
                selected: i == _payMethod,
                onTap: () => setState(() => _payMethod = i),
              ),
          ],
        ),
      ),
    );
  }
}

class _CreditPackCard extends StatelessWidget {
  const _CreditPackCard({required this.pack, required this.selected, required this.onTap});
  final CreditPack pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg)? badgeStyle = pack.badge == null
        ? null
        : (pack.badge == 'Best Value'
            ? (AppColors.successLight, AppColors.successPrimary)
            : (AppColors.amberLight, AppColors.amberPrimary));
    return AppCard(
      onTap: onTap,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 2 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (badgeStyle != null)
                AppChip(pack.badge!, bg: badgeStyle.$1, fg: badgeStyle.$2, dense: true),
              const Spacer(),
              if (selected)
                const Icon(Icons.check_circle, size: 20, color: AppColors.tealPrimary),
            ],
          ),
          const Spacer(),
          MonoText('${pack.credits}',
              style: AppText.displayMedium.copyWith(fontSize: 32), color: AppColors.tealPrimary),
          const SizedBox(height: AppSpacing.xs),
          Text('₹${pack.price}', style: AppText.headingLG),
          const SizedBox(height: 2),
          Text('₹${pack.perCredit.toStringAsFixed(2)}/credit', style: AppText.bodySM),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.icon,
    required this.name,
    required this.selected,
    required this.onTap,
  });
  final IconData icon;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        borderColor: selected ? AppColors.tealPrimary : null,
        borderWidth: selected ? 1.5 : 0.5,
        child: Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: selected,
              activeColor: AppColors.tealPrimary,
              onChanged: (_) => onTap(),
            ),
            Icon(icon, size: 22, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Text(name, style: AppText.bodyLG.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
