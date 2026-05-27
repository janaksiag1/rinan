import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 12 — FRS 73–83: Application Detail (Reviewer side, full-screen).
/// Tabs: Details / Documents / Timeline / Messages.
class ApplicationDetailScreen extends ConsumerStatefulWidget {
  const ApplicationDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState
    extends ConsumerState<ApplicationDetailScreen> {
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loan = ref.watch(loanByIdProvider(widget.id));

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppAppBar(
          loan.id,
          titleWidget: MonoText(loan.id, style: AppText.monoSM),
          actions: [
            Center(child: StatusBadge(loan.status)),
            const SizedBox(width: AppSpacing.sm),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (v) {
                switch (v) {
                  case 'note':
                    _openAddNote();
                    break;
                  case 'export':
                    showAppSnack(context, 'Exporting…');
                    break;
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'note', child: Text('Add Internal Note')),
                PopupMenuItem(value: 'export', child: Text('Export')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            _subHeader(loan),
            const TabBar(
              labelColor: AppColors.tealPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.tealPrimary,
              isScrollable: false,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Documents'),
                Tab(text: 'Timeline'),
                Tab(text: 'Messages'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _DetailsTab(loan: loan, onUpdateStatus: () => _openStatusUpdate(loan)),
                  _DocumentsTab(loan: loan),
                  _TimelineTab(loan: loan, onAddNote: _openAddNote),
                  _MessagesTab(loan: loan, controller: _msgController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subHeader(Loan loan) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
      child: Column(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BankInitialAvatar(loan.bankName[0], size: 40),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loan.bankName,
                              style: AppText.headingSM
                                  .copyWith(color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          AppChip(loan.loanType, dense: true),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        MonoText(Fmt.money(loan.amount),
                            style: AppText.displayMedium.copyWith(fontSize: 20)),
                        const SizedBox(height: 2),
                        Text(Fmt.date(loan.submittedOn),
                            style: AppText.bodySM),
                      ],
                    ),
                  ],
                ),
                if (loan.foir != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  _foirRow(loan.foir!),
                ],
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColors.borderLight),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    InitialsAvatar(_initials(loan.agentName ?? 'Agent'),
                        size: 24),
                    const SizedBox(width: AppSpacing.sm),
                    Text(loan.agentName ?? 'Agent',
                        style: AppText.bodySM
                            .copyWith(color: AppColors.textSecondary)),
                    const Spacer(),
                    TextActionButton('View agent →',
                        onPressed: () =>
                            showAppSnack(context, 'Opening agent profile…')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _foirRow(double foir) {
    final color = foir < 40
        ? AppColors.successPrimary
        : foir < 60
            ? AppColors.warningPrimary
            : AppColors.errorPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('FOIR', style: AppText.bodySM),
            const Spacer(),
            MonoText('${foir.toStringAsFixed(0)}%',
                style: AppText.monoSM, color: color),
          ],
        ),
        const SizedBox(height: 6),
        AppProgressBar(value: foir / 100, color: color),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // ───────────────────────────────────────────── Add internal note
  void _openAddNote() {
    final controller = TextEditingController();
    showAppSheet(
      context,
      title: 'Add Internal Note',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InfoBox(
            text: 'Internal notes are visible to reviewers only.',
            bg: AppColors.purbg,
            fg: AppColors.purplePrimary,
            icon: Icons.lock_outline,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Note',
            hint: 'Type your note…',
            controller: controller,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.md),
          TealButton(
            'Save Note',
            onPressed: () {
              Navigator.pop(context);
              showAppSnack(context, 'Internal note added ✓');
            },
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────── Status update flow
  void _openStatusUpdate(Loan loan) {
    LoanStatus? target;
    final targets = const [
      LoanStatus.underReview,
      LoanStatus.approved,
      LoanStatus.rejected,
      LoanStatus.sanctioned,
      LoanStatus.disbursed,
    ];
    showAppSheet(
      context,
      title: 'Update Status',
      child: StatefulBuilder(
        builder: (ctx, setSheet) {
          // Header: current → target
          final header = Row(
            children: [
              StatusBadge(loan.status),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.arrow_forward,
                  size: 18, color: AppColors.textTertiary),
              const SizedBox(width: AppSpacing.sm),
              if (target != null)
                StatusBadge(target!)
              else
                Text('Choose…', style: AppText.bodyMD),
            ],
          );

          if (target == null) {
            // Step 1 — pick a target status
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: AppSpacing.md),
                Text('Move application to',
                    style: AppText.bodyMD.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                for (final s in targets)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 6,
                      backgroundColor: s.fg,
                    ),
                    title: Text(s.label,
                        style: AppText.bodyLG
                            .copyWith(color: AppColors.textPrimary)),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.textTertiary),
                    onTap: () => setSheet(() => target = s),
                  ),
                const SizedBox(height: AppSpacing.sm),
              ],
            );
          }

          // Step 2 — status-specific form
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: AppSpacing.md),
              ..._statusForm(target!),
              const SizedBox(height: AppSpacing.md),
              if (target == LoanStatus.rejected)
                DangerButton(
                  'Confirm Rejection',
                  onPressed: () {
                    Navigator.pop(ctx);
                    showAppSnack(context, 'Status updated ✓');
                  },
                )
              else
                TealButton(
                  'Confirm',
                  onPressed: () {
                    Navigator.pop(ctx);
                    showAppSnack(context, 'Status updated ✓');
                  },
                ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextActionButton('Choose different status',
                    onPressed: () => setSheet(() => target = null)),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _statusForm(LoanStatus s) {
    switch (s) {
      case LoanStatus.approved:
        return [
          const AppMoneyField(label: 'Approved Amount', required: true),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Interest Rate (% p.a.)', hint: 'e.g. 10.5'),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Tenure (months)', hint: 'e.g. 60'),
        ];
      case LoanStatus.rejected:
        return [
          AppDropdown<String>(
            label: 'Rejection reason',
            required: true,
            hint: 'Select a reason',
            items: const [
              'Low CIBIL score',
              'Insufficient income',
              'High FOIR',
              'Incomplete documents',
              'Policy decline',
            ],
            itemLabel: (e) => e,
            onChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(
              label: 'Remarks', hint: 'Optional explanation…', maxLines: 3),
        ];
      case LoanStatus.sanctioned:
        return [
          const AppTextField(
              label: 'Sanction Reference No.', hint: 'e.g. SAN-2026-0042'),
          const SizedBox(height: AppSpacing.md),
          const AppDatePicker(label: 'Sanction Date', required: true),
        ];
      case LoanStatus.disbursed:
        return [
          const AppMoneyField(label: 'Disbursed Amount', required: true),
          const SizedBox(height: AppSpacing.md),
          const AppDatePicker(label: 'Disbursal Date', required: true),
        ];
      case LoanStatus.underReview:
      default:
        return [
          const AppTextField(
              label: 'Note', hint: 'Optional note for the agent…', maxLines: 3),
        ];
    }
  }
}

// ─────────────────────────────────────────────────────────── DETAILS

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.loan, required this.onUpdateStatus});
  final Loan loan;
  final VoidCallback onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _section('Personal Info', [
          DetailRow('Name', loan.clientName),
          const DetailRow('Mobile', '+91 ·····3210'),
          const DetailRow('City', 'Mumbai'),
          const DetailRow('Date of Birth', '14 Aug 1989'),
          const DetailRow('PAN', '••••3210'),
          const DetailRow('Address', '402, Sunrise Apartments, Andheri West'),
          const DetailRow('Residence type', 'Owned'),
        ]),
        const SizedBox(height: AppSpacing.md),
        _section('Employment Info', [
          const DetailRow('Type', 'Salaried'),
          const DetailRow('Company', 'TCS'),
          DetailRow('Monthly Salary', Fmt.money(120000),
              valueStyle: AppText.mono),
          const DetailRow('Years employed', '4'),
        ]),
        const SizedBox(height: AppSpacing.md),
        _section('Loan Request', [
          DetailRow('Amount', Fmt.money(loan.amount), valueStyle: AppText.mono),
          DetailRow('Tenure', '${loan.tenureMonths} months'),
          DetailRow('Purpose', loan.purpose),
          const DetailRow('Existing EMIs', '₹18,000 / month'),
        ]),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: TextActionButton(
            'View Full Customer Form →',
            onPressed: () => _openFormPreview(context),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _StatusActionPanel(loan: loan, onUpdateStatus: onUpdateStatus),
      ],
    );
  }

  Widget _section(String title, List<Widget> rows) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.headingSM),
          const SizedBox(height: AppSpacing.xs),
          ...rows,
        ],
      ),
    );
  }

  void _openFormPreview(BuildContext context) {
    showAppSheet(
      context,
      title: 'Customer Form',
      fullHeight: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _previewBlock('Personal', const [
            DetailRow('Name', 'Rahul Sharma'),
            DetailRow('Mobile', '+91 98765 43210'),
            DetailRow('Email', 'rahul.sharma@email.com'),
            DetailRow('City', 'Mumbai'),
            DetailRow('Date of Birth', '14 Aug 1989'),
          ]),
          const SizedBox(height: AppSpacing.md),
          _previewBlock('Employment', const [
            DetailRow('Type', 'Salaried'),
            DetailRow('Company', 'TCS'),
            DetailRow('Designation', 'Senior Engineer'),
            DetailRow('Monthly Salary', '₹1,20,000'),
          ]),
          const SizedBox(height: AppSpacing.md),
          _previewBlock('References', const [
            DetailRow('Reference 1', 'Anita Desai · +91 ·····8821'),
            DetailRow('Reference 2', 'Karan Mehta · +91 ·····5567'),
          ]),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _previewBlock(String title, List<Widget> rows) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.headingSM),
          const SizedBox(height: AppSpacing.xs),
          ...rows,
        ],
      ),
    );
  }
}

