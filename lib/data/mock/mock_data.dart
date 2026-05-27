import '../../core/constants/app_enums.dart';
import '../models/models.dart';

/// Central static mock store. No network — every provider reads from here.
class Mock {
  Mock._();

  static DateTime _daysAgo(int d) => DateTime.now().subtract(Duration(days: d));
  static DateTime _hoursAgo(int h) => DateTime.now().subtract(Duration(hours: h));
  static DateTime _daysAhead(int d) => DateTime.now().add(Duration(days: d));

  static const loanTypes = [
    'Personal Loan',
    'Home Loan',
    'Business Loan',
    'Car Loan',
    'Two Wheeler Loan',
    'Education Loan',
    'Loan Against Property',
    'Gold Loan',
    'MSME Loan',
  ];

  static const cities = [
    'Mumbai',
    'Pune',
    'Bengaluru',
    'Delhi',
    'Hyderabad',
    'Chennai',
    'Ahmedabad',
    'Jaipur',
    'Kolkata',
    'Surat',
  ];

  static const bankTypes = [
    'Private Sector Bank',
    'Public Sector Bank',
    'NBFC',
    'Co-operative Bank',
    'Small Finance Bank',
  ];

  // — CLIENTS —
  static final List<Client> clients = [
    Client(
      id: 'c1',
      name: 'Rahul Sharma',
      mobile: '9876543210',
      email: 'rahul.sharma@email.com',
      city: 'Mumbai',
      addedOn: _daysAgo(45),
      lastActive: _daysAgo(2),
      leadSource: 'Referral',
      notes: 'Looking for home loan, salaried at TCS.',
      activeLoans: 2,
      completedLoans: 1,
      totalDisbursed: 3500000,
      unread: true,
      portalSynced: true,
      dob: DateTime(1990, 6, 2),
      latestStatus: LoanStatus.underReview,
    ),
    Client(
      id: 'c2',
      name: 'Priya Patel',
      mobile: '9823456701',
      email: 'priya.p@email.com',
      city: 'Pune',
      addedOn: _daysAgo(30),
      lastActive: _daysAgo(1),
      leadSource: 'Social',
      activeLoans: 1,
      completedLoans: 0,
      totalDisbursed: 0,
      portalSynced: true,
      anniversary: DateTime(2018, 6, 5),
      latestStatus: LoanStatus.applied,
    ),
    Client(
      id: 'c3',
      name: 'Amit Kumar',
      mobile: '9911223344',
      city: 'Delhi',
      addedOn: _daysAgo(20),
      lastActive: _daysAgo(5),
      leadSource: 'Walk-in',
      activeLoans: 0,
      completedLoans: 2,
      totalDisbursed: 1200000,
      latestStatus: LoanStatus.disbursed,
    ),
    Client(
      id: 'c4',
      name: 'Sneha Reddy',
      mobile: '9845012345',
      email: 'sneha.reddy@email.com',
      city: 'Hyderabad',
      addedOn: _daysAgo(12),
      lastActive: _daysAgo(3),
      leadSource: 'Existing Client',
      activeLoans: 1,
      totalDisbursed: 0,
      unread: true,
      latestStatus: LoanStatus.approved,
    ),
    Client(
      id: 'c5',
      name: 'Vikram Singh',
      mobile: '9700112233',
      city: 'Jaipur',
      addedOn: _daysAgo(8),
      leadSource: 'Referral',
      activeLoans: 1,
      latestStatus: LoanStatus.rejected,
    ),
    Client(
      id: 'c6',
      name: 'Anjali Mehta',
      mobile: '9988776655',
      email: 'anjali.m@email.com',
      city: 'Ahmedabad',
      addedOn: _daysAgo(3),
      leadSource: 'Social',
      dob: _daysAhead(1),
      latestStatus: LoanStatus.draft,
    ),
  ];

