import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 8 — Festival Calendar (FRS 54).
class FestivalCalendarScreen extends ConsumerStatefulWidget {
  const FestivalCalendarScreen({super.key});

  @override
  ConsumerState<FestivalCalendarScreen> createState() =>
      _FestivalCalendarScreenState();
}

class _FestivalCalendarScreenState
    extends ConsumerState<FestivalCalendarScreen> {
  static const _categories = [
    'All',
    'Hindu',
    'Muslim',
    'Christian',
    'National',
    'Sikh',
    'Buddhist',
  ];

  String _selected = 'All';

  /// Local override of each festival's enabled state, keyed by festival name.
  final Map<String, bool> _enabledOverride = {};

  static Color _categoryColor(String category) {
    switch (category) {
      case 'Hindu':
        return AppColors.amberPrimary;
      case 'Muslim':
        return AppColors.successPrimary;
      case 'Christian':
        return AppColors.infoPrimary;
      case 'National':
        return AppColors.navyPrimary;
      case 'Sikh':
        return AppColors.tealPrimary;
      case 'Buddhist':
        return AppColors.purplePrimary;
      default:
        return AppColors.textTertiary;
    }
  }

  bool _isEnabled(Festival f) => _enabledOverride[f.name] ?? f.enabled;

  @override
  Widget build(BuildContext context) {
    final festivals = ref.watch(festivalsProvider);

    final filtered = (_selected == 'All'
            ? festivals
            : festivals.where((f) => f.category == _selected).toList())
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Group by month name (preserving chronological order).
    final groups = <String, List<Festival>>{};
    for (final f in filtered) {
      final month = DateFormat('MMMM yyyy').format(f.date);
      groups.putIfAbsent(month, () => []).add(f);
    }

    final enabledCount = festivals.where(_isEnabled).length;

    return Scaffold(
      appBar: AppAppBar(
        'Festival Calendar',
        actions: [
          TextButton(
            onPressed: () => showAppSnack(context, 'All festivals enabled'),
            child: Text(
              'Enable All',
              style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => showAppSnack(context, 'All festivals disabled'),
            child: Text(
              'Disable All',
              style: AppText.bodyMD.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // — Filter chip bar —
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) {
                final c = _categories[i];
                return AppFilterChip(
                  label: c,
                  selected: _selected == c,
                  selectedColor: c == 'All'
                      ? AppColors.tealPrimary
                      : _categoryColor(c),
                  onTap: () => setState(() => _selected = c),
                );
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.borderLight),
          // — Grouped festival list —
          Expanded(
            child: filtered.isEmpty
                ? const AppEmptyState(
                    icon: Icons.event_busy,
                    title: 'No festivals',
                    message: 'No festivals match this category.',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    children: [
                      for (final entry in groups.entries) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.xs,
                            AppSpacing.sm,
                            0,
                            AppSpacing.sm,
                          ),
                          child: Text(
                            entry.key.toUpperCase(),
                            style: AppText.bodySM.copyWith(
                              color: AppColors.textTertiary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        ...entry.value.map(_festivalRow),
                      ],
                    ],
                  ),
          ),
          // — Sticky estimate bar —
          StickyBottomBar(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '~$enabledCount festival sends/year · ~$enabledCount credits/year estimated',
                style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _festivalRow(Festival f) {
    final color = _categoryColor(f.category);
    final enabled = _isEnabled(f);

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      leftBorderColor: enabled ? AppColors.tealPrimary : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f.name,
                    style: AppText.headingSM,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(Fmt.date(f.date), style: AppText.bodySM),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Switch(
              value: enabled,
              activeColor: AppColors.tealPrimary,
              onChanged: (v) => setState(() => _enabledOverride[f.name] = v),
            ),
          ],
        ),
      ),
    );
  }
}
