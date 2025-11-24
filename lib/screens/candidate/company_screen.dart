import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/recruiter_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/job_detail/company/company_info.dart';
import 'package:job_portal_app/widgets/search/job_search_card.dart';

class CompanyScreen extends StatefulWidget {
  final int recruiterId;

  const CompanyScreen({super.key, required this.recruiterId});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  late Recruiter recruiter;
  List<Job> jobList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCompanyProfile();
  }

  void fetchCompanyProfile() async {
    final result = await RecruiterService().getRecruiter(widget.recruiterId);
    final resJobList = await JobService().getRecruiterJobs(
      UserSession.userId!,
      widget.recruiterId,
    );

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
                Text("Company Detail", style: textTheme.headlineMedium),
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
                    padding: EdgeInsets.fromLTRB(24, 6, 24, 24),
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
                        SizedBox(height: 16),
                        Text(
                          recruiter.companyName,
                          style: textTheme.headlineLarge,
                          textAlign: TextAlign.center,
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
                      // Introduce
                      if (recruiter.size != "" ||
                          recruiter.industry != "" ||
                          recruiter.phone != "" ||
                          recruiter.website != "") ...[
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
                            return JobSearchCard(
                              background: AppColors.background,
                              logo: recruiter.logoUrl != ""
                                  ? NetworkImage(recruiter.logoUrl!)
                                  : AssetImage("assets/default_avatar.png"),
                              title: job.title,
                              company: recruiter.companyName,
                              location: parseLocation(
                                job.workLocation!,
                              )['province']!,
                              jobType: job.jobType,
                              salary: job.salary!,
                              isSaved: job.isSaved,
                              onTap: () async {
                                final updated = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JobDetailScreen(
                                      jobId: job.id,
                                      recruiterId: job.recruiterId,
                                    ),
                                  ),
                                );
                                if (updated) {
                                  fetchCompanyProfile();
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
