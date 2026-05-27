import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 42–44 — Send Loan Offer · Step 3 of 3: Preview & Send.
class OfferStep3Screen extends ConsumerStatefulWidget {
  const OfferStep3Screen({super.key});

  @override
  ConsumerState<OfferStep3Screen> createState() => _OfferStep3ScreenState();
}

class _OfferStep3ScreenState extends ConsumerState<OfferStep3Screen> {
  bool _emiOpen = true;
  int _tenure = 36;
  int _sendMode = 0;

  // Static mock EMI numbers (no real computation needed for the mock UI).
  final int _emi = 25737;
  final int _totalInterest = 126532;
  final int _totalAmount = 926532;

  static const _composedMessage =
      "Hi Rahul! Here's your pre-approved Personal Loan offer from HDFC Bank "
      'at 10.5% p.a. Tap the link to view details and apply. — sent via Riण.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Send Loan Offer'),
      body: Column(
        children: [
          const AppProgressBar(value: 1.0),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Step 3 of 3 — Preview & Send',
                style: AppText.bodySM,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              children: [
                // — WhatsApp preview —
                const SectionHeader('WhatsApp Preview'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AppCard(
                    color: AppColors.warningLight,
                    borderColor: AppColors.warningPrimary,
                    borderWidth: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.chat,
                                size: 20, color: AppColors.successPrimary),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'WhatsApp message preview',
                              style: AppText.bodySM
                                  .copyWith(color: AppColors.successPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppCard(
                          color: AppColors.bgSecondary,
                          child: Text(
                            _composedMessage,
                            style: AppText.bodyMD
                                .copyWith(color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // — EMI Calculator —
                SectionHeader(
                  'EMI Calculator',
                  trailing: IconButton(
                    icon: Icon(
                      _emiOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () => setState(() => _emiOpen = !_emiOpen),
                  ),
                ),
                if (_emiOpen)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: AppCard(
                      child: Column(
                        children: [
                          const AppMoneyField(label: 'Loan Amount'),
                          const SizedBox(height: AppSpacing.md),
                          AppDropdown<int>(
                            label: 'Tenure (months)',
                            items: const [12, 24, 36, 48, 60],
                            itemLabel: (m) => '$m months',
                            value: _tenure,
                            onChanged: (v) =>
                                setState(() => _tenure = v ?? _tenure),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            children: [
                              _OutputTile(
                                label: 'EMI',
                                value: '₹$_emi',
                                mono: true,
                              ),
                              _OutputTile(
                                label: 'Total Interest',
                                value: '₹$_totalInterest',
                              ),
                              _OutputTile(
                                label: 'Total Amount',
                                value: '₹$_totalAmount',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // — Send Method —
                const SectionHeader('Send Method'),
                _SendModeCard(
                  title: 'Send Now (1 credit)',
                  index: 0,
                  groupValue: _sendMode,
                  onChanged: (v) => setState(() => _sendMode = v),
                ),
                _SendModeCard(
                  title: 'Schedule Send (1 credit)',
                  index: 1,
                  groupValue: _sendMode,
                  onChanged: (v) => setState(() => _sendMode = v),
                ),
                _SendModeCard(
                  title: 'Copy Link Only (0 credits)',
                  index: 2,
                  groupValue: _sendMode,
                  onChanged: (v) => setState(() => _sendMode = v),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Preview & Send →',
          onPressed: _onSend,
        ),
      ),
    );
  }

  void _onSend() {
    final credits = ref.read(creditsProvider);
    if (credits <= 0) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgSecondary,
          title: Text('Out of Credits', style: AppText.headingMD),
          content: Text(
            'You have no credits left. Top up to send loan offers.',
            style: AppText.bodyMD,
          ),
          actions: [
            TealButton(
              'Top Up Credits →',
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/billing/topup');
              },
            ),
          ],
        ),
      );
      return;
    }

    showAppSheet<void>(
      context,
      title: 'Confirm Send',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            color: AppColors.navyLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SummaryRow('Sending to', 'Rahul Sharma'),
                const _SummaryRow('Via', 'HDFC Bank'),
                Row(
                  children: [
                    Expanded(
                      child: Text('Rate', style: AppText.bodySM),
                    ),
                    MonoText('10.5%', color: AppColors.textPrimary),
                  ],
                ),
                const SizedBox(height: 6),
                const _SummaryRow('Credits', '1 credit will be deducted'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Icon(Icons.bolt, size: 18, color: AppColors.tealPrimary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Balance after send: ${credits - 1} credits',
                style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Builder(
            builder: (ctx) => TealButton(
              'Confirm & Send ✓',
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/offer/sent');
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Builder(
            builder: (ctx) => Center(
              child: TextActionButton(
                'Cancel',
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutputTile extends StatelessWidget {
  const _OutputTile({
    required this.label,
    required this.value,
    this.mono = false,
  });

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          mono
              ? MonoText(value, style: AppText.headingMD)
              : Text(
                  value,
                  style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 2),
          Text(label, style: AppText.bodySM, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SendModeCard extends StatelessWidget {
  const _SendModeCard({
    required this.title,
    required this.index,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final int index;
  final int groupValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = index == groupValue;
    return AppCard(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      onTap: () => onChanged(index),
      color: selected ? AppColors.tealLight : null,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 1.5 : 0.5,
      child: Row(
        children: [
          Radio<int>(
            value: index,
            groupValue: groupValue,
            activeColor: AppColors.tealPrimary,
            onChanged: (v) => onChanged(v ?? index),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              title,
              style: AppText.bodyLG.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppText.bodySM)),
          Flexible(
            child: Text(
              value,
              style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
