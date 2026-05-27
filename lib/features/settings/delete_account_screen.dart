import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// FRS 108 — Delete Account. Typed confirmation gate.
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _confirmed => _controller.text.trim() == 'DELETE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar('Delete Account'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Icon(Icons.warning_amber_rounded,
                  size: 64, color: AppColors.errorPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Delete Your Account?',
                textAlign: TextAlign.center, style: AppText.headingXL),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'This will permanently delete all your data, clients, loan history, and billing records. This cannot be undone.',
              textAlign: TextAlign.center,
              style:
                  AppText.bodyLG.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              color: AppColors.errorLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Bullet('All clients'),
                  _Bullet('All loans'),
                  _Bullet('All messages'),
                  _Bullet('Billing data'),
                  _Bullet('KYC records'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Type DELETE to confirm:', style: AppText.headingMD),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: 'Type DELETE',
              controller: _controller,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.xl),
            DangerButton(
              'Permanently Delete Account',
              onPressed: _confirmed
                  ? () {
                      showAppSnack(context, 'Account scheduled for deletion');
                      context.go('/auth/login');
                    }
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: TextActionButton(
                'Keep My Account',
                onPressed: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.close, size: 16, color: AppColors.errorPrimary),
          const SizedBox(width: AppSpacing.sm),
          Text(text,
              style:
                  AppText.bodyMD.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
