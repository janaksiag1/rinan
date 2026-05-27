import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// FRS 40 — Send Loan Offer · Step 1 of 3: Select Client.
class OfferStep1Screen extends ConsumerStatefulWidget {
  const OfferStep1Screen({super.key});

  @override
  ConsumerState<OfferStep1Screen> createState() => _OfferStep1ScreenState();
}

class _OfferStep1ScreenState extends ConsumerState<OfferStep1Screen> {
  String? _selectedId;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientsProvider);
    final filtered = _query.trim().isEmpty
        ? clients
        : clients
            .where((c) =>
                c.name.toLowerCase().contains(_query.toLowerCase()) ||
                c.mobile.contains(_query))
            .toList();

    return Scaffold(
      appBar: AppAppBar(
        'Send Loan Offer',
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const AppProgressBar(value: 0.33),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Step 1 of 3 — Select Client', style: AppText.bodySM),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: AppSearchField(
              hint: 'Search by name or mobile',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) => _ClientRow(
                client: filtered[i],
                selected: filtered[i].id == _selectedId,
                onTap: () => setState(() => _selectedId = filtered[i].id),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomBar(
        child: TealButton(
          'Next: Choose Bank →',
          onPressed: _selectedId != null
              ? () => context.push('/offer/step2')
              : null,
        ),
      ),
    );
  }
}

class _ClientRow extends StatelessWidget {
  const _ClientRow({
    required this.client,
    required this.selected,
    required this.onTap,
  });

  final Client client;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: selected ? AppColors.tealLight : null,
      borderColor: selected ? AppColors.tealPrimary : null,
      borderWidth: selected ? 1.5 : 0.5,
      child: Row(
        children: [
          InitialsAvatar(client.initials, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(client.name, style: AppText.headingSM),
                const SizedBox(height: 2),
                Text(
                  client.maskedMobile,
                  style: AppText.bodySM.copyWith(color: AppColors.tealPrimary),
                ),
                if (client.latestStatus != null) ...[
                  const SizedBox(height: 6),
                  StatusBadge(client.latestStatus!),
                ],
              ],
            ),
          ),
          if (selected) ...[
            const SizedBox(width: AppSpacing.sm),
            const Icon(Icons.check_circle, color: AppColors.tealPrimary),
          ],
        ],
      ),
    );
  }
}
