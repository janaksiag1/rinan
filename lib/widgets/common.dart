import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';
import 'buttons.dart';

/// Money / ID text rendered in DM Mono (FRS Rules 2 & 3).
class MonoText extends StatelessWidget {
  const MonoText(this.text, {super.key, this.style, this.color});
  final String text;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: (style ?? AppText.mono).copyWith(color: color),
  );
}

/// Section header with optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing, this.padding});
  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.headingMD)),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Small count badge (notification bell, tab counts).
class CountBadge extends StatelessWidget {
  const CountBadge(this.count, {super.key, this.color = AppColors.errorPrimary});
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      constraints: const BoxConstraints(minWidth: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppText.bodySM.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

/// Generic pill chip (loan type, lead source, count chips).
class AppChip extends StatelessWidget {
  const AppChip(
    this.label, {
    super.key,
    this.bg,
    this.fg,
    this.icon,
    this.dense = false,
  });
  final String label;
  final Color? bg;
  final Color? fg;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg ?? AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg ?? AppColors.textTertiary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppText.bodySM.copyWith(
              color: fg ?? AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Selectable filter chip used in horizontal filter bars.
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
    this.selectedColor = AppColors.tealPrimary,
    this.icon,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;
  final Color selectedColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final text = count != null ? '$label ($count)' : label;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withValues(alpha: 0.12)
              : AppColors.bgTertiary,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? selectedColor : AppColors.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: selected ? selectedColor : AppColors.textTertiary),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: AppText.bodyMD.copyWith(
                color: selected ? selectedColor : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Colored informational/warning banner box.
class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
    required this.text,
    this.bg = AppColors.infoLight,
    this.fg = AppColors.infoPrimary,
    this.icon,
  });
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(text, style: AppText.bodyMD.copyWith(color: fg)),
          ),
        ],
      ),
    );
  }
}

/// Labelled field row (label above value) for detail cards.
class DetailRow extends StatelessWidget {
  const DetailRow(this.label, this.value, {super.key, this.valueStyle});
  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.bodySM),
          const SizedBox(height: 2),
          Text(value, style: valueStyle ?? AppText.bodyLG.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

/// "Not yet built / mock" placeholder used where the FRS describes a screen
/// stub or a feature with no static representation (kept minimal & on-brand).
class MockNote extends StatelessWidget {
  const MockNote(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.widgets_outlined, size: 48, color: AppColors.borderMid),
            const SizedBox(height: AppSpacing.md),
            Text(label, textAlign: TextAlign.center, style: AppText.bodyMD),
          ],
        ),
      ),
    );
  }
}

/// Sticky bottom action bar (used by multi-step flows & sheets).
class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

/// Helper that shows a simple snack message.
void showAppSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: AppText.bodyMD.copyWith(color: AppColors.textPrimary)),
        backgroundColor: AppColors.bgSecondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
}

/// Simple confirm dialog with a danger or teal confirm button.
Future<bool> showConfirmSheet(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool destructive = false,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppColors.bgSecondary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderMid,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(title, style: AppText.headingMD),
          const SizedBox(height: AppSpacing.sm),
          Text(message, style: AppText.bodyMD),
          const SizedBox(height: AppSpacing.xxl),
          destructive
              ? DangerButton(confirmLabel, onPressed: () => Navigator.pop(ctx, true))
              : TealButton(confirmLabel, onPressed: () => Navigator.pop(ctx, true)),
          const SizedBox(height: AppSpacing.sm),
          Center(child: TextActionButton('Cancel', onPressed: () => Navigator.pop(ctx, false))),
        ],
      ),
    ),
  );
  return result ?? false;
}
