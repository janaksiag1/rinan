import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 7 · FRS 48 — Edit Bank Partner (full-screen, prefilled).
class EditBankScreen extends ConsumerWidget {
  const EditBankScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bank = ref.watch(bankByIdProvider(id));
    final services = Mock.loanTypes.take(4).toList();

    return Scaffold(
      appBar: const AppAppBar('Edit Bank Partner'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Portal Status card (read-only).
            AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Portal Status', style: AppText.headingMD),
                        const SizedBox(height: AppSpacing.sm),
                        bank.portal == PortalStatus.connected
                            ? const AppChip(
                                'Connected ✓',
                                bg: AppColors.successLight,
                                fg: AppColors.successPrimary,
                              )
                            : const AppChip('Not Connected'),
                      ],
                    ),
                  ),
                  TextActionButton(
                    'Manage Connection →',
                    onPressed: () => context.push('/banks/$id/connect'),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Bank Details',
              children: [
                AppTextField(label: 'Bank Name', initialValue: bank.name),
                const SizedBox(height: AppSpacing.md),
                AppDropdown<String>(
                  label: 'Bank Type',
                  items: Mock.bankTypes,
                  itemLabel: (t) => t,
                  value: Mock.bankTypes.contains(bank.type) ? bank.type : null,
                  onChanged: (_) {},
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                    label: 'Branch Name', initialValue: bank.branch ?? ''),
                const SizedBox(height: AppSpacing.md),
                AppDropdown<String>(
                  label: 'City',
                  items: Mock.cities,
                  itemLabel: (c) => c,
                  value: Mock.cities.contains(bank.city) ? bank.city : null,
                  onChanged: (_) {},
                ),
              ],
            ),
            _Section(
              title: 'RM Contact',
              children: [
                AppTextField(
                    label: 'RM Full Name',
                    required: true,
                    initialValue: bank.rmName),
                const SizedBox(height: AppSpacing.md),
                const AppPhoneField(label: 'RM Mobile'),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  initialValue: bank.rmEmail ?? '',
                ),
              ],
            ),
            _Section(
              title: 'Loan Services',
              children: [
                for (final type in services) ...[
                  _ServiceTile(
                    type: type,
                    enabled: bank.loanTypes.contains(type),
                    rate: bank.rates[type],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Save Changes',
          onPressed: () {
            showAppSnack(context, 'Bank updated ✓');
            context.pop();
          },
        ),
      ),
    );
  }
}

class _ServiceTile extends StatefulWidget {
  const _ServiceTile({required this.type, required this.enabled, this.rate});
  final String type;
  final bool enabled;
  final double? rate;

  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile> {
  late bool _on = widget.enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.tealPrimary,
          title: Text(widget.type, style: AppText.bodyLG),
          value: _on,
          onChanged: (v) => setState(() => _on = v),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          child: _on
              ? Padding(
                  padding: const EdgeInsets.only(
                      bottom: AppSpacing.md, top: AppSpacing.xs),
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Rate %',
                        keyboardType: TextInputType.number,
                        initialValue: widget.rate?.toString(),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const AppMoneyField(label: 'Min Amount'),
                      const SizedBox(height: AppSpacing.sm),
                      const AppMoneyField(label: 'Max Amount'),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.headingMD),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}