class _StatusActionPanel extends StatelessWidget {
  const _StatusActionPanel({required this.loan, required this.onUpdateStatus});
  final Loan loan;
  final VoidCallback onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Current status',
                  style: AppText.bodySM.copyWith(color: AppColors.textTertiary)),
              const Spacer(),
              StatusBadge(loan.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TealButton('Update Status →', onPressed: onUpdateStatus),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── DOCUMENTS

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab({required this.loan});
  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final total = loan.documents.length;
    final accepted =
        loan.documents.where((d) => d.status == DocStatus.accepted).length;
    final pct = total == 0 ? 0.0 : accepted / total;
    final hasPending = loan.documents.any((d) =>
        d.status == DocStatus.pending || d.status == DocStatus.uploaded);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('$accepted of $total documents accepted',
                        style: AppText.bodyMD
                            .copyWith(color: AppColors.textPrimary)),
                  ),
                  MonoText('${(pct * 100).toStringAsFixed(0)}%',
                      style: AppText.monoSM),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppProgressBar(value: pct),
            ],
          ),
        ),
        if (hasPending) ...[
          const SizedBox(height: AppSpacing.md),
          TealButton('Accept All Pending',
              icon: Icons.done_all,
              onPressed: () =>
                  showAppSnack(context, 'All pending documents accepted ✓')),
        ],
        const SizedBox(height: AppSpacing.md),
        for (final d in loan.documents) ...[
          _DocRow(doc: d),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _DocRow extends StatelessWidget {
  const _DocRow({required this.doc});
  final LoanDocument doc;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // thumbnail placeholder
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.bgTertiary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              doc.isImage ? Icons.image_outlined : Icons.description_outlined,
              size: 22,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(doc.name,
                          style: AppText.headingSM
                              .copyWith(color: AppColors.textPrimary)),
                    ),
                    AppChip(doc.status.label,
                        bg: doc.status.color.withValues(alpha: 0.12),
                        fg: doc.status.color,
                        dense: true),
                  ],
                ),
                const SizedBox(height: 2),
                Text(doc.description,
                    style: AppText.bodySM
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: AppSpacing.sm),
                _actions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    switch (doc.status) {
      case DocStatus.pending:
      case DocStatus.uploaded:
        return Row(
          children: [
            TealButton('Accept ✓',
                small: true,
                fullWidth: false,
                onPressed: () =>
                    showAppSnack(context, '${doc.name} accepted ✓')),
            const SizedBox(width: AppSpacing.sm),
            SecondaryButton('Reject ✗',
                small: true,
                fullWidth: false,
                onPressed: () => _openRejectSheet(context)),
          ],
        );
      case DocStatus.accepted:
        return Text('Accepted ✓',
            style: AppText.bodySM.copyWith(color: AppColors.successPrimary));
      case DocStatus.rejected:
      case DocStatus.reuploadNeeded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rejected',
                style: AppText.bodySM.copyWith(color: AppColors.errorPrimary)),
            if (doc.rejectionReason != null)
              Text(doc.rejectionReason!,
                  style: AppText.bodySM
                      .copyWith(color: AppColors.textTertiary)),
            const SizedBox(height: AppSpacing.xs),
            TealButton('Re-request',
                small: true,
                fullWidth: false,
                onPressed: () =>
                    showAppSnack(context, 'Re-requested ${doc.name}')),
          ],
        );
    }
  }

  void _openRejectSheet(BuildContext context) {
    final reasons = const [
      'Wrong document',
      'Blurry',
      'Expired',
      'Missing pages',
      'Mismatch',
      'Policy',
    ];
    final selected = <String>{};
    final controller = TextEditingController();
    bool notify = true;
    showAppSheet(
      context,
      title: 'Reject Document',
      child: StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason', style: AppText.bodySM),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final r in reasons)
                  AppFilterChip(
                    label: r,
                    selected: selected.contains(r),
                    selectedColor: AppColors.errorPrimary,
                    onTap: () => setSheet(() {
                      if (selected.contains(r)) {
                        selected.remove(r);
                      } else {
                        selected.add(r);
                      }
                    }),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Explanation',
              hint: 'Add details for the agent…',
              controller: controller,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Switch(
                  value: notify,
                  activeColor: AppColors.tealPrimary,
                  onChanged: (v) => setSheet(() => notify = v),
                ),
                Text('Notify agent', style: AppText.bodyMD),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            DangerButton(
              'Reject Document',
              onPressed: () {
                Navigator.pop(ctx);
                showAppSnack(context, '${doc.name} rejected');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── TIMELINE

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.loan, required this.onAddNote});
  final Loan loan;
  final VoidCallback onAddNote;

  static const Map<String, Color> _typeColors = {
    'status_changed': AppColors.navyPrimary,
    'offer_sent': AppColors.tealPrimary,
    'doc_event': AppColors.infoPrimary,
    'note_added': AppColors.purplePrimary,
    'correction_requested': AppColors.amberPrimary,
    'correction_resolved': AppColors.successPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final events = loan.timeline;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                for (int i = 0; i < events.length; i++)
                  _eventRow(events[i], isLast: i == events.length - 1),
              ],
            ),
          ),
        ),
        StickyBottomBar(
          child: TealButton('Add Internal Note',
              icon: Icons.lock_outline, onPressed: onAddNote),
        ),
      ],
    );
  }

  Widget _eventRow(TimelineEvent e, {required bool isLast}) {
    final color = _typeColors[e.type] ?? AppColors.textTertiary;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.borderLight),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (e.internal) ...[
                        const Icon(Icons.lock,
                            size: 13, color: AppColors.purplePrimary),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          e.title,
                          style: AppText.bodyMD.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(Fmt.ago(e.at), style: AppText.bodySM),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(e.description,
                      style: AppText.bodyMD
                          .copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Text('by ${e.actor}',
                      style: AppText.bodySM
                          .copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── MESSAGES

class _MessagesTab extends StatefulWidget {
  const _MessagesTab({required this.loan, required this.controller});
  final Loan loan;
  final TextEditingController controller;

  @override
  State<_MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<_MessagesTab> {
  String _channel = 'inapp';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: widget.loan.messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, i) => _bubble(widget.loan.messages[i]),
          ),
        ),
        _inputBar(context),
      ],
    );
  }

  // whatsapp → left ; in-app reviewer → right navy
  Widget _bubble(LoanMessage m) {
    final isReviewerInApp = m.channel == 'inapp' && m.senderRole == 'reviewer';
    if (isReviewerInApp) {
      return Align(
        alignment: Alignment.centerRight,
        child: _box(m, color: AppColors.navyLight, align: CrossAxisAlignment.end),
      );
    }
    if (m.channel == 'whatsapp') {
      return Align(
        alignment: Alignment.centerLeft,
        child: _box(m,
            color: AppColors.bgTertiary,
            align: CrossAxisAlignment.start,
            leadingIcon: Icons.chat,
            iconColor: AppColors.successPrimary),
      );
    }
    // in-app from agent → left bordered
    return Align(
      alignment: Alignment.centerLeft,
      child: _box(m,
          color: AppColors.bgSecondary,
          align: CrossAxisAlignment.start,
          bordered: true),
    );
  }

  Widget _box(
    LoanMessage m, {
    required Color color,
    required CrossAxisAlignment align,
    IconData? leadingIcon,
    Color? iconColor,
    bool bordered = false,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: bordered ? Border.all(color: AppColors.borderLight) : null,
      ),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: 14, color: iconColor),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(m.content,
                    style: AppText.bodyMD
                        .copyWith(color: AppColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(Fmt.time(m.at), style: AppText.bodySM),
        ],
      ),
    );
  }

  Widget _inputBar(BuildContext context) {
    final sendColor =
        _channel == 'whatsapp' ? AppColors.successPrimary : AppColors.navyPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                AppFilterChip(
                  label: 'WhatsApp',
                  selected: _channel == 'whatsapp',
                  selectedColor: AppColors.successPrimary,
                  icon: Icons.chat,
                  onTap: () => setState(() => _channel = 'whatsapp'),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppFilterChip(
                  label: 'In-App',
                  selected: _channel == 'inapp',
                  selectedColor: AppColors.tealPrimary,
                  icon: Icons.forum_outlined,
                  onTap: () => setState(() => _channel = 'inapp'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    style:
                        AppText.bodyMD.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Send message…',
                      hintStyle: AppText.bodyMD
                          .copyWith(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.bgTertiary,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: sendColor),
                  onPressed: () {
                    widget.controller.clear();
                    showAppSnack(context, 'Message sent ✓');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
