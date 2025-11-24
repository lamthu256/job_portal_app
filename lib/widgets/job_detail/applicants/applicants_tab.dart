import 'package:flutter/material.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/screens/recruiter/application_detail_screen.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/applications/applicant_card.dart';

class ApplicantsTab extends StatefulWidget {
  final int jobId;
  final VoidCallback? onDataUpdated;

  const ApplicantsTab({super.key, required this.jobId, this.onDataUpdated});

  @override
  State<ApplicantsTab> createState() => _ApplicantsTabState();
}

class _ApplicantsTabState extends State<ApplicantsTab> {
  List<Application> applicationList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobApplication();
  }

  void fetchJobApplication() async {
    final result = await ApplicationService().getJobApplications(widget.jobId);

    if (result['success']) {
      setState(() {
        applicationList = (result['application_list'] as List)
            .map((app) => Application.fromJson(app))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          if (applicationList.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "No application found?",
                  style: textTheme.bodyLarge!.copyWith(color: AppColors.hint),
                ),
              ),
            )
          else
            ...applicationList.map((app) {
              return ApplicationCard(
                title: app.title,
                candidateName: app.fullName!,
                appliedAt: app.appliedAt!,
                status: (app.status! == "Applied" || app.status! == "Viewed")
                    ? "Pending"
                    : app.status!,
                isBackground: true,
                onTap: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ApplicationDetailScreen(applicationId: app.id),
                    ),
                  );
                  if (updated) {
                    widget.onDataUpdated!();
                  }
                },
              );
            }),
        ],
      ),
    );
  }
}
