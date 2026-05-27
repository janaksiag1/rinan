import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_text.dart';

/// Navy AppBar with dark title/icons (FRS Rule 5). [trailingText] renders a
/// small "Step X of Y" style label on the right.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppAppBar(
    this.title, {
    super.key,
    this.actions,
    this.leading,
    this.showBack = true,
    this.trailingText,
    this.bottom,
    this.titleWidget,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final String? trailingText;
  final PreferredSizeWidget? bottom;
  final Widget? titleWidget;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      flexibleSpace: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientTop, AppColors.gradientBottom],
          ),
        ),
      ),
      automaticallyImplyLeading: showBack && leading == null,
      leading: leading,
      title: titleWidget ?? Text(title, style: AppText.headingLG),
      actions: [
        if (trailingText != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(trailingText!, style: AppText.bodySM),
            ),
          ),
        ...?actions,
      ],
      bottom: bottom,
    );
  }
}
