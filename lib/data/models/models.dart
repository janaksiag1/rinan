import '../../core/constants/app_enums.dart';

/// All Riण domain models. Plain immutable data — UI/UX only, no API binding.

class Client {
  final String id;
  final String name;
  final String mobile; // raw 10 digit
  final String? email;
  final String city;
  final DateTime addedOn;
  final DateTime? lastActive;
  final String leadSource;
  final String? notes;
  final int activeLoans;
  final int completedLoans;
  final int totalDisbursed;
  final bool unread;
  final bool portalSynced;
  final DateTime? dob;
  final DateTime? anniversary;
  final LoanStatus? latestStatus;

  const Client({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    required this.city,
    required this.addedOn,
    this.lastActive,
    this.leadSource = 'Referral',
    this.notes,
    this.activeLoans = 0,
    this.completedLoans = 0,
    this.totalDisbursed = 0,
    this.unread = false,
    this.portalSynced = false,
    this.dob,
    this.anniversary,
    this.latestStatus,
  });

  String get maskedMobile =>
      '+91 ·····${mobile.substring(mobile.length - 4)}';
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class Bank {
  final String id;
  final String name;
  final String type;
  final String? branch;
  final String city;
  final String rmName;
  final String rmMobile;
  final String? rmEmail;
  final PortalStatus portal;
  final List<String> loanTypes;
  final Map<String, double> rates; // loanType -> rate %
  final int activeLoans;
  final DateTime? connectedAt;

  const Bank({
    required this.id,
    required this.name,
    required this.type,
    this.branch,
    required this.city,
    required this.rmName,
    required this.rmMobile,
    this.rmEmail,
    this.portal = PortalStatus.notConnected,
    this.loanTypes = const [],
    this.rates = const {},
    this.activeLoans = 0,
    this.connectedAt,
  });

  String get shortName {
    final words = name.split(' ');
    return words.first;
  }

  String get initial => name.substring(0, 1).toUpperCase();
}

class LoanDocument {
  final String id;
  final String name;
  final String description;
  final DocStatus status;
  final bool required;
  final String? rejectionReason;
  final bool isImage;

  const LoanDocument({
    required this.id,
    required this.name,
    required this.description,
    this.status = DocStatus.pending,
    this.required = true,
    this.rejectionReason,
    this.isImage = true,
  });
}

class TimelineEvent {
  final String type; // status_changed, offer_sent, doc_event, note_added, ...
  final String title;
  final String description;
  final String actor;
  final DateTime at;
  final bool internal;

  const TimelineEvent({
    required this.type,
    required this.title,
    required this.description,
    required this.actor,
    required this.at,
    this.internal = false,
  });
}

class LoanMessage {
  final String content;
  final String channel; // whatsapp | inapp
  final String senderRole; // agent | reviewer | system
  final DateTime at;

  const LoanMessage({
    required this.content,
    required this.channel,
    required this.senderRole,
    required this.at,
  });
}

class Loan {
  final String id; // app id e.g. RIN-2024-0042
  final String clientId;
  final String clientName;
  final String bankId;
  final String bankName;
  final String rmName;
  final String loanType;
  final int amount;
  final int tenureMonths;
  final double? rate;
  final String purpose;
  final LoanStatus status;
  final DateTime submittedOn;
  final int daysOpen;
  final double? foir;
  final List<LoanDocument> documents;
  final List<TimelineEvent> timeline;
  final List<LoanMessage> messages;
  final String? agentName;

  const Loan({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.bankId,
    required this.bankName,
    required this.rmName,
    required this.loanType,
    required this.amount,
    this.tenureMonths = 60,
    this.rate,
    this.purpose = 'Personal use',
    required this.status,
    required this.submittedOn,
    required this.daysOpen,
    this.foir,
    this.documents = const [],
    this.timeline = const [],
    this.messages = const [],
    this.agentName,
  });