  // — BANKS —
  static final List<Bank> banks = [
    Bank(
      id: 'b1',
      name: 'HDFC Bank',
      type: 'Private Sector Bank',
      branch: 'Andheri West',
      city: 'Mumbai',
      rmName: 'Suresh Iyer',
      rmMobile: '9870000001',
      rmEmail: 'suresh.iyer@hdfc.com',
      portal: PortalStatus.connected,
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan'],
      rates: {'Personal Loan': 10.5, 'Home Loan': 8.4, 'Car Loan': 9.2},
      activeLoans: 4,
      connectedAt: _daysAgo(60),
    ),
    Bank(
      id: 'b2',
      name: 'ICICI Bank',
      type: 'Private Sector Bank',
      branch: 'Koregaon Park',
      city: 'Pune',
      rmName: 'Meena Joshi',
      rmMobile: '9870000002',
      portal: PortalStatus.connected,
      loanTypes: ['Personal Loan', 'Business Loan', 'Loan Against Property'],
      rates: {'Personal Loan': 11.0, 'Business Loan': 14.5},
      activeLoans: 3,
      connectedAt: _daysAgo(40),
    ),
    Bank(
      id: 'b3',
      name: 'Bajaj Finserv',
      type: 'NBFC',
      city: 'Delhi',
      rmName: 'Rakesh Gupta',
      rmMobile: '9870000003',
      portal: PortalStatus.notConnected,
      loanTypes: ['Personal Loan', 'Two Wheeler Loan', 'Gold Loan'],
      rates: {'Personal Loan': 12.5, 'Gold Loan': 10.0},
      activeLoans: 1,
    ),
    Bank(
      id: 'b4',
      name: 'Axis Bank',
      type: 'Private Sector Bank',
      city: 'Bengaluru',
      rmName: 'Deepa Nair',
      rmMobile: '9870000004',
      portal: PortalStatus.connected,
      loanTypes: ['Home Loan', 'Car Loan', 'Education Loan'],
      rates: {'Home Loan': 8.6, 'Education Loan': 9.5},
      activeLoans: 2,
      connectedAt: _daysAgo(15),
    ),
  ];

  static List<LoanDocument> _docs() => const [
    LoanDocument(
      id: 'd1',
      name: 'PAN Card',
      description: 'Identity proof',
      status: DocStatus.accepted,
    ),
    LoanDocument(
      id: 'd2',
      name: 'Aadhaar Card',
      description: 'Address proof',
      status: DocStatus.accepted,
    ),
    LoanDocument(
      id: 'd3',
      name: 'Salary Slips (3 months)',
      description: 'Income proof',
      status: DocStatus.uploaded,
    ),
    LoanDocument(
      id: 'd4',
      name: 'Bank Statement (6 months)',
      description: 'Income proof',
      status: DocStatus.rejected,
      rejectionReason: 'Document is blurry/unclear',
    ),
    LoanDocument(
      id: 'd5',
      name: 'Form 16',
      description: 'Tax proof',
      status: DocStatus.pending,
      required: false,
    ),
    LoanDocument(
      id: 'd6',
      name: 'Passport Photo',
      description: 'Recent photograph',
      status: DocStatus.pending,
    ),
  ];

  static List<TimelineEvent> _timeline() => [
    TimelineEvent(
      type: 'offer_sent',
      title: 'Offer sent',
      description: 'WhatsApp loan offer delivered to client.',
      actor: 'You',
      at: _daysAgo(9),
    ),
    TimelineEvent(
      type: 'status_changed',
      title: 'Application submitted to bank',
      description: 'Application forwarded to HDFC Bank for review.',
      actor: 'You',
      at: _daysAgo(7),
    ),
    TimelineEvent(
      type: 'doc_event',
      title: 'Documents uploaded',
      description: 'Client uploaded 4 documents via portal.',
      actor: 'Rahul Sharma',
      at: _daysAgo(6),
    ),
    TimelineEvent(
      type: 'correction_requested',
      title: 'Correction requested',
      description: 'Bank statement was blurry — re-upload requested.',
      actor: 'Meena Joshi (RM)',
      at: _daysAgo(4),
    ),
    TimelineEvent(
      type: 'note_added',
      title: 'Internal note added',
      description: 'Client confirmed salary account transfer.',
      actor: 'You',
      at: _daysAgo(3),
      internal: true,
    ),
    TimelineEvent(
      type: 'status_changed',
      title: 'Under review',
      description: 'Bank began formal assessment.',
      actor: 'Meena Joshi (RM)',
      at: _daysAgo(2),
    ),
  ];

