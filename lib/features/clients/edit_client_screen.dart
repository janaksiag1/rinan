import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

class EditClientScreen extends ConsumerWidget {
  const EditClientScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final client = ref.watch(clientByIdProvider(id));

    return Scaffold(
      appBar: const AppAppBar('Edit Client'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Full Name',
              required: true,
              initialValue: client.name,
              portalSynced: client.portalSynced,
            ),
            const SizedBox(height: 16),
            // Mobile is locked once a client exists.
            AppTextField(
              label: 'Mobile',
              readOnly: true,
              initialValue: client.maskedMobile,
              suffix: const Icon(Icons.lock_outline,
                  size: 18, color: AppColors.textTertiary),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              initialValue: client.email,
              portalSynced: client.portalSynced,
            ),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'City',
              items: Mock.cities,
              itemLabel: (c) => c,
              required: true,
              value: Mock.cities.contains(client.city) ? client.city : null,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const AppDatePicker(label: 'Date of Birth'),
            const SizedBox(height: 8),
            const _AutoGreetRow(),
            const SizedBox(height: 16),
            const AppDatePicker(label: 'Anniversary'),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Lead Source',
              items: const [
                'Referral',
                'Walk-in',
                'Social',
                'Existing Client',
                'Other',
              ],
              itemLabel: (s) => s,
              value: const [
                'Referral',
                'Walk-in',
                'Social',
                'Existing Client',
                'Other',
              ].contains(client.leadSource)
                  ? client.leadSource
                  : null,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Notes',
              maxLines: 4,
              maxLength: 500,
              initialValue: client.notes,
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Save Changes',
          onPressed: () {
            showAppSnack(context, 'Client updated ✓');
            context.pop();
          },
        ),
      ),
    );
  }
}

class _AutoGreetRow extends StatefulWidget {
  const _AutoGreetRow();

  @override
  State<_AutoGreetRow> createState() => _AutoGreetRowState();
}

class _AutoGreetRowState extends State<_AutoGreetRow> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Auto-send birthday greeting',
            style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
          ),
        ),
        Switch(
          value: _value,
          activeColor: AppColors.tealPrimary,
          onChanged: (v) => setState(() => _value = v),
        ),
      ],
    );
  }
}
