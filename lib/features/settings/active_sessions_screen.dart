import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 105 — Active Sessions. Lists logged-in devices from sessionsProvider.
class ActiveSessionsScreen extends ConsumerWidget {
  const ActiveSessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(sessionsProvider);

    return Scaffold(
      appBar: AppAppBar('Active Sessions', actions: [
        TextButton(
          onPressed: () async {
            final ok = await showConfirmSheet(
              context,
              title: 'Log out all other sessions?',
              message:
                  'This signs out every device except this one. You stay logged in here.',
              confirmLabel: 'Log out others',
              destructive: true,
            );
            if (ok && context.mounted) {
              showAppSnack(context, 'Logged out all other sessions');
            }
          },
          child: Text('Log out all others',
              style:
                  AppText.buttonMD.copyWith(color: AppColors.errorPrimary)),
        ),
      ]),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: sessions.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) => _SessionCard(sessions[i]),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.session);
  final Session session;

  IconData get _icon {
    final d = session.device.toLowerCase();
    if (d.contains('iphone') || d.contains('pixel') || d.contains('phone')) {
      return Icons.smartphone;
    }
    if (d.contains('chrome') || d.contains('web') || d.contains('windows')) {
      return Icons.laptop;
    }
    return Icons.devices;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, size: 32, color: AppColors.tealPrimary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.device, style: AppText.headingSM),
                    Text(session.os,
                        style: AppText.bodyMD
                            .copyWith(color: AppColors.textSecondary)),
                    Text('Last active ${Fmt.ago(session.lastActive)}',
                        style: AppText.bodyMD
                            .copyWith(color: AppColors.textTertiary)),
                  ],
                ),
              ),
              if (session.current)
                const AppChip('This device',
                    bg: AppColors.tealLight, fg: AppColors.tealPrimary),
            ],
          ),
          if (session.suspicious) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 16, color: AppColors.amberPrimary),
                const SizedBox(width: 4),
                Text('Unfamiliar location',
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.amberPrimary)),
              ],
            ),
          ],
          if (!session.current) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: TextActionButton(
                'Revoke',
                color: AppColors.errorPrimary,
                onPressed: () =>
                    showAppSnack(context, 'Session revoked'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
