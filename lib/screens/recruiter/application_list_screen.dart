import 'package:flutter/material.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/screens/recruiter/application_detail_screen.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/applications/applicant_card.dart';

class ApplicationListScreen extends StatefulWidget {
  final int totalApplied;
  final List<Application> applicationList;
  final VoidCallback onDataUpdated;

  const ApplicationListScreen({
    super.key,
    required this.totalApplied,
    required this.applicationList,
    required this.onDataUpdated,
  });

  @override
  State<ApplicationListScreen> createState() => _ApplicationListScreenState();
}

class _ApplicationListScreenState extends State<ApplicationListScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        // Fixed Header
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 4, 24, 18),
              child: Text(
                "Application List (${widget.totalApplied})",
                style: textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        // Scrollable List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              widget.onDataUpdated();
              await Future.delayed(Duration(seconds: 1));
            },
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                if (widget.applicationList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        "No application found?",
                        style: textTheme.bodyLarge!.copyWith(
                          color: AppColors.hint,
                        ),
                      ),
                    ),
                  )
                else
                  ...widget.applicationList.map((app) {
                    return ApplicationCard(
                      title: app.title,
                      candidateName: app.fullName!,
                      appliedAt: app.appliedAt!,
                      status:
                          (app.status! == "Applied" || app.status! == "Viewed")
                          ? "Pending"
                          : app.status!,
                      isBackground:
                          (app.status! != "Applied" && app.status! != "Viewed")
                          ? true
                          : false,
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ApplicationDetailScreen(applicationId: app.id),
                          ),
                        );
                        if (updated) {
                          widget.onDataUpdated();
                        }
                      },
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
