import 'package:flutter/material.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/search/job_search_card.dart';

class SavedTab extends StatelessWidget {
  final List<Job> savedJobs;
  final VoidCallback onProfileUpdated;

  const SavedTab({super.key, required this.savedJobs, required this.onProfileUpdated});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: savedJobs.map((job) {
          return JobSearchCard(
            logo: job.logoUrl != null
                ? NetworkImage(job.logoUrl!)
                : AssetImage("assets/default_avatar.png"),
            title: job.title,
            company: job.companyName!,
            location: parseLocation(job.workLocation!)['province']!,
            jobType: job.jobType,
            salary: job.salary!,
            isSaved: true,
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
                onProfileUpdated();
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
