import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

/// Module 13 — Document Management viewer (FRS 84 & 85).
///
/// Full-screen image + PDF viewer. This is the one documented place a dark
/// scaffold is used. Status banners on the dark background still use
/// [AppColors.textPrimary] for their text per FRS Rule 1 (the banners
/// themselves are colored success/error).
class DocumentViewerScreen extends StatefulWidget {
  const DocumentViewerScreen({super.key, required this.id});

  final String id;

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

enum _ViewerMode { image, pdf }

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  _ViewerMode _mode = _ViewerMode.image;

  // Image-mode rotation (radians via quarter turns).
  int _quarterTurns = 0;

  // PDF-mode page state (1..3).
  int _page = 1;
  static const int _pageCount = 3;

  // Banner state — defaults to accepted; toggled via the AppBar overflow.
  bool _rejected = false;

  // A light-ish title color for the dark media viewer (documented exception).
  static const Color _lightTitle = AppColors.bgSecondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        foregroundColor: _lightTitle,
        iconTheme: const IconThemeData(color: _lightTitle),
        title: Text(
          'Document',
          style: AppText.headingMD.copyWith(color: _lightTitle),
        ),
        actions: [
          IconButton(
            tooltip: 'Download',
            icon: const Icon(Icons.download_outlined),
            onPressed: () => showAppSnack(context, 'Download started'),
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => showAppSnack(context, 'Share sheet opened'),
          ),
          PopupMenuButton<String>(
            tooltip: 'More',
            icon: const Icon(Icons.more_vert, color: _lightTitle),
            onSelected: (v) {
              setState(() {
                if (v == 'image') {
                  _mode = _ViewerMode.image;
                } else if (v == 'pdf') {
                  _mode = _ViewerMode.pdf;
                } else if (v == 'toggle') {
                  _rejected = !_rejected;
                }
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'image', child: Text('View as image')),
              PopupMenuItem(value: 'pdf', child: Text('View as PDF')),
              PopupMenuItem(
                value: 'toggle',
                child: Text('Toggle status banner'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _mode == _ViewerMode.image
          ? FloatingActionButton(
              backgroundColor: AppColors.tealPrimary,
              foregroundColor: AppColors.textPrimary,
              onPressed: () => setState(() => _quarterTurns += 1),
              child: const Icon(Icons.rotate_90_degrees_cw),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            _StatusBanner(rejected: _rejected),
            _ModeToggle(
              mode: _mode,
              onChanged: (m) => setState(() => _mode = m),
            ),
            Expanded(
              child: _mode == _ViewerMode.image
                  ? _ImageView(quarterTurns: _quarterTurns)
                  : _PdfView(
                      page: _page,
                      pageCount: _pageCount,
                      onPrev: _page > 1
                          ? () => setState(() => _page -= 1)
                          : null,
                      onNext: _page < _pageCount
                          ? () => setState(() => _page += 1)
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Top status banner — success (accepted) or error (rejected). Text uses
/// [AppColors.textPrimary] even on the colored band (FRS Rule 1).
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.rejected});

  final bool rejected;

  @override
  Widget build(BuildContext context) {
    final color =
        rejected ? AppColors.errorPrimary : AppColors.successPrimary;
    final icon = rejected ? Icons.cancel : Icons.verified;
    final label = rejected ? 'Rejected: Blurry/unclear' : 'Accepted ✓';

    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: AppText.buttonMD.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

/// Image / PDF mode switcher.
class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final _ViewerMode mode;
  final ValueChanged<_ViewerMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SegmentedButton<_ViewerMode>(
        showSelectedIcon: false,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.textPrimary
                : AppColors.bgSecondary,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.bgSecondary
                : Colors.black,
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: AppColors.borderMid),
          ),
        ),
        segments: const [
          ButtonSegment(
            value: _ViewerMode.image,
            label: Text('Image'),
            icon: Icon(Icons.image_outlined),
          ),
          ButtonSegment(
            value: _ViewerMode.pdf,
            label: Text('PDF'),
            icon: Icon(Icons.picture_as_pdf_outlined),
          ),
        ],
        selected: {mode},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

/// Image mode — zoom + rotate over a placeholder document image.
class _ImageView extends StatelessWidget {
  const _ImageView({required this.quarterTurns});

  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Transform.rotate(
            angle: quarterTurns * (3.1415926535 / 2),
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgTertiary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.description,
                        size: 96,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('PAN Card.jpg', style: AppText.headingSM),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Sample document preview',
                        style: AppText.bodySM,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// PDF mode — placeholder page + prev/next pager.
class _PdfView extends StatelessWidget {
  const _PdfView({
    required this.page,
    required this.pageCount,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int pageCount;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      8,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Container(
                          height: 10,
                          width: i.isEven ? double.infinity : 180,
                          decoration: BoxDecoration(
                            color: AppColors.borderLight,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: AppColors.bgSecondary,
                disabledColor: AppColors.textTertiary,
                onPressed: onPrev,
              ),
              const SizedBox(width: AppSpacing.md),
              MonoText(
                '$page / $pageCount',
                color: AppColors.bgSecondary,
              ),
              const SizedBox(width: AppSpacing.md),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: AppColors.bgSecondary,
                disabledColor: AppColors.textTertiary,
                onPressed: onNext,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
