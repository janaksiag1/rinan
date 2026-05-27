import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Thin rounded progress bar (setup steps, document completion).
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.tealPrimary,
    this.height = 6,
    this.background,
  });
  final double value; // 0..1
  final Color color;
  final double height;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: height,
        backgroundColor: background ?? AppColors.bgTertiary,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}

/// Circular gauge used on the Billing credits widget.
class CircularGauge extends StatelessWidget {
  const CircularGauge({
    super.key,
    required this.value,
    required this.centerLabel,
    this.subLabel,
    this.size = 80,
    this.color = AppColors.tealPrimary,
  });
  final double value; // 0..1
  final String centerLabel;
  final String? subLabel;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0, 1),
              strokeWidth: 6,
              backgroundColor: AppColors.bgTertiary,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerLabel,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  fontSize: size * 0.22,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subLabel != null)
                Text(
                  subLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
