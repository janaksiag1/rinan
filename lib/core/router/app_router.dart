import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main_shell.dart';

// — Module 1: Authentication —
import '../../features/auth/splash_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/account_locked_screen.dart';
import '../../features/auth/force_update_screen.dart';
// — Module 2: Profile Setup & KYC —
import '../../features/profile_kyc/profile_type_screen.dart';
import '../../features/profile_kyc/setup_step1_screen.dart';
import '../../features/profile_kyc/setup_step2_screen.dart';
import '../../features/profile_kyc/setup_step3_screen.dart';
import '../../features/profile_kyc/kyc_overview_screen.dart';
import '../../features/profile_kyc/quickstart_screen.dart';
// — Module 3 / 11: Dashboards —
import '../../features/dashboard/home_screen.dart';
// — Module 4: Clients —
import '../../features/clients/clients_list_screen.dart';
import '../../features/clients/client_detail_screen.dart';
import '../../features/clients/add_client_screen.dart';
import '../../features/clients/edit_client_screen.dart';
import '../../features/clients/bulk_import_upload_screen.dart';
import '../../features/clients/bulk_import_review_screen.dart';
// — Module 5: Loans —
import '../../features/loans/loan_pipeline_screen.dart';
import '../../features/loans/loan_detail_screen.dart';
import '../../features/loans/request_correction_screen.dart';
// — Module 6: Send Offer —
import '../../features/offer/offer_step1_screen.dart';
import '../../features/offer/offer_step2_screen.dart';
import '../../features/offer/offer_step3_screen.dart';
import '../../features/offer/offer_sent_screen.dart';
// — Module 7: Banks —
import '../../features/banks/banks_list_screen.dart';
import '../../features/banks/add_bank_screen.dart';
import '../../features/banks/edit_bank_screen.dart';
import '../../features/banks/portal_connect_screen.dart';
import '../../features/banks/bank_rates_screen.dart';
// — Module 8: Occasions —
import '../../features/occasions/occasions_screen.dart';
import '../../features/occasions/festival_calendar_screen.dart';
// — Module 9: Analytics —
import '../../features/analytics/analytics_dashboard_screen.dart';
import '../../features/analytics/commission_statement_screen.dart';
import '../../features/analytics/bank_performance_screen.dart';
// — Module 10: Billing —
import '../../features/billing/billing_overview_screen.dart';
import '../../features/billing/topup_screen.dart';
import '../../features/billing/topup_success_screen.dart';
import '../../features/billing/billing_history_screen.dart';
// — Module 12: Applications —
import '../../features/applications/applications_list_screen.dart';
import '../../features/applications/application_detail_screen.dart';
// — Module 13: Documents —
import '../../features/documents/document_viewer_screen.dart';
// — Module 14: Rates —
import '../../features/rates/rates_dashboard_screen.dart';
import '../../features/rates/publish_rate_screen.dart';
import '../../features/rates/rate_edit_screen.dart';
import '../../features/rates/rate_sync_screen.dart';
import '../../features/rates/rate_history_screen.dart';
// — Module 15: Agents —
import '../../features/agents/agents_list_screen.dart';
import '../../features/agents/agent_detail_screen.dart';
import '../../features/agents/bulk_announcement_screen.dart';
// — Module 16: Notifications —
import '../../features/notifications/notifications_list_screen.dart';
import '../../features/notifications/notification_preferences_screen.dart';
// — Module 17: Settings —
import '../../features/settings/settings_screen.dart';
import '../../features/settings/edit_profile_screen.dart';
import '../../features/settings/pipeline_visibility_screen.dart';
import '../../features/settings/active_sessions_screen.dart';
import '../../features/settings/help_centre_screen.dart';
import '../../features/settings/chat_support_screen.dart';
import '../../features/settings/change_mobile_screen.dart';
import '../../features/settings/delete_account_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

MaterialPage<void> _page(Widget child, GoRouterState state) =>
    MaterialPage(key: state.pageKey, child: child);

