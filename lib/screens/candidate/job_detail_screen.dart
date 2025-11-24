import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/config/global_event.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/candidate/apply_form_screen.dart';
import 'package:job_portal_app/screens/candidate/company_screen.dart';
import 'package:job_portal_app/screens/recruiter/posted_job_detail_screen.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/job_detail/company/company_tab.dart';
import 'package:job_portal_app/widgets/job_detail/description/description_tab.dart';
import 'package:job_portal_app/widgets/job_detail/review/review_tab.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobId;
  final int recruiterId;

  const JobDetailScreen({
    super.key,
    required this.jobId,
    required this.recruiterId,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Job? job;
  Recruiter? recruiter;
  List<Job> jobList = [];
  bool? isSaved;
  bool isApplied = false;

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

      final resJobList = await JobService().getRecruiterJobs(
        userId,
        widget.recruiterId,
      );

      if (resultJob['success']) {
        setState(() {
          job = Job.fromJson(resultJob['info']);
          isSaved = job!.isSaved;
          recruiter = Recruiter.fromJson(resultJob['info']);
          jobList = (resJobList['job_list'] as List)
              .map((jobJson) => Job.fromJson(jobJson))
              .toList();
        });
      }
      final resultApp = await ApplicationService().checkApplication(
        widget.jobId,
        userId,
      );
      if (resultApp['success']) {
        setState(() {
          isApplied = true;
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
    if (job == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final textTheme = Theme.of(context).textTheme;
    final DateFormat formatter = DateFormat('MMMM d, y');

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CompanyScreen(recruiterId: widget.recruiterId),
                        ),
                      );
                    },
                    child: ClipOval(
                      child: Image(
                        image: recruiter!.logoUrl != ""
                            ? NetworkImage(recruiter!.logoUrl!)
                            : AssetImage("assets/default_avatar.png"),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
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
                        Row(
                          children: [
                            Text(
                              parseLocation(job!.workLocation!)['province']!,
                              style: textTheme.bodySmall!.copyWith(
                                color: AppColors.hint,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: AppColors.hint,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              formatter.format(DateTime.parse(job!.createdAt)),
                              style: textTheme.bodySmall!.copyWith(
                                color: AppColors.hint,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        if (UserSession.userId != null) {
                          final result = await JobService().toggleSaveJob(
                            UserSession.userId!,
                            job!.id,
                          );
                          if (result['success']) {
                            eventBus.fire(JobUpdatedEvent(widget.jobId));
                            setState(() {
                              isSaved = !isSaved!;
                            });
                          }
                        }
                      },
                      icon: Icon(
                        (isSaved ?? false)
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        size: 26,
                        color: (isSaved ?? false) ? Colors.amber : null,
                      ),
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
                      text: job!.vacancyCount
                          .toString(), // '${job!.vacancyCount} ${job!.vacancyCount == 1 ? "person" : "persons"}',
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
                  indicator: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isScrollable: false,
                  labelPadding: EdgeInsets.zero,
                  controller: _tabController,
                  //không dãn đều
                  tabs: [
                    Tab(
                      child: SizedBox.expand(
                        child: Center(child: Text('Description')),
                      ),
                    ),
                    Tab(
                      child: SizedBox.expand(
                        child: Center(child: Text('Company')),
                      ),
                    ),
                    Tab(
                      child: SizedBox.expand(
                        child: Center(child: Text('Review')),
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
                    CompanyTab(
                      recruiter: recruiter!,
                      jobList: jobList,
                      onDetailUpdated: fetchDetailJob,
                    ),
                    ReviewTab(jobId: job!.id),
                  ],
                ),
              ),

              if (!isApplied)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final applied = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApplyFormScreen(jobId: widget.jobId),
                        ),
                      );

                      if (applied) {
                        setState(() {
                          isApplied = !isApplied;
                        });
                      }
                    },
                    child: Text("Apply Now"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
