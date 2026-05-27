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

/// Module 8 — Special Occasions (FRS 52, 53, 55).
class OccasionsScreen extends ConsumerStatefulWidget {
  const OccasionsScreen({super.key});

  @override
  ConsumerState<OccasionsScreen> createState() => _OccasionsScreenState();
}

class _OccasionsScreenState extends ConsumerState<OccasionsScreen> {
  bool _birthday = true;
  bool _anniversary = true;

  @override
  Widget build(BuildContext context) {
    final occasions = ref.watch(occasionsProvider);

    final today = occasions.where((o) => o.daysUntil == 0).toList();
    final thisWeek =
        occasions.where((o) => o.daysUntil >= 1 && o.daysUntil <= 7).toList();
    final thisMonth = occasions.where((o) => o.daysUntil > 7).toList();

    return Scaffold(
      appBar: const AppAppBar('Special Occasions'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _autoSendCard(),
            const SizedBox(height: AppSpacing.md),
            _festivalLinkTile(),
            const SectionHeader(
              'Upcoming Occasions',
              padding: EdgeInsets.fromLTRB(0, AppSpacing.lg, 0, AppSpacing.sm),
            ),
            if (occasions.isEmpty)
              const AppEmptyState(
                icon: Icons.celebration_outlined,
                title: 'No upcoming occasions',
                message:
                    'Client birthdays and anniversaries will show up here.',
              )
            else ...[
              _group('Today', today),
              _group('This Week', thisWeek),
              _group('This Month', thisMonth),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // — Auto-send settings card —
  Widget _autoSendCard() {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: const BoxDecoration(
              color: AppColors.tealLight,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.celebration, color: AppColors.tealPrimary),
                const SizedBox(width: AppSpacing.sm),
                Text('Auto-Send Settings', style: AppText.headingMD),
              ],
            ),
          ),
          SwitchListTile(
            value: _birthday,
            activeColor: AppColors.tealPrimary,
            onChanged: (v) => setState(() => _birthday = v),
            secondary:
                const Icon(Icons.cake, color: AppColors.amberPrimary),
            title: Text('Birthday Greetings', style: AppText.headingSM),
            subtitle: Text(
              'Auto-send on client birthdays',
              style: AppText.bodySM,
            ),
          ),
          if (!_birthday)
            const Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, 0),
              child: _AutoOffWarning(),
            ),
          const Divider(height: 1, color: AppColors.borderLight),
          SwitchListTile(
            value: _anniversary,
            activeColor: AppColors.tealPrimary,
            onChanged: (v) => setState(() => _anniversary = v),
            secondary:
                const Icon(Icons.favorite, color: AppColors.errorPrimary),
            title: Text('Anniversary Greetings', style: AppText.headingSM),
            subtitle: Text(
              'Auto-send on client anniversaries',
              style: AppText.bodySM,
            ),
          ),
          if (!_anniversary)
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: _AutoOffWarning(),
            ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _festivalLinkTile() {
    return AppCard(
      onTap: () => context.push('/occasions/festivals'),
      child: Row(
        children: [
          const Icon(Icons.event, color: AppColors.tealPrimary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Festival Calendar',
              style: AppText.headingSM.copyWith(color: AppColors.textPrimary),
            ),
          ),
          const TextActionButton('Manage', icon: Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _group(String label, List<Occasion> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.sm,
            0,
            AppSpacing.sm,
          ),
          child: Text(
            label.toUpperCase(),
            style: AppText.bodySM.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items.map(_occasionCard),
      ],
    );
  }

  // — Occasion card —
  Widget _occasionCard(Occasion o) {
    final badge = _daysBadge(o.daysUntil);

    Widget card = AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      onTap: () => _openPreview(o),
      child: Row(
        children: [
          InitialsAvatar(_initials(o.clientName), size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(o.clientName, style: AppText.headingSM),
                const SizedBox(height: 4),
                Row(
                  children: [
                    AppChip(o.type, dense: true),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        Fmt.date(o.date),
                        style: AppText.bodySM,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppChip(
                  Fmt.daysUntilLabel(o.daysUntil),
                  bg: badge.$1,
                  fg: badge.$2,
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (o.autoSend)
            Text(
              'Auto ✓',
              style: AppText.bodySM.copyWith(
                color: AppColors.successPrimary,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            TealButton(
              'Send Now',
              small: true,
              fullWidth: false,
              onPressed: () => showAppSnack(context, 'Greeting sent ✓'),
            ),
        ],
      ),
    );

    if (!o.autoSend) {
      card = Opacity(opacity: 0.6, child: card);
    }
    return card;
  }

  /// Returns (bg, fg) for the days-until badge.
  (Color, Color) _daysBadge(int days) {
    if (days == 0) return (AppColors.errorLight, AppColors.errorPrimary);
    if (days == 1) return (AppColors.amberLight, AppColors.amberPrimary);
    return (AppColors.tealLight, AppColors.tealPrimary);
  }

  // — Preview sheet —
  void _openPreview(Occasion o) {
    final message = _greetingMessage(o);
    showAppSheet(
      context,
      title: "${o.clientName}'s ${o.type}",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            color: AppColors.warningLight,
            borderColor: AppColors.amberPrimary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: AppColors.successPrimary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'WhatsApp preview',
                      style: AppText.bodySM.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message,
                  style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.edit, size: 16, color: AppColors.tealPrimary),
              const SizedBox(width: 4),
              TextActionButton(
                'Customise message',
                onPressed: () =>
                    showAppSnack(context, 'Open message editor'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TealButton(
            'Send Greeting Now',
            onPressed: () {
              Navigator.pop(context);
              showAppSnack(context, 'Greeting sent ✓');
            },
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: TextActionButton(
              'Cancel',
              color: AppColors.textTertiary,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  String _greetingMessage(Occasion o) {
    if (o.type.toLowerCase().contains('anniversary')) {
      return 'Dear ${o.clientName}, wishing you and your family a very happy '
          'anniversary! 🎉 May this special day bring you joy and prosperity. '
          '— Team Riण';
    }
    return 'Dear ${o.clientName}, wishing you a very happy birthday! 🎂 '
        'May the year ahead bring you happiness, health and success. '
        '— Team Riण';
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

/// Amber warning chip shown when an auto-send toggle is OFF.
class _AutoOffWarning extends StatelessWidget {
  const _AutoOffWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 16,
            color: AppColors.amberPrimary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Clients will not receive auto greetings',
              style: AppText.bodySM.copyWith(color: AppColors.amberPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
