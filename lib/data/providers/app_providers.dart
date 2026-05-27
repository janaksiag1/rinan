import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_enums.dart';
import '../mock/mock_data.dart';
import '../models/models.dart';

/// Active profile (Agent/Reviewer). Drives router redirects & theming.
/// FRS Rule 8 — one app, two profiles.
final profileProvider = StateProvider<ProfileType>((ref) => ProfileType.agent);

/// Whether the user has "logged in" (mock auth gate for the router).
final isAuthedProvider = StateProvider<bool>((ref) => false);

/// Whether onboarding/setup is complete (mock).
final setupCompleteProvider = StateProvider<bool>((ref) => true);

/// Mutable credit balance (mock). TealButton top-ups mutate this.
final creditsProvider = StateProvider<int>((ref) => Mock.creditBalance);

/// Unread notification count badge.
final unreadCountProvider = Provider<int>(
  (ref) => Mock.notifications.where((n) => !n.read).length,
);

// — Read-only mock data providers (each screen reads these) —
final clientsProvider = Provider<List<Client>>((ref) => Mock.clients);
final banksProvider = Provider<List<Bank>>((ref) => Mock.banks);
final loansProvider = Provider<List<Loan>>((ref) => Mock.loans);
final occasionsProvider = Provider<List<Occasion>>((ref) => Mock.occasions);
final festivalsProvider = Provider<List<Festival>>((ref) => Mock.festivals);
final notificationsProvider =
    Provider<List<AppNotification>>((ref) => Mock.notifications);
final pendingActionsProvider =
    Provider<List<PendingAction>>((ref) => Mock.pendingActions);
final activityProvider = Provider<List<ActivityItem>>((ref) => Mock.activity);
final agentsProvider = Provider<List<Agent>>((ref) => Mock.agents);
final ratesProvider = Provider<List<Rate>>((ref) => Mock.rates);
final billingHistoryProvider =
    Provider<List<BillingRow>>((ref) => Mock.billingHistory);
final commissionsProvider =
    Provider<List<CommissionRow>>((ref) => Mock.commissions);
final sessionsProvider = Provider<List<Session>>((ref) => Mock.sessions);
final faqsProvider = Provider<List<FaqItem>>((ref) => Mock.faqs);

final clientByIdProvider =
    Provider.family<Client, String>((ref, id) => Mock.clientById(id));
final loanByIdProvider =
    Provider.family<Loan, String>((ref, id) => Mock.loanById(id));
final bankByIdProvider =
    Provider.family<Bank, String>((ref, id) => Mock.bankById(id));
final agentByIdProvider =
    Provider.family<Agent, String>((ref, id) => Mock.agentById(id));
final rateByIdProvider =
    Provider.family<Rate, String>((ref, id) => Mock.rateById(id));

/// Loan pipeline counts per status (for tab badges).
final loanStatusCountsProvider = Provider<Map<LoanStatus, int>>((ref) {
  final loans = ref.watch(loansProvider);
  final map = <LoanStatus, int>{};
  for (final s in LoanStatus.values) {
    map[s] = loans.where((l) => l.status == s).length;
  }
  return map;
});
