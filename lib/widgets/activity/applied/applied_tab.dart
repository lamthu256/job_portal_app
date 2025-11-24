import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/widgets/activity/applied/applied_job_card.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';

class AppliedTab extends StatefulWidget {
  final List<Application> appliedJobs;
  final VoidCallback onRefresh;

  const AppliedTab({
    super.key,
    required this.appliedJobs,
    required this.onRefresh,
  });

  @override
  State<AppliedTab> createState() => _AppliedTabState();
}

class _AppliedTabState extends State<AppliedTab> {
  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMMM d, y');

    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh();
        await Future.delayed(Duration(seconds: 1));
      },
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: widget.appliedJobs.map((job) {
          return AppliedJobCard(
            logo: job.logoUrl != ""
                ? NetworkImage(job.logoUrl!)
                : AssetImage("assets/default_avatar.png"),
            title: job.title,
            company: job.companyName!,
            location: parseLocation(job.workLocation!)['province']!,
            jobType: job.jobType!,
            salary: job.salary!,
            progressSteps: [
              ProgressStep(
                title: 'Applied',
                date: formatter.format(DateTime.parse(job.appliedAt!)),
                completed: true,
              ),
              if (job.viewedAt != '')
                ProgressStep(
                  title: 'Viewed by recruiter',
                  date: formatter.format(DateTime.parse(job.viewedAt!)),
                  completed: true,
                ),
              if (job.interviewingAt != '')
                ProgressStep(
                  title: 'Interviewing',
                  date: formatter.format(DateTime.parse(job.interviewingAt!)),
                  completed: true,
                ),
              if (job.acceptedAt != '')
                ProgressStep(
                  title: 'Accepted',
                  date: formatter.format(DateTime.parse(job.acceptedAt!)),
                  completed: true,
                ),
              if (job.rejectedAt != '')
                ProgressStep(
                  title: 'Rejected',
                  date: formatter.format(DateTime.parse(job.rejectedAt!)),
                  completed: false,
                ),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobDetailScreen(
                    jobId: job.id,
                    recruiterId: job.recruiterId!,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
