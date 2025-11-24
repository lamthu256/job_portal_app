import 'package:flutter/material.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/activity/applied/applied_tab.dart';
import 'package:job_portal_app/widgets/activity/saved/saved_tab.dart';

class ActivityScreen extends StatefulWidget {
  final int totalSaved;
  final List<Job> savedJobs;
  final int totalApplied;
  final List<Application> appliedJobs;
  final VoidCallback onProfileUpdated;

  const ActivityScreen({
    super.key,
    required this.totalSaved,
    required this.savedJobs,
    required this.totalApplied,
    required this.appliedJobs,
    required this.onProfileUpdated,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Tab bar
          Container(
            height: 42,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              labelColor: AppColors.textPrimary,
              labelStyle: textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelColor: AppColors.textPrimary,
              unselectedLabelStyle: textTheme.bodyMedium,
              dividerColor: AppColors.surface,
              indicator: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              isScrollable: false,
              labelPadding: EdgeInsets.zero,
              controller: _tabController,
              tabs: [
                buildTab(text: 'Applied', count: widget.totalApplied, index: 0),
                buildTab(text: 'Saved', count: widget.totalSaved, index: 1),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                AppliedTab(
                  appliedJobs: widget.appliedJobs,
                  onRefresh: widget.onProfileUpdated,
                ),
                SavedTab(
                  savedJobs: widget.savedJobs,
                  onProfileUpdated: widget.onProfileUpdated,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Tab buildTab({required String text, required int count, required int index}) {
    return Tab(
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          final isSelected = _tabController.index == index;

          return SizedBox.expand(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text),
                const SizedBox(width: 4),
                Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1,
                      color: isSelected
                          ? AppColors.surface
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
