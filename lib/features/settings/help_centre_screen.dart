import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 106 — Help Centre. Searchable, category-filtered FAQ list.
class HelpCentreScreen extends ConsumerStatefulWidget {
  const HelpCentreScreen({super.key});

  @override
  ConsumerState<HelpCentreScreen> createState() => _HelpCentreScreenState();
}

class _HelpCentreScreenState extends ConsumerState<HelpCentreScreen> {
  static const _categories = [
    'All',
    'Account',
    'Credits',
    'Offers',
    'Documents',
    'Billing',
  ];
  String _category = 'All';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final faqs = ref.watch(faqsProvider);
    final filtered = faqs.where((f) {
      final matchCat = _category == 'All' || f.category == _category;
      final q = _query.toLowerCase();
      final matchQuery = q.isEmpty ||
          f.question.toLowerCase().contains(q) ||
          f.answer.toLowerCase().contains(q);
      return matchCat && matchQuery;
    }).toList();

    return Scaffold(
      appBar: AppAppBar('Help Centre', actions: [
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () => context.push('/settings/support'),
        ),
      ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: AppSearchField(
              hint: 'Search help articles',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) => AppFilterChip(
                label: _categories[i],
                selected: _category == _categories[i],
                onTap: () => setState(() => _category = _categories[i]),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: filtered.isEmpty
                ? const AppEmptyState(
                    icon: Icons.search_off,
                    title: 'No articles found',
                    message: 'Try a different keyword or category.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => _FaqTile(filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile(this.faq);
  final FaqItem faq;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
          title: Text(faq.question,
              style: AppText.bodyLG.copyWith(color: AppColors.textPrimary)),
          iconColor: AppColors.tealPrimary,
          collapsedIconColor: AppColors.textTertiary,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(faq.answer,
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textSecondary)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextActionButton(
                'See more →',
                onPressed: () => showAppSnack(context, 'Opening full article'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
