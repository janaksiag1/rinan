import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/models.dart';
import '../../data/providers/app_providers.dart';
import '../../widgets/widgets.dart';

/// Module 5 — FRS 33–39: Loan Detail (full-screen). Tabs: Details / Documents /
/// Timeline / Messages.
class LoanDetailScreen extends ConsumerStatefulWidget {
  const LoanDetailScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends ConsumerState<LoanDetailScreen> {
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loan = ref.watch(loanByIdProvider(widget.id));
    final client = ref.watch(clientByIdProvider(loan.clientId));

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppAppBar(
          loan.id,
          titleWidget: MonoText(loan.id, style: AppText.monoSM),
          actions: [
            Center(child: StatusBadge(loan.status)),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (v) {
                switch (v) {
                  case 'note':
                    _openAddNote(loan);
                    break;
                  case 'correction':
                    context.push('/loans/${loan.id}/correction');
                    break;
                  case 'share':
                    showAppSnack(context, 'App ID shared ✓');
                    break;
                  case 'export':
                    showAppSnack(context, 'Exporting…');
                    break;
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'note', child: Text('Add Note')),
                PopupMenuItem(
                    value: 'correction', child: Text('Request Correction')),
                PopupMenuItem(value: 'share', child: Text('Share App ID')),
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
                  _DetailsTab(loan: loan, client: client),
                  _DocumentsTab(loan: loan),
                  _TimelineTab(loan: loan),
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: AppCard(
        child: Row(
          children: [
            BankInitialAvatar(loan.bankName[0], size: 40),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loan.bankName,
                    style: AppText.headingSM
                        .copyWith(color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text('${loan.rmName} · RM',
                    style:
                        AppText.bodySM.copyWith(color: AppColors.tealPrimary)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppChip(loan.loanType, dense: true),
                const SizedBox(height: 6),
                MonoText(Fmt.money(loan.amount),
                    style: AppText.displayMedium.copyWith(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openAddNote(Loan loan) {
    bool important = false;
    String? noteType = 'General';
    final controller = TextEditingController();
    showAppSheet(
      context,
      title: 'Add Note',
      child: StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDropdown<String>(
              label: 'Note type',
              items: const ['General', 'Follow-up', 'Document', 'Bank'],
              itemLabel: (e) => e,
              value: noteType,
              onChanged: (v) => setSheet(() => noteType = v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Note',
              hint: 'Type your note…',
              controller: controller,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Switch(
                  value: important,
                  activeColor: AppColors.tealPrimary,
                  onChanged: (v) => setSheet(() => important = v),
                ),
                Text('Flag important', style: AppText.bodyMD),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TealButton(
              'Save Note',
              onPressed: () {
                Navigator.pop(ctx);
                showAppSnack(context, 'Note added ✓');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── DETAILS

class _DetailsTab extends StatelessWidget {
  const _DetailsTab({required this.loan, required this.client});
  final Loan loan;
  final Client client;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Mini client card
        AppCard(
          child: Row(
            children: [
              InitialsAvatar(client.initials, size: 40),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.name,
                      style: AppText.headingSM
                          .copyWith(color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(client.maskedMobile,
                      style: AppText.bodySM
                          .copyWith(color: AppColors.textLink)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Loan Parameters
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loan Parameters', style: AppText.headingSM),
              const SizedBox(height: AppSpacing.sm),
              DetailRow('Type', loan.loanType),
              DetailRow('Amount', Fmt.money(loan.amount),
                  valueStyle: AppText.mono),
              DetailRow('Tenure', '${loan.tenureMonths} months'),
              if (loan.rate != null) DetailRow('Rate', '${loan.rate}%'),
              DetailRow('Purpose', loan.purpose),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _StatusActionPanel(loan: loan),
        if (loan.foir != null) ...[
          const SizedBox(height: AppSpacing.md),
          _foirCard(loan.foir!),
        ],
      ],
    );
  }

  Widget _foirCard(double foir) {
    final color = foir < 40
        ? AppColors.successPrimary
        : foir < 60
            ? AppColors.warningPrimary
            : AppColors.errorPrimary;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FOIR', style: AppText.headingSM),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(value: foir / 100, color: color),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              MonoText('FOIR: ${foir.toStringAsFixed(0)}%',
                  style: AppText.monoSM, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusActionPanel extends StatelessWidget {
  const _StatusActionPanel({required this.loan});
  final Loan loan;

  @override
  Widget build(BuildContext context) {
    switch (loan.status) {
      case LoanStatus.draft:
        return _panel(
          AppColors.warningLight,
          message: "This offer hasn't been submitted yet.",
          action: TealButton(
            'Submit Offer to Bank →',
            onPressed: () => showAppSnack(context, 'Offer submitted ✓'),
          ),
        );
      case LoanStatus.applied:
        return _panel(
          AppColors.infoLight,
          message: 'Waiting for you to submit to bank.',
          action: TealButton(
            'Submit to Bank →',
            onPressed: () => showAppSnack(context, 'Submitted to bank ✓'),
          ),
        );
      case LoanStatus.submitted:
        return _panel(
          AppColors.infoLight,
          message: 'Application submitted to the bank.',
        );
      case LoanStatus.underReview:
        return _panel(
          AppColors.warningLight,
          message: 'Bank is reviewing this application.',
        );
      case LoanStatus.approved:
        return _panel(
          AppColors.successLight,
          messageWidget: Row(
            children: [
              const Icon(Icons.verified,
                  size: 18, color: AppColors.successPrimary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Approved — ${Fmt.money(loan.amount)} at ${loan.rate ?? '-'}%',
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          action: const SecondaryButton('View Approval Details'),
        );
      case LoanStatus.rejected:
        return _panel(
          AppColors.errorLight,
          messageWidget: Text(
            _rejectionReason(loan),
            style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
          ),
          action: DangerButton(
            'Reapply with Another Bank',
            onPressed: () => showAppSnack(context, 'Choose another bank'),
          ),
        );
      case LoanStatus.sanctioned:
        return _panel(
          AppColors.successLight,
          message: 'Loan sanctioned by the bank.',
          action: TealButton(
            'Download Sanction Letter',
            onPressed: () => showAppSnack(context, 'Downloading…'),
          ),
        );
      case LoanStatus.disbursed:
        return _panel(
          AppColors.successLight,
          messageWidget: Text(
            '🎉 Loan disbursed — ${Fmt.money(loan.amount)}',
            style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
          ),
          action: TealButton(
            'Download Repayment Schedule',
            onPressed: () => showAppSnack(context, 'Downloading…'),
          ),
        );
    }
  }

  String _rejectionReason(Loan loan) {
    for (final d in loan.documents) {
      if (d.status == DocStatus.rejected && d.rejectionReason != null) {
        return 'Rejected: ${d.rejectionReason}';
      }
    }
    return 'Application was rejected by the bank.';
  }

  Widget _panel(
    Color bg, {
    String? message,
    Widget? messageWidget,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          messageWidget ??
              Text(message ?? '',
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textPrimary)),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.md),
            action,
          ],
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
    final done = loan.docsUploaded;
    final pct = total == 0 ? 0.0 : done / total;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        // Completion meter
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '$done of $total documents uploaded',
                      style: AppText.bodyMD
                          .copyWith(color: AppColors.textPrimary),
                    ),
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
        const SizedBox(height: AppSpacing.md),
        for (final d in loan.documents) ...[
          _docRow(context, d),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }

  Widget _docRow(BuildContext context, LoanDocument d) {
    Widget action;
    switch (d.status) {
      case DocStatus.pending:
        action = TealButton('Upload',
            small: true,
            fullWidth: false,
            onPressed: () => showAppSnack(context, 'Upload ${d.name}'));
        break;
      case DocStatus.uploaded:
      case DocStatus.accepted:
        action = TextActionButton('View',
            onPressed: () => context.push('/documents/${d.id}'));
        break;
      case DocStatus.rejected:
      case DocStatus.reuploadNeeded:
        action = TealButton('Re-upload',
            small: true,
            fullWidth: false,
            onPressed: () => showAppSnack(context, 'Re-upload ${d.name}'));
        break;
    }

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: d.status.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(Icons.insert_drive_file_outlined,
                size: 18, color: d.status.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(d.name,
                          style: AppText.headingSM
                              .copyWith(color: AppColors.textPrimary)),
                    ),
                    AppChip(d.required ? 'Required' : 'Optional', dense: true),
                  ],
                ),
                const SizedBox(height: 2),
                Text(d.description,
                    style: AppText.bodySM
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text(d.status.label,
                    style: AppText.bodySM.copyWith(color: d.status.color)),
                const SizedBox(height: AppSpacing.sm),
                Align(alignment: Alignment.centerLeft, child: action),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── TIMELINE

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.loan});
  final Loan loan;

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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          for (int i = 0; i < events.length; i++)
            _eventRow(events[i], isLast: i == events.length - 1),
        ],
      ),
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

class _MessagesTab extends StatelessWidget {
  const _MessagesTab({required this.loan, required this.controller});
  final Loan loan;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: loan.messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (_, i) => _bubble(loan.messages[i]),
          ),
        ),
        _inputBar(context),
      ],
    );
  }

  Widget _bubble(LoanMessage m) {
    final isWhatsapp = m.channel == 'whatsapp';
    final isAgentInApp = m.channel == 'inapp' && m.senderRole == 'agent';

    if (isAgentInApp) {
      // in-app + agent → right navy bubble
      return Align(
        alignment: Alignment.centerRight,
        child: _bubbleBox(
          m,
          color: AppColors.navyLight,
          align: CrossAxisAlignment.end,
        ),
      );
    }

    if (isWhatsapp) {
      // whatsapp → left bgTertiary bubble with WhatsApp-ish icon
      return Align(
        alignment: Alignment.centerLeft,
        child: _bubbleBox(
          m,
          color: AppColors.bgTertiary,
          align: CrossAxisAlignment.start,
          leadingIcon: Icons.chat,
          iconColor: AppColors.successPrimary,
        ),
      );
    }

    // inapp + reviewer → left bordered bgSecondary bubble
    return Align(
      alignment: Alignment.centerLeft,
      child: _bubbleBox(
        m,
        color: AppColors.bgSecondary,
        align: CrossAxisAlignment.start,
        bordered: true,
      ),
    );
  }

  Widget _bubbleBox(
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
        border: bordered
            ? Border.all(color: AppColors.borderLight)
            : null,
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
                child: Text(
                  m.content,
                  style: AppText.bodyMD
                      .copyWith(color: AppColors.textPrimary),
                ),
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
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: AppText.bodyMD.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Send message…',
                  hintStyle:
                      AppText.bodyMD.copyWith(color: AppColors.textTertiary),
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
              icon: const Icon(Icons.send_rounded, color: AppColors.tealPrimary),
              onPressed: () {
                controller.clear();
                showAppSnack(context, 'Message sent ✓');
              },
            ),
          ],
        ),
      ),
    );
  }
}
