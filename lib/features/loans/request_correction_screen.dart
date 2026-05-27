import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 5 — FRS 38: Request Correction (full-screen).
class RequestCorrectionScreen extends ConsumerStatefulWidget {
  const RequestCorrectionScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<RequestCorrectionScreen> createState() =>
      _RequestCorrectionScreenState();
}

class _RequestCorrectionScreenState
    extends ConsumerState<RequestCorrectionScreen> {
  static const List<({String issue, String desc})> _issues = [
    (issue: 'Wrong document uploaded', desc: 'The file does not match'),
    (issue: 'Document is blurry/unclear', desc: 'Text is not readable'),
    (issue: 'Information mismatch', desc: 'Details do not match records'),
    (issue: 'Missing pages', desc: 'Some pages were not included'),
    (issue: 'Expired document', desc: 'Validity date has passed'),
    (issue: 'Other', desc: 'Specify in the message below'),
  ];

  final Set<String> _selectedIssues = {};
  final Set<String> _selectedDocs = {};
  final _messageController = TextEditingController();
  bool _notifyWhatsApp = true;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loan = ref.watch(loanByIdProvider(widget.id));

    return Scaffold(
      appBar: const AppAppBar('Request Correction'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(
              text:
                  'Your agent will be notified and the customer portal will show the correction request.',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 20),
            Text('What needs to be corrected?', style: AppText.headingMD),
            Text('Select all that apply.',
                style:
                    AppText.bodyMD.copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: AppSpacing.md),
            for (final it in _issues) ...[
              _issueCard(it.issue, it.desc),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: 20),
            Text('Specify affected documents:', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final d in loan.documents)
                  AppFilterChip(
                    label: d.name,
                    selected: _selectedDocs.contains(d.id),
                    onTap: () => setState(() {
                      _selectedDocs.contains(d.id)
                          ? _selectedDocs.remove(d.id)
                          : _selectedDocs.add(d.id);
                    }),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Message to Client (optional)',
              hint: 'Add any specific instructions…',
              controller: _messageController,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Switch(
                  value: _notifyWhatsApp,
                  activeColor: AppColors.tealPrimary,
                  onChanged: (v) => setState(() => _notifyWhatsApp = v),
                ),
                Text('Notify via WhatsApp', style: AppText.bodyMD),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Send Correction Request',
          onPressed: () {
            showAppSnack(context, 'Correction requested ✓');
            context.pop();
          },
        ),
      ),
    );
  }

  Widget _issueCard(String issue, String desc) {
    final selected = _selectedIssues.contains(issue);
    return AppCard(
      onTap: () => setState(() {
        selected ? _selectedIssues.remove(issue) : _selectedIssues.add(issue);
      }),
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 1.5 : 0.5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: selected,
            activeColor: AppColors.tealPrimary,
            onChanged: (_) => setState(() {
              selected
                  ? _selectedIssues.remove(issue)
                  : _selectedIssues.add(issue);
            }),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(issue,
                    style: AppText.headingSM
                        .copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(desc,
                    style: AppText.bodySM
                        .copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