/// The single GoRouter for the whole app (FRS — GoRouter routing).
/// No global auth guard: every screen is reachable so the full UI can be
/// explored. The splash auto-advances through the intended flow.
final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    // ── Auth & setup (full-screen, no shell) ──
    GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: '/auth/login', builder: (c, s) => const LoginScreen()),
    GoRoute(path: '/auth/locked', builder: (c, s) => const AccountLockedScreen()),
    GoRoute(path: '/force-update', builder: (c, s) => const ForceUpdateScreen()),
    GoRoute(
        path: '/auth/select-profile',
        builder: (c, s) => const ProfileTypeScreen()),
    GoRoute(path: '/auth/setup/1', builder: (c, s) => const SetupStep1Screen()),
    GoRoute(path: '/auth/setup/2', builder: (c, s) => const SetupStep2Screen()),
    GoRoute(path: '/auth/setup/3', builder: (c, s) => const SetupStep3Screen()),
    GoRoute(path: '/auth/kyc', builder: (c, s) => const KycOverviewScreen()),
    GoRoute(
        path: '/auth/quickstart', builder: (c, s) => const QuickstartScreen()),

    // ── Document viewer (full-screen, dark) ──
    GoRoute(
      path: '/documents/:id',
      builder: (c, s) => DocumentViewerScreen(id: s.pathParameters['id']!),
    ),

    // ── Main shell with bottom nav ──
    ShellRoute(
      navigatorKey: _shellKey,
      builder: (c, s, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', pageBuilder: (c, s) => _page(const HomeScreen(), s)),
        GoRoute(path: '/clients', pageBuilder: (c, s) => _page(const ClientsListScreen(), s)),
        GoRoute(path: '/loans', pageBuilder: (c, s) => _page(const LoanPipelineScreen(), s)),
        GoRoute(path: '/banks', pageBuilder: (c, s) => _page(const BanksListScreen(), s)),
        GoRoute(path: '/applications', pageBuilder: (c, s) => _page(const ApplicationsListScreen(), s)),
        GoRoute(path: '/rates', pageBuilder: (c, s) => _page(const RatesDashboardScreen(), s)),
        GoRoute(path: '/agents', pageBuilder: (c, s) => _page(const AgentsListScreen(), s)),
        GoRoute(path: '/settings', pageBuilder: (c, s) => _page(const SettingsScreen(), s)),
      ],
    ),

    // ── Clients (pushed) ──
    GoRoute(path: '/clients/new', parentNavigatorKey: _rootKey, builder: (c, s) => const AddClientScreen()),
    GoRoute(path: '/clients/import', parentNavigatorKey: _rootKey, builder: (c, s) => const BulkImportUploadScreen()),
    GoRoute(path: '/clients/import/review', parentNavigatorKey: _rootKey, builder: (c, s) => const BulkImportReviewScreen()),
    GoRoute(path: '/clients/:id', parentNavigatorKey: _rootKey, builder: (c, s) => ClientDetailScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/clients/:id/edit', parentNavigatorKey: _rootKey, builder: (c, s) => EditClientScreen(id: s.pathParameters['id']!)),

    // ── Loans (pushed) ──
    GoRoute(path: '/loans/:id', parentNavigatorKey: _rootKey, builder: (c, s) => LoanDetailScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/loans/:id/correction', parentNavigatorKey: _rootKey, builder: (c, s) => RequestCorrectionScreen(id: s.pathParameters['id']!)),

    // ── Send Offer flow (pushed) ──
    GoRoute(path: '/offer', parentNavigatorKey: _rootKey, builder: (c, s) => const OfferStep1Screen()),
    GoRoute(path: '/offer/step2', parentNavigatorKey: _rootKey, builder: (c, s) => const OfferStep2Screen()),
    GoRoute(path: '/offer/step3', parentNavigatorKey: _rootKey, builder: (c, s) => const OfferStep3Screen()),
    GoRoute(path: '/offer/sent', parentNavigatorKey: _rootKey, builder: (c, s) => const OfferSentScreen()),

    // ── Banks (pushed) ──
    GoRoute(path: '/banks/new', parentNavigatorKey: _rootKey, builder: (c, s) => const AddBankScreen()),
    GoRoute(path: '/banks/:id/edit', parentNavigatorKey: _rootKey, builder: (c, s) => EditBankScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/banks/:id/connect', parentNavigatorKey: _rootKey, builder: (c, s) => PortalConnectScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/banks/:id/rates', parentNavigatorKey: _rootKey, builder: (c, s) => BankRatesScreen(id: s.pathParameters['id']!)),

    // ── Occasions (pushed) ──
    GoRoute(path: '/occasions', parentNavigatorKey: _rootKey, builder: (c, s) => const OccasionsScreen()),
    GoRoute(path: '/occasions/festivals', parentNavigatorKey: _rootKey, builder: (c, s) => const FestivalCalendarScreen()),

    // ── Analytics (pushed) ──
    GoRoute(path: '/analytics', parentNavigatorKey: _rootKey, builder: (c, s) => const AnalyticsDashboardScreen()),
    GoRoute(path: '/analytics/commission', parentNavigatorKey: _rootKey, builder: (c, s) => const CommissionStatementScreen()),
    GoRoute(path: '/analytics/banks/:id', parentNavigatorKey: _rootKey, builder: (c, s) => BankPerformanceScreen(id: s.pathParameters['id']!)),

    // ── Billing (pushed) ──
    GoRoute(path: '/billing', parentNavigatorKey: _rootKey, builder: (c, s) => const BillingOverviewScreen()),
    GoRoute(path: '/billing/topup', parentNavigatorKey: _rootKey, builder: (c, s) => const TopUpScreen()),
    GoRoute(path: '/billing/topup/success', parentNavigatorKey: _rootKey, builder: (c, s) => const TopUpSuccessScreen()),
    GoRoute(path: '/billing/history', parentNavigatorKey: _rootKey, builder: (c, s) => const BillingHistoryScreen()),

    // ── Applications (pushed) ──
    GoRoute(path: '/applications/:id', parentNavigatorKey: _rootKey, builder: (c, s) => ApplicationDetailScreen(id: s.pathParameters['id']!)),

    // ── Rates (pushed) ──
    GoRoute(path: '/rates/new', parentNavigatorKey: _rootKey, builder: (c, s) => const PublishRateScreen()),
    GoRoute(path: '/rates/history', parentNavigatorKey: _rootKey, builder: (c, s) => const RateHistoryScreen()),
    GoRoute(path: '/rates/:id/edit', parentNavigatorKey: _rootKey, builder: (c, s) => RateEditScreen(id: s.pathParameters['id']!)),
    GoRoute(path: '/rates/:id/sync', parentNavigatorKey: _rootKey, builder: (c, s) => RateSyncScreen(id: s.pathParameters['id']!)),

    // ── Agents (pushed) ──
    GoRoute(path: '/agents/announce', parentNavigatorKey: _rootKey, builder: (c, s) => const BulkAnnouncementScreen()),
    GoRoute(path: '/agents/:id', parentNavigatorKey: _rootKey, builder: (c, s) => AgentDetailScreen(id: s.pathParameters['id']!)),

    // ── Notifications & Settings sub-pages (pushed) ──
    GoRoute(path: '/notifications', parentNavigatorKey: _rootKey, builder: (c, s) => const NotificationsListScreen()),
    GoRoute(path: '/settings/notifications', parentNavigatorKey: _rootKey, builder: (c, s) => const NotificationPreferencesScreen()),
    GoRoute(path: '/settings/profile', parentNavigatorKey: _rootKey, builder: (c, s) => const EditProfileScreen()),
    GoRoute(path: '/settings/pipeline', parentNavigatorKey: _rootKey, builder: (c, s) => const PipelineVisibilityScreen()),
    GoRoute(path: '/settings/security', parentNavigatorKey: _rootKey, builder: (c, s) => const ActiveSessionsScreen()),
    GoRoute(path: '/settings/help', parentNavigatorKey: _rootKey, builder: (c, s) => const HelpCentreScreen()),
    GoRoute(path: '/settings/support', parentNavigatorKey: _rootKey, builder: (c, s) => const ChatSupportScreen()),
    GoRoute(path: '/settings/mobile', parentNavigatorKey: _rootKey, builder: (c, s) => const ChangeMobileScreen()),
    GoRoute(path: '/settings/delete-account', parentNavigatorKey: _rootKey, builder: (c, s) => const DeleteAccountScreen()),
  ],
);
