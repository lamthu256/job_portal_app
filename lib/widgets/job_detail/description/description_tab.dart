import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/widgets/job_detail/company/company_item.dart';
import 'package:job_portal_app/widgets/job_detail/description/description_item.dart';

class DescriptionTab extends StatelessWidget {
  final Job job;

  const DescriptionTab({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final DateTime date = DateTime.parse(job.deadline!);
    final DateFormat formatter = DateFormat('MMMM d, y');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About
          DescriptionItem(
            label: "Job Description",
            content: job.jobDescription!,
          ),

          // Candidate Requirements
          DescriptionItem(
            label: "Candidate Requirements",
            content: job.requirements!,
          ),

          // Interest
          CompanyItem(
            label: "Interest",
            content: Text(job.interest!, style: textTheme.bodyMedium),
          ),

          CompanyItem(
            label: "Work Location",
            content: Text(job.workLocation!, style: textTheme.bodyMedium),
          ),

          if (job.workingTime != null)
            CompanyItem(
              label: "Working Time",
              content: Text(job.workingTime!, style: textTheme.bodyMedium),
            ),

          CompanyItem(
            label: "How To Apply",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Candidates apply online by clicking ",
                    style: textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: "Apply Now",
                        style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " below."),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text("Application deadline: ${formatter.format(date)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
