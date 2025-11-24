import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/job_detail/applicants/applicants_tab.dart';
import 'package:job_portal_app/widgets/job_detail/description/description_tab.dart';
import 'package:job_portal_app/widgets/job_detail/review/review_tab.dart';

class PostedJobDetailScreen extends StatefulWidget {
  final int jobId;

  const PostedJobDetailScreen({super.key, required this.jobId});

  @override
  State<PostedJobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<PostedJobDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Job? job;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchDetailJob();
  }

  void fetchDetailJob() async {
    final userId = UserSession.userId;

    if (userId != null) {
      final resultJob = await JobService().getDetailJob(userId, widget.jobId);
      if (resultJob['success']) {
        setState(() {
          job = Job.fromJson(resultJob['info']);
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final DateFormat formatter = DateFormat('MMMM d, y');

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
                ),
                SizedBox(width: 8),
                Text("Job Details", style: textTheme.headlineMedium),
                Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.pushNamed(context, '/edit_profile');
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Icon(
                //         Icons.mode_edit_outline,
                //         color: AppColors.primary,
                //         size: 18,
                //       ),
                //       SizedBox(width: 2),
                //       Text(
                //         "Edit",
                //         style: textTheme.headlineSmall!.copyWith(
                //           color: AppColors.primary,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image(
                      image: job!.logoUrl != ''
                          ? NetworkImage(job!.logoUrl!)
                          : AssetImage("assets/default_avatar.png"),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job!.title,
                          style: textTheme.headlineSmall,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        Text(
                          formatter.format(DateTime.parse(job!.createdAt)),
                          style: textTheme.bodySmall!.copyWith(
                            color: AppColors.hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color: job!.jobStatus == 'Open'
                          ? AppColors.success.withOpacity(0.3)
                          : AppColors.error.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 6,
                          color: job!.jobStatus == 'Open'
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        SizedBox(width: 4),
                        Text(
                          job!.jobStatus,
                          style: textTheme.bodyLarge!.copyWith(
                            color: job!.jobStatus == 'Open'
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.background,
                ),
                child: Column(
                  children: [
                    DetailItem(
                      icon: Icons.monetization_on_outlined,
                      label: 'Salary',
                      text: job!.salary!,
                      isPrimary: true,
                    ),
                    DetailItem(
                      icon: Icons.work_outline,
                      label: 'Job type',
                      text: job!.jobType,
                    ),
                    DetailItem(
                      icon: Icons.business,
                      label: 'Workplace type',
                      text: job!.workplaceType,
                    ),
                    DetailItem(
                      icon: Icons.calendar_month_outlined,
                      label: 'Experience',
                      text: job!.experience!,
                    ),
                    DetailItem(
                      icon: Icons.badge_outlined,
                      label: 'Positions',
                      text:
                          '${job!.vacancyCount} ${job!.vacancyCount == 1 ? "person" : "persons"}',
                    ),
                    DetailItem(
                      icon: Icons.groups_outlined,
                      label: 'Candidate',
                      text: job!.totalApplicants!.toString(),
                    ),
                    DetailItem(
                      icon: Icons.assignment_ind_outlined,
                      label: 'Interviewed',
                      text: job!.interviewingCount!.toString(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Tab bar
              Container(
                height: 42,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  labelColor: AppColors.primary,
                  labelStyle: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: AppColors.textPrimary,
                  unselectedLabelStyle: textTheme.bodyMedium,
                  dividerColor: AppColors.background,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isScrollable: false,
                  labelPadding: EdgeInsets.zero,
                  //không dãn đều
                  tabs: [
                    Tab(
                      child: SizedBox.expand(
                        child: Center(child: Text('Description')),
                      ),
                    ),
                    Tab(
                      child: SizedBox.expand(
                        child: Center(child: Text('Review')),
                      ),
                    ),
                    Tab(
                      child: SizedBox.expand(
                        child: Center(child: Text('Applicants')),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // TabBarView
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    DescriptionTab(job: job!),
                    ReviewTab(jobId: job!.id),
                    ApplicantsTab(
                      jobId: job!.id,
                      onDataUpdated: fetchDetailJob,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final bool? isPrimary;

  const DetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.text,
    this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.hint, size: 20),
          SizedBox(width: 6),
          Text(label, style: textTheme.labelSmall),
          Spacer(),
          Text(
            text,
            style: textTheme.titleMedium!.copyWith(
              color: (isPrimary == true)
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
