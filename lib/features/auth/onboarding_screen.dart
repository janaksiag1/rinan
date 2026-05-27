import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text.dart';
import '../../widgets/widgets.dart';

/// Module 1 — Onboarding. 3-slide PageView intro.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _slides = <_Slide>[
    _Slide(
      icon: Icons.bolt_outlined,
      headline: 'Send loan offers in seconds',
      subtitle:
          'Connect with banks, build your client pipeline, and send WhatsApp '
          'offers with one tap.',
    ),
    _Slide(
      icon: Icons.assignment_turned_in_outlined,
      headline: 'Manage applications like a pro',
      subtitle:
          'Track every loan from application to disbursement. Get real-time '
          'bank updates.',
    ),
    _Slide(
      icon: Icons.groups_outlined,
      headline: 'Grow your DSA network',
      subtitle:
          'Agents, reviewers, and managers on one platform. More efficiency, '
          'more commissions.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: _slides.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, i) {
            final slide = _slides[i];
            final isLast = i == _slides.length - 1;
            return Column(
              children: [
                const Spacer(),
                Container(
                  width: 240,
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.bgTertiary,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    slide.icon,
                    size: 96,
                    color: AppColors.tealPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxxl),
                Text(
                  slide.headline,
                  textAlign: TextAlign.center,
                  style: AppText.headingXL
                      .copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    slide.subtitle,
                    textAlign: TextAlign.center,
                    style: AppText.bodyLG
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const Spacer(),
                _Dots(active: _page, count: _slides.length),
                const SizedBox(height: AppSpacing.xxl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  child: TealButton(
                    isLast ? 'Get Started →' : 'Next →',
                    onPressed: () {
                      if (isLast) {
                        context.go('/auth/login');
                      } else {
                        _next();
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 36,
                  child: isLast
                      ? null
                      : TextActionButton(
                          'Skip',
                          onPressed: () => context.go('/auth/login'),
                        ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({
    required this.icon,
    required this.headline,
    required this.subtitle,
  });
  final IconData icon;
  final String headline;
  final String subtitle;
}

class _Dots extends StatelessWidget {
  const _Dots({required this.active, required this.count});
  final int active;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.tealPrimary : AppColors.borderMid,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
        );
      }),
    );
  }
}
