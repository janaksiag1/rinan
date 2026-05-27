import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 17 — Settings home (FRS 102). Rendered inside the bottom-nav shell,
/// so it has NO bottomNavigationBar / floatingActionButton of its own.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final credits = ref.watch(creditsProvider);
    final isAgent = profile == ProfileType.agent;

    return Scaffold(
      appBar: const AppAppBar('Settings', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — Profile summary —
            AppCard(
              onTap: () => context.push('/settings/profile'),
              child: Row(
                children: [
                  const InitialsAvatar('RS', size: 48),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rahul Sharma', style: AppText.headingLG),
                        const SizedBox(height: 4),
                        AppChip(
                          profile.label,
                          bg: profile.color.withValues(alpha: 0.12),
                          fg: profile.color,
                        ),
                        const SizedBox(height: 4),
                        Text('Mumbai', style: AppText.bodyMD),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Profile switcher (demo) —
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Profile (demo)', style: AppText.headingSM),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      AppFilterChip(
                        label: ProfileType.agent.label,
                        selected: isAgent,
                        selectedColor: ProfileType.agent.color,
                        onTap: () {
                          ref.read(profileProvider.notifier).state =
                              ProfileType.agent;
                          showAppSnack(context, 'Switched profile');
                        },
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppFilterChip(
                        label: ProfileType.reviewer.label,
                        selected: !isAgent,
                        selectedColor: ProfileType.reviewer.color,
                        onTap: () {
                          ref.read(profileProvider.notifier).state =
                              ProfileType.reviewer;
                          showAppSnack(context, 'Switched profile');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // — Account —
            _ListSection('Account', children: [
              _NavTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () => context.push('/settings/profile'),
              ),
              _NavTile(
                icon: Icons.phone_iphone,
                title: 'Change Mobile Number',
                onTap: () => context.push('/settings/mobile'),
              ),
              _NavTile(
                icon: Icons.visibility_outlined,
                title: 'Pipeline Visibility',
                onTap: () => context.push('/settings/pipeline'),
              ),
            ]),

            // — Plan & Credits (agent only) —
            if (isAgent) ...[
              const SizedBox(height: AppSpacing.lg),
              SectionHeader('Plan & Credits',
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm)),
              AppCard(
                color: AppColors.navyLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Growth Plan', style: AppText.headingSM),
                            Text('Credits balance', style: AppText.bodySM),
                          ],
                        ),
                        MonoText('$credits',
                            style: AppText.headingLG, color: AppColors.textPrimary),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: TealButton(
                            'Top Up Credits',
                            small: true,
                            onPressed: () => context.push('/billing/topup'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextActionButton(
                          'View Plans',
                          onPressed: () => context.push('/billing'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.lg),

            // — Preferences —
            _ListSection('Preferences', children: [
              _NavTile(
                icon: Icons.notifications_outlined,
                title: 'Notification Preferences',
                onTap: () => context.push('/settings/notifications'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.language, color: AppColors.navyPrimary),
                title: Text('Language',
                    style: AppText.bodyLG.copyWith(color: AppColors.textPrimary)),
                trailing: const AppChip('EN'),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),

            // — Security —
            _ListSection('Security', children: [
              _NavTile(
                icon: Icons.devices_outlined,
                title: 'Active Sessions',
                onTap: () => context.push('/settings/security'),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),

            // — Help —
            _ListSection('Help', children: [
              _NavTile(
                icon: Icons.help_outline,
                title: 'Help Centre',
                onTap: () => context.push('/settings/help'),
              ),
              _NavTile(
                icon: Icons.chat_bubble_outline,
                title: 'Chat Support',
                onTap: () => context.push('/settings/support'),
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),

            // — Account Management —
            _ListSection('Account Management', children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:
                    const Icon(Icons.delete_outline, color: AppColors.errorPrimary),
                title: Text('Delete Account',
                    style: AppText.bodyLG
                        .copyWith(color: AppColors.errorPrimary)),
                trailing: const Icon(Icons.chevron_right,
                    color: AppColors.textTertiary),
                onTap: () => context.push('/settings/delete-account'),
              ),
            ]),

            const SizedBox(height: AppSpacing.lg),
            const Divider(color: AppColors.borderLight),
            const SizedBox(height: AppSpacing.lg),

            SecondaryButton(
              'Log Out',
              icon: Icons.logout,
              onPressed: () async {
                final ok = await showConfirmSheet(
                  context,
                  title: 'Log Out?',
                  message: 'You will need to sign in again to continue.',
                  confirmLabel: 'Log Out',
                  destructive: true,
                );
                if (ok && context.mounted) context.go('/auth/login');
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

/// A titled AppCard wrapping a list of nav rows.
class _ListSection extends StatelessWidget {
  const _ListSection(this.title, {required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title,
            padding: const EdgeInsets.only(bottom: AppSpacing.sm)),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.navyPrimary),
      title: Text(title,
          style: AppText.bodyLG.copyWith(color: AppColors.textPrimary)),
      trailing:
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
