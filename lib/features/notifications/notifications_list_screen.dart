import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 16 · FRS 99 — Notifications list (full-screen, pushed).
class NotificationsListScreen extends ConsumerStatefulWidget {
  const NotificationsListScreen({super.key});

  @override
  ConsumerState<NotificationsListScreen> createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState
    extends ConsumerState<NotificationsListScreen> {
  static const _filters = ['All', 'Loans', 'Clients', 'Billing', 'System'];
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(notificationsProvider);
    final items = _selected == 'All'
        ? all
        : all.where((n) => n.category == _selected).toList();

    // Group by date header (Today / Earlier).
    final now = DateTime.now();
    final today = <AppNotification>[];
    final earlier = <AppNotification>[];
    for (final n in items) {
      final isToday = n.at.year == now.year &&
          n.at.month == now.month &&
          n.at.day == now.day;
      (isToday ? today : earlier).add(n);
    }

    return Scaffold(
      appBar: AppAppBar(
        'Notifications',
        actions: [
          TextButton(
            onPressed: () => showAppSnack(context, 'All notifications marked read'),
            child: Text(
              'Mark all read',
              style: AppText.bodyMD.copyWith(
                color: AppColors.tealPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal filter chip bar.
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final f = _filters[i];
                return AppFilterChip(
                  label: f,
                  selected: _selected == f,
                  onTap: () => setState(() => _selected = f),
                );
              },
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const AppEmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications',
                    message: 'You\'re all caught up.',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xxl,
                    ),
                    children: [
                      if (today.isNotEmpty) ...[
                        _DateHeader('Today'),
                        ...today.map(_buildItem),
                      ],
                      if (earlier.isNotEmpty) ...[
                        _DateHeader('Earlier'),
                        ...earlier.map(_buildItem),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(AppNotification n) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: _NotificationItem(
          n: n,
          onTap: () {
            if (n.category == 'Billing') {
              context.push('/billing');
            } else {
              showAppSnack(context, n.title);
            }
          },
        ),
      );
}

class _DateHeader extends StatelessWidget {
  const _DateHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, AppSpacing.sm, 0, AppSpacing.sm),
        child: Text(
          label,
          style: AppText.bodySM.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textTertiary,
          ),
        ),
      );
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({required this.n, required this.onTap});
  final AppNotification n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !n.read;
    final (icon, iconBg) = _iconFor(n.iconType);

    return AppCard(
      onTap: onTap,
      color: unread ? AppColors.bgTertiary : null,
      leftBorderColor: unread ? AppColors.tealPrimary : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 18, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  n.title,
                  style: AppText.headingSM.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  n.body,
                  style: AppText.bodyMD,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(Fmt.ago(n.at), style: AppText.bodySM),
        ],
      ),
    );
  }

  (IconData, Color) _iconFor(String type) {
    switch (type) {
      case 'loan':
        return (Icons.account_balance_wallet_outlined, AppColors.tealLight);
      case 'doc':
        return (Icons.description_outlined, AppColors.infoLight);
      case 'billing':
        return (Icons.payments_outlined, AppColors.warningLight);
      case 'client':
        return (Icons.person_outline, AppColors.purbg);
      case 'system':
      default:
        return (Icons.info_outline, AppColors.bgTertiary);
    }
  }
}
