import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/theme/app_spacing.dart';
import '../../widgets/widgets.dart';

class BulkImportReviewScreen extends StatelessWidget {
  const BulkImportReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const AppAppBar('Review Import'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: AppCard(
                child: Row(
                  children: [
                    const AppChip(
                      '18 valid',
                      bg: AppColors.successLight,
                      fg: AppColors.successPrimary,
                      icon: Icons.check_circle_outline,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const AppChip(
                      '2 errors',
                      bg: AppColors.errorLight,
                      fg: AppColors.errorPrimary,
                      icon: Icons.error_outline,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const AppChip(
                      '1 duplicate',
                      bg: AppColors.amberLight,
                      fg: AppColors.amberPrimary,
                      icon: Icons.copy_outlined,
                    ),
                  ],
                ),
              ),
            ),
            const TabBar(
              labelColor: AppColors.tealPrimary,
              unselectedLabelColor: AppColors.textTertiary,
              indicatorColor: AppColors.tealPrimary,
              tabs: [
                Tab(text: 'Valid'),
                Tab(text: 'Errors'),
                Tab(text: 'Duplicates'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _DataTab(
                    columns: const ['Name', 'Mobile', 'City'],
                    rows: const [
                      ['Rohit Mehra', '98765·····', 'Mumbai'],
                      ['Kavya Nair', '98231·····', 'Pune'],
                      ['Arjun Das', '99112·····', 'Delhi'],
                      ['Sneha Roy', '98450·····', 'Hyderabad'],
                    ],
                  ),
                  _DataTab(
                    columns: const ['Row #', 'Field', 'Error'],
                    rows: const [
                      ['4', 'Mobile', 'Invalid number'],
                      ['11', 'City', 'Missing value'],
                    ],
                  ),
                  _DataTab(
                    columns: const ['Name', 'Existing'],
                    rows: const [
                      ['Rahul Sharma', 'Already in list'],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: StickyBottomBar(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '18 contacts will be imported',
                  style:
                      AppText.bodyMD.copyWith(color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              TealButton(
                'Import Now',
                fullWidth: false,
                onPressed: () {
                  showAppSnack(context, 'Imported 18 contacts ✓');
                  context.go('/clients');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DataTab extends StatelessWidget {
  const _DataTab({required this.columns, required this.rows});
  final List<String> columns;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: AppText.bodySM.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          dataTextStyle: AppText.bodyMD,
          columns: columns
              .map((c) => DataColumn(label: Text(c)))
              .toList(),
          rows: rows
              .map(
                (r) => DataRow(
                  cells: r.map((cell) => DataCell(Text(cell))).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
