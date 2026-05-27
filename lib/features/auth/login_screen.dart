import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// Module 1 — Login. Two phases: mobile entry then OTP verification.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _otpPhase = false;
  bool _consent = false;
  final TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _otpPhase ? _buildOtpPhase() : _buildMobilePhase(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobilePhase() {
    return Column(
      key: const ValueKey('mobile'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.huge),
        const Center(
          child: Icon(Icons.account_balance, size: 56, color: AppColors.tealPrimary),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        Text(
          'Login to Riण',
          style: AppText.headingXL.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Enter your mobile number',
          style: AppText.bodyLG.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        AppPhoneField(controller: _phone, onChanged: (_) => setState(() {})),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _consent,
              onChanged: (v) => setState(() => _consent = v ?? false),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'I consent to processing my data per DPDP Act 2023 and Terms '
                  'of Service',
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        PrimaryButton(
          'Send OTP',
          onPressed: () => setState(() => _otpPhase = true),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: TextActionButton(
            'New to Riण? Learn more →',
            onPressed: () => showAppSnack(context, 'Learn more (demo)'),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpPhase() {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => setState(() => _otpPhase = false),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Verify OTP',
              style: AppText.headingXL.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Sent to +91 ·····3210',
          style: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        const AppOTPField(),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Resend OTP in 0:29',
          style: AppText.bodyMD.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.xxl),
        TealButton(
          'Verify',
          onPressed: () => context.go('/auth/select-profile'),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: TextActionButton(
            'Account locked? (demo)',
            onPressed: () => context.push('/auth/locked'),
          ),
        ),
      ],
    );
  }
}
