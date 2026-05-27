import 'package:intl/intl.dart';

/// Formatting helpers. Money uses the Indian grouping convention and is always
/// rendered in DM Mono at the widget layer (FRS Rule 2).
class Fmt {
  Fmt._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );
  static final NumberFormat _compact = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 1,
  );

  /// e.g. 4250000 -> "₹42,50,000"
  static String money(num value) => _inr.format(value);

  /// e.g. 4250000 -> "₹42.5L"
  static String moneyCompact(num value) => _compact.format(value);

  /// e.g. "26 May 2026"
  static String date(DateTime d) => DateFormat('d MMM yyyy').format(d);

  /// e.g. "26 May at 2:34 PM"
  static String dateTime(DateTime d) =>
      DateFormat("d MMM 'at' h:mm a").format(d);

  /// e.g. "2:34 PM"
  static String time(DateTime d) => DateFormat('h:mm a').format(d);

  /// Relative "time ago" used across activity feeds & timelines.
  static String ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return date(d);
  }

  /// Days-until label for occasions.
  static String daysUntilLabel(int days) {
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return '$days days';
  }
}
