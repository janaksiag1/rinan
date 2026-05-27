# Riण Screen-Builder Brief (READ FULLY before writing any screen)

You build Flutter **UI/UX screens only**. NO API, NO network, NO Supabase, NO Dio.
All data comes from the existing **mock Riverpod providers**. The foundation
(theme, widgets, models, mock data, router) is already built — **never modify
foundation files, the router, main.dart, or other modules' files.** Only create
the screen files assigned to you, at the exact paths and with the exact class
names + constructors given in your task.

## Step 0 — read these first
- `lib/core/theme/app_colors.dart` → `AppColors.*`
- `lib/core/theme/app_text.dart` → `AppText.*`
- `lib/core/theme/app_spacing.dart` → `AppSpacing.*`, `AppRadius.*`
- `lib/core/constants/app_enums.dart` → enums
- `lib/core/utils/formatters.dart` → `Fmt.*`
- `lib/data/models/models.dart` → models
- `lib/data/mock/mock_data.dart` → `Mock.*`
- `lib/data/providers/app_providers.dart` → providers
- `lib/widgets/widgets.dart` (barrel) and the widget files it exports

## Standard imports for a screen in `lib/features/<module>/`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/mock/mock_data.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';
// charts only when needed:
import 'package:fl_chart/fl_chart.dart';
```

## Design rules (NON-NEGOTIABLE — FRS Part 25)
1. **Text colors:** only `AppColors.textPrimary` / `textSecondary` / `textTertiary`.
   NEVER `Colors.white` for text. All button labels & text on colored
   backgrounds = `textPrimary` (dark). (Document viewer dark overlays are the
   only place white-on-dark banners use textPrimary too.)
2. **Money / IDs / OTP / credit balance:** DM Mono — use `MonoText(...)` or
   `AppText.mono` / `AppText.monoSM`. Format rupees with `Fmt.money(intValue)`.
3. **Cards:** use `AppCard(...)` (flat, 0.5px border, radius 12). Urgency stripe
   via `leftBorderColor:`.
4. **AppBar:** always `AppAppBar('Title', actions: [...])` (navy, dark text).
5. **StatusBadge:** `StatusBadge(LoanStatus.x)`.
6. **3 states:** list screens use real mock data (populated). Use
   `AppEmptyState(...)` exactly where the FRS names an empty state, and
   `ShimmerList()` / `AppErrorState()` are available if you add a toggle.
7. **State:** `ConsumerWidget` / `ConsumerStatefulWidget`. Read data with
   `ref.watch(provider)`. Local UI state (tabs, form fields, toggles, selection)
   may use `setState` — that's fine for this mock UI.
8. Scaffold bg is themed to `bgPrimary` automatically.

## Widget API (confirm by reading the files)
- `PrimaryButton(label, {onPressed, icon, isLoading, fullWidth=true, small=false})` navy
- `TealButton(label, {…same})` teal
- `DangerButton(label, {…same})` red
- `SecondaryButton(label, {onPressed, icon, fullWidth=true, small=false})` outlined
- `TextActionButton(label, {onPressed, icon, color})`
- `AppCard({required child, padding, onTap, color, leftBorderColor, borderColor, borderWidth, margin, radius})`
- `StatusBadge(LoanStatus, {onTap})`
- `InitialsAvatar(initials, {size=40, bg, fg})`, `BankInitialAvatar(initial, {size=40})`
- `MonoText(text, {style, color})`
- `SectionHeader(title, {trailing, padding})`
- `CountBadge(count, {color})`
- `AppChip(label, {bg, fg, icon, dense})`
- `AppFilterChip({required label, required selected, required onTap, count, selectedColor, icon})`
- `InfoBox({required text, bg, fg, icon})`
- `DetailRow(label, value, {valueStyle})`
- `StickyBottomBar({required child, padding})`
- `showAppSnack(context, msg)`
- `showConfirmSheet(context, {required title, required message, confirmLabel, destructive}) → Future<bool>`
- `AppEmptyState({required icon, required title, required message, action})`
- `AppErrorState({message, onRetry})`
- `ShimmerCard({height, lines})`, `ShimmerList({count})`
- `AppProgressBar({required value, color, height, background})`
- `CircularGauge({required value, required centerLabel, subLabel, size, color})`
- `AppAppBar(title, {actions, leading, showBack, trailingText, bottom, titleWidget})`
- `AppBottomSheet({required title, required child, onClose, fullHeight, padding})`,
  `showAppSheet(context, {required title, required child, fullHeight, isDismissible}) → Future<T?>`
- `NotificationBell()`, `SendOfferFab()`
- Inputs: `AppTextField({required label, hint, controller, helpText, required, maxLines, minLines, maxLength, keyboardType, readOnly, fill, suffix, portalSynced, onChanged, initialValue})`,
  `AppPhoneField({label, hint, controller, onChanged, readOnly})`,
  `AppDropdown<T>({required label, required items, required itemLabel, value, hint, required, onChanged})`,
  `AppOTPField({error, onCompleted})`,
  `AppSearchField({hint, controller, onChanged})`,
  `AppMoneyField({required label, controller, required, onChanged})`,
  `AppDatePicker({required label, required})`

## Providers (all in app_providers.dart)
`profileProvider` (StateProvider<ProfileType>), `creditsProvider`
(StateProvider<int>), `unreadCountProvider`, and read-only list providers:
`clientsProvider, banksProvider, loansProvider, occasionsProvider,
festivalsProvider, notificationsProvider, pendingActionsProvider,
activityProvider, agentsProvider, ratesProvider, billingHistoryProvider,
commissionsProvider, sessionsProvider, faqsProvider`. Family lookups:
`clientByIdProvider, loanByIdProvider, bankByIdProvider, agentByIdProvider,
rateByIdProvider` (call `ref.watch(loanByIdProvider(id))`). Counts:
`loanStatusCountsProvider`. Also raw `Mock.*` static lists in mock_data.dart
(`Mock.loanTypes, Mock.cities, Mock.bankTypes, Mock.plans, Mock.creditPacks,
Mock.reviewerPipeline, Mock.agentKpis, Mock.reviewerKpis, Mock.faqs`, etc.).

## Enums
`ProfileType {agent, reviewer}` (`.label`, `.color`).
`LoanStatus {draft, applied, submitted, underReview, approved, rejected,
sanctioned, disbursed}` (`.code`, `.label`, `.fg`, `.bg`).
`UrgencyBand.fromDays(int) → {fresh, warning, overdue}` (`.color`).
`DocStatus {pending, uploaded, accepted, rejected, reuploadNeeded}` (`.label`, `.color`).
`KycStatus`, `PortalStatus {connected, notConnected}`, `ViewState`.

## Navigation
`context.push('/route')` forward · `context.pop()` back · `context.go('/route')`
tab switch. Routes already wired in router — just push the paths the FRS lists.

## Money / model notes
- `Loan`: id, clientName, bankName, rmName, loanType, amount(int), tenureMonths,
  rate(double?), purpose, status(LoanStatus), submittedOn, daysOpen, foir(double?),
  documents(List<LoanDocument>), timeline(List<TimelineEvent>),
  messages(List<LoanMessage>), agentName. `loan.urgency` → UrgencyBand,
  `loan.docsUploaded`.
- `Client`: name, mobile, maskedMobile, initials, city, activeLoans,
  completedLoans, totalDisbursed, latestStatus, dob, anniversary, leadSource,
  notes, portalSynced, unread.
- `Bank`: name, shortName, initial, type, branch, city, rmName, rmMobile,
  rmEmail, portal(PortalStatus), loanTypes, rates(Map), activeLoans.
- See models.dart for the rest (Agent, Rate, Occasion, Festival, AppNotification,
  BillingRow, CreditPack, Plan, CommissionRow, Session, FaqItem, KpiCard,
  PendingAction, ActivityItem, LoanDocument, TimelineEvent, LoanMessage).

## Deliverable
Create only your assigned files. Keep each screen faithful to its FRS row
(layout, widgets, colors, interactions) but with mock data and no API calls.
Buttons that would call APIs should instead navigate, toggle local state, or
`showAppSnack(context, '…')`. Make sure imports resolve and class names +
constructors EXACTLY match the contract. Do not run `flutter` commands.
