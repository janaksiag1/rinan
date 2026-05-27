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

/// FRS 103 — Edit Profile. Profile-aware (agent vs reviewer fields).
class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAgent = ref.watch(profileProvider) == ProfileType.agent;

    return Scaffold(
      appBar: AppAppBar('Edit Profile', actions: [
        TextButton(
          onPressed: () {
            showAppSnack(context, 'Profile updated ✓');
            context.pop();
          },
          child: Text('Save',
              style: AppText.buttonMD.copyWith(color: AppColors.tealPrimary)),
        ),
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Photo picker —
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.tealLight,
                    child: Text('RS',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.tealPrimary)),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.navyPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: AppColors.bgSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            const AppTextField(
              label: 'Display Name',
              required: true,
              initialValue: 'Rahul Sharma',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppDropdown<String>(
              label: 'City',
              items: Mock.cities,
              itemLabel: (c) => c,
              value: 'Mumbai',
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.lg),

            if (isAgent) ..._agentFields() else ..._reviewerFields(),
          ],
        ),
      ),
    );
  }

  List<Widget> _agentFields() {
    final specs = const ['Personal Loan', 'Home Loan', 'Business Loan'];
    return [
      Text('Specialisations',
          style: AppText.bodyMD.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (var i = 0; i < Mock.loanTypes.length; i++)
            AppFilterChip(
              label: Mock.loanTypes[i],
              selected: specs.contains(Mock.loanTypes[i]),
              onTap: () {},
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      const AppTextField(label: 'DSA Code', initialValue: 'DSA-1042'),
      const SizedBox(height: AppSpacing.lg),
      const AppTextField(
        label: 'Short Bio',
        maxLines: 3,
        maxLength: 200,
        initialValue: 'Helping families find the right home loan since 2018.',
      ),
    ];
  }

  List<Widget> _reviewerFields() {
    return const [
      AppTextField(label: 'Designation', initialValue: 'Senior Credit Officer'),
      SizedBox(height: AppSpacing.lg),
      AppTextField(label: 'Bank Name', readOnly: true, initialValue: 'HDFC Bank'),
      SizedBox(height: AppSpacing.lg),
      AppTextField(label: 'Branch', initialValue: 'Bandra West, Mumbai'),
      SizedBox(height: AppSpacing.lg),
      AppTextField(label: 'GSTIN', initialValue: '27AABCH1234M1Z5'),
    ];
  }
}