  static List<LoanMessage> _messages() => [
    LoanMessage(
      content:
          'Hi Rahul! Here is your pre-approved Personal Loan offer from HDFC Bank at 10.5% p.a. Tap the link to proceed.',
      channel: 'whatsapp',
      senderRole: 'agent',
      at: _daysAgo(9),
    ),
    LoanMessage(
      content: 'Thanks! I have uploaded the documents.',
      channel: 'whatsapp',
      senderRole: 'agent',
      at: _daysAgo(6),
    ),
    LoanMessage(
      content:
          'Your bank statement needs to be re-uploaded — the copy was unclear.',
      channel: 'inapp',
      senderRole: 'reviewer',
      at: _daysAgo(4),
    ),
    LoanMessage(
      content: 'Noted, I will share a clearer copy by today.',
      channel: 'inapp',
      senderRole: 'agent',
      at: _daysAgo(4),
    ),
  ];

  // — LOANS / APPLICATIONS —
  static final List<Loan> loans = [
    Loan(
      id: 'RIN-2026-0042',
      clientId: 'c1',
      clientName: 'Rahul Sharma',
      bankId: 'b1',
      bankName: 'HDFC Bank',
      rmName: 'Suresh Iyer',
      loanType: 'Home Loan',
      amount: 4500000,
      tenureMonths: 240,
      rate: 8.4,
      purpose: 'Home purchase',
      status: LoanStatus.underReview,
      submittedOn: _daysAgo(7),
      daysOpen: 7,
      foir: 42,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
    Loan(
      id: 'RIN-2026-0041',
      clientId: 'c2',
      clientName: 'Priya Patel',
      bankId: 'b2',
      bankName: 'ICICI Bank',
      rmName: 'Meena Joshi',
      loanType: 'Personal Loan',
      amount: 800000,
      tenureMonths: 48,
      rate: 11.0,
      status: LoanStatus.applied,
      submittedOn: _daysAgo(2),
      daysOpen: 2,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
    Loan(
      id: 'RIN-2026-0039',
      clientId: 'c4',
      clientName: 'Sneha Reddy',
      bankId: 'b4',
      bankName: 'Axis Bank',
      rmName: 'Deepa Nair',
      loanType: 'Car Loan',
      amount: 1200000,
      tenureMonths: 60,
      rate: 9.2,
      status: LoanStatus.approved,
      submittedOn: _daysAgo(10),
      daysOpen: 10,
      foir: 38,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
    Loan(
      id: 'RIN-2026-0035',
      clientId: 'c3',
      clientName: 'Amit Kumar',
      bankId: 'b1',
      bankName: 'HDFC Bank',
      rmName: 'Suresh Iyer',
      loanType: 'Personal Loan',
      amount: 500000,
      tenureMonths: 36,
      rate: 10.5,
      status: LoanStatus.disbursed,
      submittedOn: _daysAgo(25),
      daysOpen: 25,
      foir: 35,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
    Loan(
      id: 'RIN-2026-0033',
      clientId: 'c5',
      clientName: 'Vikram Singh',
      bankId: 'b3',
      bankName: 'Bajaj Finserv',
      rmName: 'Rakesh Gupta',
      loanType: 'Two Wheeler Loan',
      amount: 120000,
      tenureMonths: 24,
      status: LoanStatus.rejected,
      submittedOn: _daysAgo(14),
      daysOpen: 14,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
    Loan(
      id: 'RIN-2026-0030',
      clientId: 'c6',
      clientName: 'Anjali Mehta',
      bankId: 'b2',
      bankName: 'ICICI Bank',
      rmName: 'Meena Joshi',
      loanType: 'Business Loan',
      amount: 2500000,
      tenureMonths: 84,
      status: LoanStatus.draft,
      submittedOn: _daysAgo(1),
      daysOpen: 1,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
    Loan(
      id: 'RIN-2026-0028',
      clientId: 'c1',
      clientName: 'Rahul Sharma',
      bankId: 'b4',
      bankName: 'Axis Bank',
      rmName: 'Deepa Nair',
      loanType: 'Education Loan',
      amount: 1500000,
      tenureMonths: 120,
      rate: 9.5,
      status: LoanStatus.sanctioned,
      submittedOn: _daysAgo(18),
      daysOpen: 18,
      foir: 48,
      documents: _docs(),
      timeline: _timeline(),
      messages: _messages(),
      agentName: 'You',
    ),
  ];

  // — DASHBOARD WIDGETS —
  static int creditBalance = 320;
  static const String planName = 'Growth Plan';

  static final List<PendingAction> pendingActions = [
    PendingAction(
      type: 'loan_status_change',
      title: 'Sneha Reddy — Approved',
      subtitle: 'Axis Bank approved the car loan.',
      at: _hoursAgo(3),
    ),
    PendingAction(
      type: 'doc_reuploaded',
      title: 'Rahul Sharma re-uploaded docs',
      subtitle: 'Bank statement ready for review.',
      at: _hoursAgo(6),
    ),
    PendingAction(
      type: 'offer_not_opened_48h',
      title: 'Offer not opened',
      subtitle: 'Priya Patel hasn\'t opened the offer (48h).',
      at: _daysAgo(2),
    ),
    PendingAction(
      type: 'idle_loan_7d',
      title: 'Idle application',
      subtitle: 'Vikram Singh — no movement in 7 days.',
      at: _daysAgo(7),
    ),
    PendingAction(
      type: 'kyc_pending',
      title: 'Complete your KYC',
      subtitle: 'Selfie verification still pending.',
      at: _daysAgo(1),
    ),
  ];

  static final List<ActivityItem> activity = [
    ActivityItem(
      type: 'offer_sent',
      description: 'You sent a loan offer',
      subject: 'Anjali Mehta',
      at: _hoursAgo(2),
    ),
    ActivityItem(
      type: 'status_change',
      description: 'Application moved to Under Review',
      subject: 'Rahul Sharma',
      at: _hoursAgo(5),
    ),
    ActivityItem(
      type: 'doc_uploaded',
      description: 'Documents uploaded',
      subject: 'Priya Patel',
      at: _hoursAgo(20),
    ),
    ActivityItem(
      type: 'payment',
      description: 'Loan disbursed',
      subject: 'Amit Kumar',
      at: _daysAgo(2),
    ),
    ActivityItem(
      type: 'client_added',
      description: 'New client added',
      subject: 'Anjali Mehta',
      at: _daysAgo(3),
    ),
    ActivityItem(
      type: 'status_change',
      description: 'Application approved',
      subject: 'Sneha Reddy',
      at: _daysAgo(4),
    ),
  ];

  static final List<KpiCard> agentKpis = [
    KpiCard(label: 'Active Loans', value: '12', delta: '+3', deltaUp: true),
    KpiCard(label: 'This Month', value: '8', delta: '+2', deltaUp: true),
    KpiCard(label: 'Approval Rate', value: '74%', delta: '+5%', deltaUp: true),
    KpiCard(label: 'Disbursed', value: '₹48L', delta: '-2%', deltaUp: false),
  ];

  // — OCCASIONS —
  static final List<Occasion> occasions = [
    Occasion(
      clientId: 'c6',
      clientName: 'Anjali Mehta',
      type: 'Birthday',
      date: _daysAhead(0),
      daysUntil: 0,
      autoSend: true,
    ),
    Occasion(
      clientId: 'c2',
      clientName: 'Priya Patel',
      type: 'Anniversary',
      date: _daysAhead(1),
      daysUntil: 1,
      autoSend: true,
    ),
    Occasion(
      clientId: 'c1',
      clientName: 'Rahul Sharma',
      type: 'Birthday',
      date: _daysAhead(3),
      daysUntil: 3,
      autoSend: false,
    ),
    Occasion(
      clientId: 'c4',
      clientName: 'Sneha Reddy',
      type: 'Anniversary',
      date: _daysAhead(12),
      daysUntil: 12,
      autoSend: true,
    ),
  ];

  static final List<Festival> festivals = [
    Festival(name: 'Makar Sankranti', category: 'Hindu', date: DateTime(2026, 1, 14), enabled: true),
    Festival(name: 'Republic Day', category: 'National', date: DateTime(2026, 1, 26), enabled: true),
    Festival(name: 'Holi', category: 'Hindu', date: DateTime(2026, 3, 4)),
    Festival(name: 'Eid al-Fitr', category: 'Muslim', date: DateTime(2026, 3, 20), enabled: true),
    Festival(name: 'Good Friday', category: 'Christian', date: DateTime(2026, 4, 3)),
    Festival(name: 'Baisakhi', category: 'Sikh', date: DateTime(2026, 4, 14)),
    Festival(name: 'Independence Day', category: 'National', date: DateTime(2026, 8, 15), enabled: true),
    Festival(name: 'Diwali', category: 'Hindu', date: DateTime(2026, 11, 8), enabled: true),
    Festival(name: 'Christmas', category: 'Christian', date: DateTime(2026, 12, 25)),
  ];

  // — NOTIFICATIONS —
  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      title: 'Loan approved 🎉',
      body: 'Sneha Reddy\'s car loan was approved by Axis Bank.',
      category: 'Loans',
      at: _hoursAgo(3),
      iconType: 'loan',
    ),
    AppNotification(
      id: 'n2',
      title: 'Documents re-uploaded',
      body: 'Rahul Sharma re-uploaded the bank statement for review.',
      category: 'Loans',
      at: _hoursAgo(6),
      iconType: 'doc',
    ),
    AppNotification(
      id: 'n3',
      title: 'Credits running low',
      body: 'You have 320 credits left. Top up to keep sending offers.',
      category: 'Billing',
      at: _daysAgo(1),
      read: true,
      iconType: 'billing',
    ),
    AppNotification(
      id: 'n4',
      title: 'New client added',
      body: 'Anjali Mehta was added to your client list.',
      category: 'Clients',
      at: _daysAgo(3),
      read: true,
      iconType: 'client',
    ),
    AppNotification(
      id: 'n5',
      title: 'App update available',
      body: 'A new version of Riण is available with improvements.',
      category: 'System',
      at: _daysAgo(5),
      read: true,
      iconType: 'system',
    ),
  ];

  // — BILLING —
  static final List<CreditPack> creditPacks = [
    CreditPack(id: 'p1', credits: 100, price: 199),
    CreditPack(id: 'p2', credits: 500, price: 799, badge: 'Popular'),
    CreditPack(id: 'p3', credits: 1000, price: 1399, badge: 'Best Value'),
    CreditPack(id: 'p4', credits: 2500, price: 2999),
  ];

  static const List<Plan> plans = [
    Plan(
      id: 'starter',
      name: 'Starter',
      price: 'Free Forever',
      credits: 50,
      banks: '3 banks max',
      features: ['50 credits/month', '3 bank partners', 'Basic analytics'],
    ),
    Plan(
      id: 'growth',
      name: 'Growth',
      price: '₹499/month',
      credits: 500,
      banks: 'Unlimited banks',
      badge: '⭐ Popular',
      features: ['500 credits/month', 'Unlimited banks', 'Full analytics'],
    ),
    Plan(
      id: 'pro',
      name: 'Pro',
      price: '₹999/month',
      credits: 2000,
      banks: 'Unlimited banks',
      features: ['2000 credits/month', 'Priority support', 'Bulk tools'],
    ),
    Plan(
      id: 'enterprise',
      name: 'Enterprise',
      price: 'Contact us',
      credits: 0,
      banks: 'Custom',
      features: ['Custom credits', 'Dedicated manager', 'API access'],
    ),
  ];

  static final List<BillingRow> billingHistory = [
    BillingRow(id: 't1', description: '500 credits top-up', date: _daysAgo(3), amount: 500, type: 'credit'),
    BillingRow(id: 't2', description: 'Growth Plan — Monthly', date: _daysAgo(8), amount: -499, type: 'subscription'),
    BillingRow(id: 't3', description: '100 credits top-up', date: _daysAgo(20), amount: 100, type: 'credit'),
    BillingRow(id: 't4', description: 'Refund — failed payment', date: _daysAgo(35), amount: 199, type: 'refund'),
    BillingRow(id: 't5', description: 'Growth Plan — Monthly', date: _daysAgo(38), amount: -499, type: 'subscription'),
  ];

  static final List<CommissionRow> commissions = [
    CommissionRow(date: _daysAgo(2), client: 'Amit Kumar', bank: 'HDFC Bank', disbursed: 500000, rate: 1.2, gross: 6000, tds: 600),
    CommissionRow(date: _daysAgo(18), client: 'Rahul Sharma', bank: 'Axis Bank', disbursed: 1500000, rate: 0.8, gross: 12000, tds: 1200),
    CommissionRow(date: _daysAgo(40), client: 'Sneha Reddy', bank: 'ICICI Bank', disbursed: 1200000, rate: 1.0, gross: 12000, tds: 1200),
  ];

  // — REVIEWER: AGENTS —
  static final List<Agent> agents = [
    Agent(id: 'a1', name: 'Karan Malhotra', dsaCode: 'DSA-1042', city: 'Mumbai', status: 'active', activeLoans: 6, thisMonth: 9, approvalRate: 78, connectedAt: _daysAgo(120)),
    Agent(id: 'a2', name: 'Neha Verma', dsaCode: 'DSA-1088', city: 'Pune', status: 'active', activeLoans: 4, thisMonth: 5, approvalRate: 71, connectedAt: _daysAgo(90)),
    Agent(id: 'a3', name: 'Sanjay Rao', dsaCode: 'DSA-1120', city: 'Bengaluru', status: 'dormant', activeLoans: 1, thisMonth: 0, approvalRate: 60, connectedAt: _daysAgo(200)),
    Agent(id: 'a4', name: 'Pooja Shah', dsaCode: 'DSA-1155', city: 'Ahmedabad', status: 'not_connected', portal: PortalStatus.notConnected, activeLoans: 0, thisMonth: 0, approvalRate: 0),
  ];

  // — REVIEWER: RATES —
  static final List<Rate> rates = [
    Rate(id: 'r1', loanType: 'Personal Loan', ratePct: 10.5, rateType: 'Reducing Balance', label: 'Pre-approved', effectiveFrom: _daysAgo(10), offersSent: 24),
    Rate(id: 'r2', loanType: 'Home Loan', ratePct: 8.4, rateType: 'Reducing Balance', effectiveFrom: _daysAgo(45), offersSent: 12, stale: true),
    Rate(id: 'r3', loanType: 'Car Loan', ratePct: 9.2, rateType: 'Flat', label: 'Summer Special', effectiveFrom: _daysAgo(5), validUntil: _daysAhead(25), offersSent: 8),
  ];

  // — REVIEWER: DASHBOARD —
  static final List<KpiCard> reviewerKpis = [
    KpiCard(label: 'Apps This Month', value: '42', delta: '+6', deltaUp: true),
    KpiCard(label: 'Approval Rate', value: '68%', delta: '+3%', deltaUp: true),
    KpiCard(label: 'Avg Processing', value: '5.2d', delta: '-0.4d', deltaUp: true),
    KpiCard(label: 'Disbursed', value: '₹2.4Cr', delta: '+12%', deltaUp: true),
  ];

  static final Map<LoanStatus, int> reviewerPipeline = {
    LoanStatus.submitted: 14,
    LoanStatus.underReview: 9,
    LoanStatus.approved: 7,
    LoanStatus.rejected: 3,
    LoanStatus.sanctioned: 5,
    LoanStatus.disbursed: 11,
  };

  // — HELP —
  static const List<FaqItem> faqs = [
    FaqItem(question: 'How do I send a loan offer?', answer: 'Tap the "Send Offer" button, choose a client, select a bank & rate, then preview and send via WhatsApp.', category: 'Offers'),
    FaqItem(question: 'What are credits?', answer: 'Each loan offer sent costs 1 credit. You can top up credits anytime from the Billing screen.', category: 'Credits'),
    FaqItem(question: 'How do I connect a bank portal?', answer: 'Open the bank, choose "Connect Customer Portal", and share the setup link with the bank team.', category: 'Account'),
    FaqItem(question: 'Why was a document rejected?', answer: 'Reviewers reject documents for blur, expiry, or mismatch. Check the rejection reason and re-upload.', category: 'Documents'),
    FaqItem(question: 'How is commission calculated?', answer: 'Commission is auto-calculated on disbursement based on the bank\'s payout rate, minus TDS.', category: 'Billing'),
  ];

  // — SESSIONS —
  static final List<Session> sessions = [
    Session(id: 's1', device: 'iPhone 14 Pro', os: 'iOS 17.2', city: 'Mumbai', lastActive: _hoursAgo(0), current: true),
    Session(id: 's2', device: 'Pixel 7', os: 'Android 14', city: 'Mumbai', lastActive: _hoursAgo(8)),
    Session(id: 's3', device: 'Chrome on Windows', os: 'Web', city: 'Surat', lastActive: _daysAgo(2), suspicious: true),
  ];

  // — LOOKUPS —
  static Client clientById(String id) =>
      clients.firstWhere((c) => c.id == id, orElse: () => clients.first);
  static Loan loanById(String id) =>
      loans.firstWhere((l) => l.id == id, orElse: () => loans.first);
  static Bank bankById(String id) =>
      banks.firstWhere((b) => b.id == id, orElse: () => banks.first);
  static Agent agentById(String id) =>
      agents.firstWhere((a) => a.id == id, orElse: () => agents.first);
  static Rate rateById(String id) =>
      rates.firstWhere((r) => r.id == id, orElse: () => rates.first);
}
