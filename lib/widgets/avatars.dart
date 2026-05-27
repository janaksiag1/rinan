import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';

/// Palette for solid initial avatars (saturated, light text on top).
const _avatarPalette = <Color>[
  Color(0xFF7C5CFC), // purple
  Color(0xFF0D9488), // teal
  Color(0xFFE08C2B), // amber
  Color(0xFF3B82F6), // blue
  Color(0xFFEC4899), // pink
  Color(0xFF10B981), // green
];

Color _colorFor(String seed) {
  if (seed.isEmpty) return _avatarPalette.first;
  final code = seed.codeUnits.fold<int>(0, (a, b) => a + b);
  return _avatarPalette[code % _avatarPalette.length];
}

/// Circular avatar showing client/agent initials on a solid color.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar(
    this.initials, {
    super.key,
    this.size = 40,
    this.bg,
    this.fg,
  });
  final String initials;
  final double size;
  final Color? bg;
  final Color? fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg ?? _colorFor(initials),
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: AppText.headingSM.copyWith(
          color: fg ?? AppColors.textPrimary,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Bank avatar — first letter on a solid navy circle.
class BankInitialAvatar extends StatelessWidget {
  const BankInitialAvatar(this.initial, {super.key, this.size = 40});
  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.navyLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.tealPrimary.withValues(alpha: 0.4)),
      ),
      child: Text(
        initial,
        style: AppText.headingSM.copyWith(
          color: AppColors.textPrimary,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
