import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/widgets.dart';

/// FRS 91 — Publish a new rate / offer (Reviewer). Full-screen form.
class PublishRateScreen extends StatefulWidget {
  const PublishRateScreen({super.key});

  @override
  State<PublishRateScreen> createState() => _PublishRateScreenState();
}

class _PublishRateScreenState extends State<PublishRateScreen> {
  String? _loanType;
  String _rateType = 'Reducing Balance';
  bool _ongoing = true;
  final _rateController = TextEditingController(text: '11.25');
  final _labelController = TextEditingController();

  @override
  void dispose() {
    _rateController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        'Publish Rate',
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<String>(
              label: 'Loan Type',
              required: true,
              hint: 'Select loan type',
              value: _loanType,
              items: Mock.loanTypes,
              itemLabel: (t) => t,
              onChanged: (v) => setState(() => _loanType = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Interest Rate %',
              hint: 'e.g. 11.25',
              controller: _rateController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Rate Type', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _RateTypeTile(
                    label: 'Flat Rate',
                    selected: _rateType == 'Flat',
                    onTap: () => setState(() => _rateType = 'Flat'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _RateTypeTile(
                    label: 'Reducing Balance',
                    selected: _rateType == 'Reducing Balance',
                    onTap: () =>
                        setState(() => _rateType = 'Reducing Balance'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Offer Label',
              hint: 'e.g. Summer Special',
              controller: _labelController,
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppDatePicker(label: 'Effective From', required: true),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Text('Valid Until', style: AppText.headingMD),
                const Spacer(),
                Text('Ongoing', style: AppText.bodyMD),
                Switch(
                  value: _ongoing,
                  activeColor: AppColors.tealPrimary,
                  onChanged: (v) => setState(() => _ongoing = v),
                ),
              ],
            ),
            if (!_ongoing) ...[
              const SizedBox(height: AppSpacing.sm),
              const AppDatePicker(label: 'Valid Until'),
            ],
            const SizedBox(height: AppSpacing.lg),
            const InfoBox(
              text:
                  'This overlaps with your 10.5% rate from 18 May. Overlapping rates will be deactivated.',
              bg: AppColors.warningLight,
              fg: AppColors.amberPrimary,
              icon: Icons.warning_amber_rounded,
            ),
            const SizedBox(height: AppSpacing.lg),
            _LivePreviewCard(
              loanType: _loanType,
              rate: _rateController.text,
              rateType: _rateType,
              label: _labelController.text,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Publish Rate →',
          onPressed: () {
            showAppSnack(context, 'Rate published ✓');
            context.pop();
          },
        ),
      ),
    );
  }
}

class _RateTypeTile extends StatelessWidget {
  const _RateTypeTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.tealLight : null,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 1.5 : 0.5,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color: selected ? AppColors.tealPrimary : AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LivePreviewCard extends StatelessWidget {
  const _LivePreviewCard({
    required this.loanType,
    required this.rate,
    required this.rateType,
    required this.label,
  });
  final String? loanType;
  final String rate;
  final String rateType;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Live Preview', style: AppText.headingSM),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          leftBorderColor: AppColors.tealPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppChip(loanType ?? 'Loan Type',
                      bg: AppColors.navyLight, fg: AppColors.indigoSoft),
                  const Spacer(),
                  if (label.isNotEmpty)
                    AppChip(label,
                        bg: AppColors.tealLight, fg: AppColors.tealPrimary),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  MonoText(
                    '${rate.isEmpty ? '0' : rate}%',
                    style: AppText.headingXL,
                    color: AppColors.tealPrimary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(rateType, style: AppText.bodySM),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Sent as an offer to your clients',
                  style: AppText.bodySM),
            ],
          ),
        ),
      ],
    );
  }
}
