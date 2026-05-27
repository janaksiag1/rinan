import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';

/// Shared button family. ALL labels are dark [textPrimary] (FRS Rule 1).
/// Default height 56 for the primary trio; [small] gives a 36px chip-button.

enum _Variant { navy, teal, danger, secondary, text }

class _BaseButton extends StatelessWidget {
  const _BaseButton({
    required this.label,
    required this.onPressed,
    required this.variant,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.small = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final _Variant variant;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final height = small ? 36.0 : 56.0;

    Color bg;
    Color? borderColor;
    switch (variant) {
      case _Variant.navy:
        bg = AppColors.navyPrimary;
        break;
      case _Variant.teal:
        bg = AppColors.tealPrimary;
        break;
      case _Variant.danger:
        bg = AppColors.errorPrimary;
        break;
      case _Variant.secondary:
        bg = AppColors.bgSecondary;
        borderColor = AppColors.borderMid;
        break;
      case _Variant.text:
        bg = Colors.transparent;
        break;
    }

    final labelColor = variant == _Variant.text
        ? AppColors.tealPrimary
        : AppColors.textPrimary;

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(labelColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 18 : 20, color: labelColor),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                label,
                style: (small ? AppText.buttonMD : AppText.buttonLG)
                    .copyWith(color: labelColor),
              ),
            ],
          );

    final button = Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: enabled ? onPressed : null,
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: small ? 14 : 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: borderColor != null
                  ? Border.all(color: borderColor, width: 1.5)
                  : null,
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );

    if (variant == _Variant.text) {
      return GestureDetector(
        onTap: enabled ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: child,
        ),
      );
    }

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.small = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool small;

  @override
  Widget build(BuildContext context) => _BaseButton(
    label: label,
    onPressed: onPressed,
    variant: _Variant.navy,
    icon: icon,
    isLoading: isLoading,
    fullWidth: fullWidth,
    small: small,
  );
}

class TealButton extends StatelessWidget {
  const TealButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.small = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool small;

  @override
  Widget build(BuildContext context) => _BaseButton(
    label: label,
    onPressed: onPressed,
    variant: _Variant.teal,
    icon: icon,
    isLoading: isLoading,
    fullWidth: fullWidth,
    small: small,
  );
}

class DangerButton extends StatelessWidget {
  const DangerButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.small = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final bool small;

  @override
  Widget build(BuildContext context) => _BaseButton(
    label: label,
    onPressed: onPressed,
    variant: _Variant.danger,
    icon: icon,
    isLoading: isLoading,
    fullWidth: fullWidth,
    small: small,
  );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.fullWidth = true,
    this.small = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool small;

  @override
  Widget build(BuildContext context) => _BaseButton(
    label: label,
    onPressed: onPressed,
    variant: _Variant.secondary,
    icon: icon,
    fullWidth: fullWidth,
    small: small,
  );
}

class TextActionButton extends StatelessWidget {
  const TextActionButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.color,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.tealPrimary;
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: c),
              const SizedBox(width: 4),
            ],
            Text(label, style: AppText.bodyMD.copyWith(color: c, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
