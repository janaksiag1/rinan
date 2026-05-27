import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/widgets.dart';

/// Module 7 · FRS 47 — Add Bank Partner (full-screen form).
class AddBankScreen extends StatefulWidget {
  const AddBankScreen({super.key});

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  static const _bankNames = [
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'SBI',
    'Kotak',
    'Other',
  ];

  String? _bankName;
  String? _bankType;
  String? _city;

  final Map<String, bool> _services = {};
  bool _customTemplate = false;

  @override
  Widget build(BuildContext context) {
    final loanServices = Mock.loanTypes.take(4).toList();

    return Scaffold(
      appBar: AppAppBar(
        'Add Bank Partner',
        showBack: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _Section(
              title: 'Bank Details',
              children: [
                AppDropdown<String>(
                  label: 'Bank Name',
                  items: _bankNames,
                  itemLabel: (s) => s,
                  value: _bankName,
                  hint: 'Select bank',
                  onChanged: (v) => setState(() => _bankName = v),
                ),
                const SizedBox(height: AppSpacing.md),
                AppDropdown<String>(
                  label: 'Bank Type',
                  items: Mock.bankTypes,
                  itemLabel: (t) => t,
                  value: _bankType,
                  hint: 'Select type',
                  onChanged: (v) => setState(() => _bankType = v),
                ),
                const SizedBox(height: AppSpacing.md),
                const AppTextField(label: 'Branch Name'),
                const SizedBox(height: AppSpacing.md),
                AppDropdown<String>(
                  label: 'City',
                  items: Mock.cities,
                  itemLabel: (c) => c,
                  value: _city,
                  hint: 'Select city',
                  onChanged: (v) => setState(() => _city = v),
                ),
              ],
            ),
            _Section(
              title: 'RM Contact',
              children: const [
                AppTextField(label: 'RM Full Name', required: true),
                SizedBox(height: AppSpacing.md),
                AppPhoneField(label: 'RM Mobile'),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
            _Section(
              title: 'Loan Services',
              children: [
                for (final type in loanServices) ...[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.tealPrimary,
                    title: Text(type, style: AppText.bodyLG),
                    value: _services[type] ?? false,
                    onChanged: (v) => setState(() => _services[type] = v),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 180),
                    child: (_services[type] ?? false)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.md, top: AppSpacing.xs),
                            child: Column(
                              children: const [
                                AppTextField(
                                  label: 'Rate %',
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppMoneyField(label: 'Min Amount'),
                                SizedBox(height: AppSpacing.sm),
                                AppMoneyField(label: 'Max Amount'),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
            _Section(
              title: 'DSA Code',
              children: const [
                AppTextField(label: 'DSA Code', hint: 'e.g. DSA-1042'),
              ],
            ),
            _Section(
              title: 'Message Template',
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Standard')),
                    ButtonSegment(value: true, label: Text('Custom')),
                  ],
                  selected: {_customTemplate},
                  onSelectionChanged: (s) =>
                      setState(() => _customTemplate = s.first),
                ),
                if (_customTemplate) ...[
                  const SizedBox(height: AppSpacing.md),
                  const AppTextField(
                    label: 'Custom Message',
                    hint: 'Write your offer message…',
                    maxLines: 4,
                    minLines: 3,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Save Bank →',
          onPressed: () {
            showAppSnack(context, 'Bank added ✓');
            context.pop();
          },
        ),
      ),
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
