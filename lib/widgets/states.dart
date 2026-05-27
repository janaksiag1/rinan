import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text.dart';
import 'buttons.dart';

/// Empty state with icon, title, subtitle and optional CTA (FRS Rule 10c).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.bgTertiary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.textTertiary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppText.headingMD, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: AppText.bodyMD, textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state (FRS Rule 10b).
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
  });
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.errorPrimary),
            const SizedBox(height: AppSpacing.lg),
            Text(message, style: AppText.bodyLG, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              TealButton('Retry', onPressed: onRetry, fullWidth: false),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer skeleton card (FRS Rule 10a). Animated grey blocks.
class ShimmerCard extends StatefulWidget {
  const ShimmerCard({super.key, this.height = 88, this.lines = 2});
  final double height;
  final int lines;

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final v = _c.value;
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.borderLight, width: 0.5),
          ),
          child: Row(
            children: [
              _block(40, 40, v, circle: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.lines,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _block(
                        double.infinity,
                        12,
                        v,
                        widthFactor: i.isEven ? 0.7 : 0.45,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _block(
    double w,
    double h,
    double v, {
    bool circle = false,
    double widthFactor = 1,
  }) {
    final color = Color.lerp(
      AppColors.bgTertiary,
      AppColors.borderLight,
      (0.5 + 0.5 * (v * 2 - 1).abs()),
    )!;
    final box = Container(
      width: w == double.infinity ? null : w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(4),
      ),
    );
    if (w == double.infinity) {
      return FractionallySizedBox(widthFactor: widthFactor, child: box);
    }
    return box;
  }
}

/// Convenience list of shimmer cards for list loading states.
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.count = 6});
  final int count;
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
    children: List.generate(count, (_) => const ShimmerCard()),
  );
}
