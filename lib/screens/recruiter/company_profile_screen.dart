import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/recruiter/edit_company_screen.dart';
import 'package:job_portal_app/screens/recruiter/edit_job_screen.dart';
import 'package:job_portal_app/screens/recruiter/posted_job_detail_screen.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/recruiter_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/job_detail/company/company_info.dart';
import 'package:job_portal_app/widgets/jobs/posted_job_card.dart';

class CompanyProfileScreen extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const CompanyProfileScreen({super.key, this.onProfileUpdated});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  late Recruiter recruiter;
  List<Job> jobList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCompanyProfile();
  }

  Future<void> fetchCompanyProfile() async {
    final userId = UserSession.userId;

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await RecruiterService().getRecruiter(userId);
    final resJobList = await JobService().getJobList(userId, null);

    if (result['success']) {
      setState(() {
        recruiter = Recruiter.fromJson(result['data']);
        jobList = (resJobList['job_list'] as List)
            .map((job) => Job.fromJson(job))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
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
                Text("Company Profile", style: textTheme.headlineMedium),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCompanyScreen(recruiter: recruiter),
                      ),
                    );

                    if (updated) {
                      await fetchCompanyProfile();
                      widget.onProfileUpdated!();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mode_edit_outline,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "Edit",
                        style: textTheme.headlineSmall!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image(
                            image: recruiter.logoUrl != ""
                                ? NetworkImage(recruiter.logoUrl!)
                                : AssetImage('assets/default_avatar.png'),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          recruiter.companyName,
                          style: textTheme.headlineLarge,
                          maxLines: 1,
                          softWrap: false,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 13,
                              color: AppColors.hint,
                            ),
                            Text(
                              recruiter.location != ""
                                  ? recruiter.location
                                  : "Unknown",
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(38)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (recruiter.size != "" ||
                          recruiter.industry != "" ||
                          recruiter.phone != "" ||
                          recruiter.website != "") ...[
                        // Introduce
                        Text("About me", style: textTheme.headlineMedium),
                        SizedBox(height: 6),
                        // Scale
                        CompanyInfo(
                          icon: Icons.people_outline,
                          label: 'Scale:',
                          text: (recruiter.size != "")
                              ? "${recruiter.size} employees"
                              : '',
                        ),
                        CompanyInfo(
                          icon: Icons.category_outlined,
                          label: "Field:",
                          text: (recruiter.industry != "")
                              ? "${recruiter.industry}"
                              : '',
                        ),
                        CompanyInfo(
                          icon: Icons.phone_outlined,
                          label: "Phone:",
                          text: (recruiter.phone != "")
                              ? "${recruiter.phone}"
                              : '',
                        ),
                        CompanyInfo(
                          icon: Icons.link_outlined,
                          label: "Website:",
                          text: (recruiter.website != "")
                              ? "${recruiter.website}"
                              : '',
                        ),
                        SizedBox(height: 24),
                      ],

                      // Work Experience
                      if (recruiter.description != "") ...[
                        Text(
                          "Work experience",
                          style: textTheme.headlineMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          recruiter.description!,
                          style: textTheme.bodyMedium,
                        ),
                        SizedBox(height: 30),
                      ],

                      // Skills
                      if (jobList.isNotEmpty) ...[
                        Text("Job List", style: textTheme.headlineMedium),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: jobList.map((job) {
                            final result = parseLocation(job.workLocation!);

                            return PostedJobCard(
                              title: job.title,
                              createdAt: formatter.format(
                                DateTime.parse(job.createdAt),
                              ),
                              salary: job.salary!,
                              rating: 3.7,
                              location: result['province']!,
                              workplaceType: job.workplaceType,
                              jobType: job.jobType,
                              candidate: 15,
                              interview: 8,
                              isBackground: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PostedJobDetailScreen(jobId: job.id),
                                  ),
                                );
                              },
                              onEdit: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditJobScreen(
                                      jobData: {
                                        'job_id': job.id,
                                        'title': job.title,
                                        'salary': job.salary,
                                        'job_type': job.jobType,
                                        'workplace_type': job.workplaceType,
                                        'experience': job.experience,
                                        'vacancy_count': job.vacancyCount,
                                        'field_id': job.fieldId,
                                        'job_description': job.jobDescription,
                                        'requirements': job.requirements,
                                        'interest': job.interest,
                                        'province': result['province'],
                                        'address': result['address'],
                                        'working_time': job.workingTime,
                                        'deadline': job.deadline,
                                        'job_status': job.jobStatus,
                                      },
                                    ),
                                  ),
                                );

                                if (updated) {
                                  fetchCompanyProfile();
                                }
                              },
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.surface,
                                    title: Text("Confirm Delete"),
                                    content: Text(
                                      "Are you sure you want to delete this job?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          "Cancel",
                                          style: textTheme.bodyMedium,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                        ),
                                        child: Text("Delete"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final result = await JobService().deleteJob(
                                    job.id,
                                    UserSession.userId!,
                                  );

                                  if (result['success']) {
                                    fetchCompanyProfile();
                                  }
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
