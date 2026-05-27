import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/widgets.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  bool _autoBirthday = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Add Client'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppTextField(label: 'Full Name', required: true),
            const SizedBox(height: 16),
            const AppPhoneField(label: 'Mobile'),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'City',
              items: Mock.cities,
              itemLabel: (c) => c,
              required: true,
              hint: 'Select city',
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const AppDatePicker(label: 'Date of Birth'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Auto-send birthday greeting',
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.textPrimary),
                  ),
                ),
                Switch(
                  value: _autoBirthday,
                  activeColor: AppColors.tealPrimary,
                  onChanged: (v) => setState(() => _autoBirthday = v),
                ),
              ],
            ),
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
              hint: 'Select source',
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Notes',
              maxLines: 4,
              maxLength: 500,
            ),
          ],
        ),
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Save Client',
          onPressed: () {
            showAppSnack(context, 'Client added ✓');
            context.pop();
          },
        ),
      ),
    );
  }
}