  UrgencyBand get urgency => UrgencyBand.fromDays(daysOpen);
  int get docsUploaded =>
      documents.where((d) => d.status != DocStatus.pending).length;
}

class Occasion {
  final String clientId;
  final String clientName;
  final String type; // Birthday | Anniversary | Festival name
  final DateTime date;
  final int daysUntil;
  final bool autoSend;

  const Occasion({
    required this.clientId,
    required this.clientName,
    required this.type,
    required this.date,
    required this.daysUntil,
    this.autoSend = true,
  });
}

class Festival {
  final String name;
  final String category; // Hindu, Muslim, ...
  final DateTime date;
  final bool enabled;
  const Festival({
    required this.name,
    required this.category,
    required this.date,
    this.enabled = false,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String category; // Loans | Clients | Billing | System
  final DateTime at;
  final bool read;
  final String iconType;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.at,
    this.read = false,
    this.iconType = 'system',
  });
}

class ActivityItem {
  final String type;
  final String description;
  final String subject;
  final DateTime at;
  const ActivityItem({
    required this.type,
    required this.description,
    required this.subject,
    required this.at,
  });
}

class PendingAction {
  final String type;
  final String title;
  final String subtitle;
  final DateTime at;
  const PendingAction({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.at,
  });
}

class BillingRow {
  final String id;
  final String description;
  final DateTime date;
  final int amount; // signed; +credit add, - subscription
  final String type; // credit | subscription | refund
  const BillingRow({
    required this.id,
    required this.description,
    required this.date,
    required this.amount,
    required this.type,
  });
}

class CreditPack {
  final String id;
  final int credits;
  final int price;
  final String? badge; // Popular | Best Value
  const CreditPack({
    required this.id,
    required this.credits,
    required this.price,
    this.badge,
  });
  double get perCredit => price / credits;
}

class Plan {
  final String id;
  final String name;
  final String price;
  final int credits;
  final String banks;
  final String? badge;
  final List<String> features;
  const Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.credits,
    required this.banks,
    this.badge,
    this.features = const [],
  });
}

class CommissionRow {
  final DateTime date;
  final String client;
  final String bank;
  final int disbursed;
  final double rate;
  final int gross;
  final int tds;
  int get net => gross - tds;
  const CommissionRow({
    required this.date,
    required this.client,
    required this.bank,
    required this.disbursed,
    required this.rate,
    required this.gross,
    required this.tds,
  });
}

class Agent {
  final String id;
  final String name;
  final String dsaCode;
  final String city;
  final String status; // active | dormant | not_connected
  final PortalStatus portal;
  final int activeLoans;
  final int thisMonth;
  final double approvalRate;
  final DateTime? connectedAt;
  const Agent({
    required this.id,
    required this.name,
    required this.dsaCode,
    required this.city,
    required this.status,
    this.portal = PortalStatus.connected,
    this.activeLoans = 0,
    this.thisMonth = 0,
    this.approvalRate = 0,
    this.connectedAt,
  });
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class Rate {
  final String id;
  final String loanType;
  final double ratePct;
  final String rateType; // Flat | Reducing Balance
  final String? label;
  final DateTime effectiveFrom;
  final DateTime? validUntil;
  final int offersSent;
  final bool stale;
  const Rate({
    required this.id,
    required this.loanType,
    required this.ratePct,
    this.rateType = 'Reducing Balance',
    this.label,
    required this.effectiveFrom,
    this.validUntil,
    this.offersSent = 0,
    this.stale = false,
  });
}

class FaqItem {
  final String question;
  final String answer;
  final String category;
  const FaqItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}

class Session {
  final String id;
  final String device;
  final String os;
  final String city;
  final DateTime lastActive;
  final bool current;
  final bool suspicious;
  const Session({
    required this.id,
    required this.device,
    required this.os,
    required this.city,
    required this.lastActive,
    this.current = false,
    this.suspicious = false,
  });
}

class KpiCard {
  final String label;
  final String value;
  final String? delta;
  final bool deltaUp;
  const KpiCard({
    required this.label,
    required this.value,
    this.delta,
    this.deltaUp = true,
  });
}
