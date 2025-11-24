import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/services/user_service.dart';
import 'package:job_portal_app/services/notification_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final int applicationId;

  const ApplicationDetailScreen({super.key, required this.applicationId});

  @override
  State<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  final DateFormat formatter = DateFormat('MMMM d, y');
  Application? application;
  List<ProgressStep> progressSteps = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchApplicationDetail();
  }

  void fetchApplicationDetail() async {
    final result = await ApplicationService().getApplication(
      widget.applicationId,
    );

    if (result['success']) {
      setState(() {
        application = Application.fromJson(result['application'][0]);
        if (application!.status == "Applied") {
          ApplicationService().updateStatusApplication(
            application!.id,
            "Viewed",
            application!.title,
            application!.companyName!,
          );
          fetchApplicationDetail();
        }
        progressSteps = [
          ProgressStep(
            title: 'Applied',
            date: application!.appliedAt!,
            completed: true,
          ),
          if (application!.viewedAt != '')
            ProgressStep(
              title: 'Viewed by recruiter',
              date: application!.viewedAt!,
              completed: true,
            ),
          if (application!.interviewingAt != '')
            ProgressStep(
              title: 'Interviewing',
              date: application!.interviewingAt!,
              completed: true,
            ),
          if (application!.acceptedAt != '')
            ProgressStep(
              title: 'Accepted',
              date: application!.acceptedAt!,
              completed: true,
            ),
          if (application!.rejectedAt != '')
            ProgressStep(
              title: 'Rejected',
              date: application!.rejectedAt!,
              completed: false,
            ),
        ];
        isLoading = false;
      });
    }
  }

  void updateStatusApplication(String status) async {
    final result = await ApplicationService().updateStatusApplication(
      application!.id,
      status,
      application!.title,
      application!.companyName!,
    );

    if (result['success']) {
      await NotificationService().addNotification(application!.candidateId, {
        'applicationId': application!.id,
        'title': application!.title,
        'companyName': application!.companyName!,
        'status': status,
      });
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success']
            ? AppColors.success
            : AppColors.error,
      ),
    );

    if (result['success']) {
      fetchApplicationDetail();
    }
  }

  String getFormattedResumeFileName(Application application) {
    final fullName = application.fullName?.replaceAll(' ', '') ?? 'Candidate';
    final uri = Uri.parse(application.resumeUrl!);
    final fileName = uri.pathSegments.last;
    final fileExtension = fileName.split('.').last;

    return '${fullName}_Resume.$fileExtension';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
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
                Text("Application Detail", style: textTheme.headlineMedium),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: application!.avatarUrl != ''
                          ? NetworkImage(application!.avatarUrl!)
                          : AssetImage("assets/default_avatar.png"),
                      radius: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      application!.fullName!,
                      style: textTheme.headlineLarge,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Applied for ${application!.title}",
                      style: textTheme.bodyMedium!.copyWith(
                        color: AppColors.hint,
                      ),
                      maxLines: 1,
                      softWrap: false,
                    ),
                    SizedBox(height: 10),
                    if (application!.status != 'Accepted' &&
                        application!.status != 'Rejected')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              application!.status != 'Interviewing'
                                  ? updateStatusApplication("Interviewing")
                                  : updateStatusApplication("Accepted");
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: application!.status != 'Interviewing'
                                    ? AppColors.primary
                                    : AppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),

                              child: Text(
                                application!.status != 'Interviewing'
                                    ? 'Interview'
                                    : 'Accept',
                                style: TextStyle(color: AppColors.surface),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              updateStatusApplication("Rejected");
                            },
                            child: Container(
                              width: 100,
                              padding: EdgeInsets.all(6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Reject',
                                style: TextStyle(color: AppColors.surface),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Introduce
                    Text("Resume", style: textTheme.headlineMedium),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          UserService().downloadAndOpenFile(
                            application!.resumeUrl!,
                            getFormattedResumeFileName(application!),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf, size: 32),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getFormattedResumeFileName(application!),
                                  style: textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatter.format(
                                    DateTime.parse(application!.appliedAt!),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.download),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Introduce
                    Text(
                      "Letter of recommendation",
                      style: textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      application!.introduction!,
                      style: textTheme.bodyMedium,
                    ),
                    SizedBox(height: 24),
                    Text("Progress", style: textTheme.headlineMedium),
                    SizedBox(height: 8),
                    Column(
                      children: List.generate(progressSteps.length, (index) {
                        final step = progressSteps[index];
                        final isLast = index == progressSteps.length - 1;
                        return ProgressStepWidget(
                          step: step,
                          showLine: !isLast,
                        );
                      }),
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

class ProgressStep {
  final String title;
  final String date;
  final bool completed;

  const ProgressStep({
    required this.title,
    required this.date,
    required this.completed,
  });
}

class ProgressStepWidget extends StatelessWidget {
  final ProgressStep step;
  final bool showLine;

  const ProgressStepWidget({
    super.key,
    required this.step,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: textTheme.bodyMedium),
                Text(
                  step.date,
                  style: textTheme.bodySmall!.copyWith(color: AppColors.hint),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Icon(
              step.completed ? Icons.check_circle : Icons.cancel,
              color: step.completed ? Colors.green : Colors.red,
              size: 20,
            ),
            if (showLine)
              Container(width: 2, height: 32, color: Colors.grey.shade300),
          ],
        ),
      ],
    );
  }
}
