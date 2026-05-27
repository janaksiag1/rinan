import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/widgets.dart';

/// FRS Screen 10 — Set Up Profile, Step 1 (basic profile details).
class SetupStep1Screen extends StatelessWidget {
  const SetupStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: const AppAppBar(
        'Set Up Profile',
        showBack: false,
        trailingText: 'Step 1 of 3',
      ),
      body: Column(
        children: [
          const AppProgressBar(value: 0.33),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.bgTertiary,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: AppColors.navyPrimary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const AppTextField(
                    label: 'Full Name',
                    hint: 'As on your Aadhaar card',
                    required: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const AppTextField(
                    label: 'Display Name',
                    hint: 'Auto-filled from full name',
                    helpText: 'This is shown to your clients',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppDropdown<String>(
                    label: 'City',
                    items: Mock.cities,
                    itemLabel: (c) => c,
                    hint: 'Select your city',
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  TealButton(
                    'Next →',
                    onPressed: () => context.push('/auth/setup/2'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
