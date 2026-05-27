import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

/// Flat card: elevation 0, 0.5px borderLight, radius md (FRS Rule 4).
/// Optional [leftBorderColor] renders the 4px urgency/active accent stripe.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.color,
    this.leftBorderColor,
    this.borderColor,
    this.borderWidth = 0.5,
    this.margin,
    this.radius = AppRadius.md,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? leftBorderColor;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? margin;
  final double radius;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? AppColors.borderLight,
          width: borderWidth,
        ),
      ),
      child: child,
    );

    if (leftBorderColor != null) {
      content = Container(
        decoration: BoxDecoration(
          color: leftBorderColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? AppColors.borderLight,
            width: borderWidth,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
              bottomRight: Radius.circular(radius),
            ),
            child: Container(
              padding: padding,
              color: color ?? AppColors.bgSecondary,
              child: child,
            ),
          ),
        ),
      );
    }

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: content,
    );
  }
}
