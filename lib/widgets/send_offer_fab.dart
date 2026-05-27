import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';
import '../data/providers/app_providers.dart';
import 'buttons.dart';

/// Persistent Send Offer FAB (Home / Clients / Loans). Checks credits;
/// 0 credits shows the CreditDepletedModal instead of navigating (Rule 15).
class SendOfferFab extends ConsumerWidget {
  const SendOfferFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      heroTag: 'send_offer_fab',
      backgroundColor: AppColors.tealPrimary,
      foregroundColor: AppColors.textPrimary,
      onPressed: () {
        final credits = ref.read(creditsProvider);
        if (credits <= 0) {
          _showCreditDepleted(context);
        } else {
          context.push('/offer');
        }
      },
      icon: const Icon(Icons.send_rounded, size: 20, color: AppColors.textPrimary),
      label: Text('Send Offer', style: AppText.buttonMD),
    );
  }
}

void _showCreditDepleted(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt, size: 48, color: AppColors.amberPrimary),
          const SizedBox(height: 8),
          Text('Out of Credits', style: AppText.headingLG, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Top up credits to send offers.',
              style: AppText.bodyLG, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          TealButton('Top Up →', onPressed: () {
            Navigator.pop(ctx);
            context.push('/billing/topup');
          }),
          const SizedBox(height: 8),
          TextActionButton('Maybe Later', onPressed: () => Navigator.pop(ctx)),
        ],
      ),
    ),
  );
}
