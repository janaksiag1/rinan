import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/app_providers.dart';
import '../../widgets/send_offer_fab.dart';
import '../constants/app_enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Bottom-nav shell wrapping the primary tab destinations. Tabs change with
/// the active profile (FRS Rule 8 — one app, two profiles).
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  static const _agentTabs = [
    _Tab('/home', Icons.home_outlined, Icons.home, 'Home'),
    _Tab('/clients', Icons.people_outline, Icons.people, 'Clients'),
    _Tab('/loans', Icons.account_balance_wallet_outlined,
        Icons.account_balance_wallet, 'Loans'),
    _Tab('/banks', Icons.account_balance_outlined, Icons.account_balance,
        'Banks'),
    _Tab('/settings', Icons.settings_outlined, Icons.settings, 'Settings'),
  ];

  static const _reviewerTabs = [
    _Tab('/home', Icons.home_outlined, Icons.home, 'Home'),
    _Tab('/applications', Icons.inbox_outlined, Icons.inbox, 'Apps'),
    _Tab('/rates', Icons.trending_up, Icons.trending_up, 'Rates'),
    _Tab('/agents', Icons.groups_outlined, Icons.groups, 'Agents'),
    _Tab('/settings', Icons.settings_outlined, Icons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final tabs = profile == ProfileType.agent ? _agentTabs : _reviewerTabs;
    final location = GoRouterState.of(context).uri.path;

    int index = tabs.indexWhere((t) =>
        location == t.route || location.startsWith('${t.route}/'));
    if (index < 0) index = 0;

    final showFab = profile == ProfileType.agent &&
        (location == '/home' ||
            location == '/clients' ||
            location == '/loans');

    return Scaffold(
      body: child,
      floatingActionButton: showFab ? const SendOfferFab() : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        backgroundColor: AppColors.bgSecondary,
        indicatorColor: AppColors.navyLight,
        surfaceTintColor: Colors.transparent,
        onDestinationSelected: (i) => context.go(tabs[i].route),
        destinations: [
          for (final t in tabs)
            NavigationDestination(
              icon: Icon(t.icon, color: AppColors.textTertiary),
              selectedIcon: Icon(t.activeIcon, color: AppColors.navyPrimary),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _Tab {
  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _Tab(this.route, this.icon, this.activeIcon, this.label);
}

/// Tiny helper for the NavigationBar label style (kept consistent).
TextStyle navLabelStyle() => AppText.bodySM;
