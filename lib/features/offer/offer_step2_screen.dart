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

/// FRS 41 — Send Loan Offer · Step 2 of 3: Choose Bank & Rate.
class OfferStep2Screen extends ConsumerStatefulWidget {
  const OfferStep2Screen({super.key});

  @override
  ConsumerState<OfferStep2Screen> createState() => _OfferStep2ScreenState();
}

class _OfferStep2ScreenState extends ConsumerState<OfferStep2Screen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final banks = ref.watch(banksProvider);

    return Scaffold(
      appBar: const AppAppBar('Send Loan Offer'),
      body: Column(
        children: [
          const AppProgressBar(value: 0.66),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Step 2 of 3 — Choose Bank & Rate',
                style: AppText.bodySM,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              itemCount: banks.length,
              itemBuilder: (_, i) => _BankRateCard(
                bank: banks[i],
                selected: banks[i].id == _selectedId,
                onTap: () => setState(() => _selectedId = banks[i].id),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Next: Preview →',
          onPressed: _selectedId != null
              ? () => context.push('/offer/step3')
              : null,
        ),
      ),
    );
  }
}

class _BankRateCard extends StatelessWidget {
  const _BankRateCard({
    required this.bank,
    required this.selected,
    required this.onTap,
  });

  final Bank bank;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final connected = bank.portal == PortalStatus.connected;
    final hasRate = bank.rates.isNotEmpty;
    final rateValue = hasRate ? bank.rates.values.first : null;
    final rateLabel = rateValue != null ? '${rateValue.toStringAsFixed(1)}%' : '—';

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs + 2,
      ),
      onTap: onTap,
      color: selected ? AppColors.tealLight : null,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 2 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              BankInitialAvatar(bank.initial, size: 44),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bank.name, style: AppText.headingMD),
                    const SizedBox(height: 2),
                    Text('${bank.rmName} · RM', style: AppText.bodySM),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (connected) ...[
                    const AppChip(
                      '● Live',
                      bg: AppColors.successLight,
                      fg: AppColors.successPrimary,
                      dense: true,
                    ),
                    const SizedBox(height: 4),
                    MonoText(
                      rateLabel,
                      style: AppText.headingLG,
                      color: AppColors.tealPrimary,
                    ),
                  ] else
                    MonoText(
                      rateLabel,
                      style: AppText.headingLG,
                      color: AppColors.textPrimary,
                    ),
                ],
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.check_circle, color: AppColors.tealPrimary),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final lt in bank.loanTypes) AppChip(lt, dense: true),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                'Rate: $rateLabel p.a.',
                style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(width: AppSpacing.sm),
              const AppChip('Reducing Balance', dense: true),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Min ₹50k — Max ₹50L',
                  style: AppText.bodySM,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
