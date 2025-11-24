import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/job_detail/company/company_info.dart';
import 'package:job_portal_app/widgets/job_detail/company/company_item.dart';
import 'package:job_portal_app/widgets/search/job_search_card.dart';

class CompanyTab extends StatelessWidget {
  final Recruiter recruiter;
  final List<Job> jobList;
  final VoidCallback onDetailUpdated;

  const CompanyTab({
    super.key,
    required this.recruiter,
    required this.jobList,
    required this.onDetailUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recruiter.size != "" ||
              recruiter.industry != "" ||
              recruiter.phone != "" ||
              recruiter.website != "") ...[
            CompanyItem(
              label: recruiter.companyName,
              content: Column(
                children: [
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
                    text: (recruiter.phone != "") ? "${recruiter.phone}" : '',
                  ),
                  CompanyInfo(
                    icon: Icons.link_outlined,
                    label: "Website:",
                    text: (recruiter.website != "")
                        ? "${recruiter.website}"
                        : '',
                  ),
                ],
              ),
            ),
          ],
          // Company Introduction
          if (recruiter.description != "") ...[
            CompanyItem(
              label: "Company Introduction",
              content: Text(
                (recruiter.description != "") ? "${recruiter.description}" : '',
                style: textTheme.bodyMedium,
              ),
            ),
          ],

          // Recruitment
          CompanyItem(
            label: "Recruitment",
            content: Column(
              children: jobList.map((job) {
                return JobSearchCard(
                  background: AppColors.background,
                  logo: recruiter.logoUrl != ""
                      ? NetworkImage(recruiter.logoUrl!)
                      : AssetImage("assets/default_avatar.png"),
                  title: job.title,
                  company: recruiter.companyName,
                  location: parseLocation(job.workLocation!)['province']!,
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
                      onDetailUpdated();
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
