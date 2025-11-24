import 'package:flutter/material.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/candidate/search_screen.dart';
import 'package:job_portal_app/screens/candidate/activity_screen.dart';
import 'package:job_portal_app/screens/candidate/ai_chat_screen.dart';
import 'package:job_portal_app/screens/candidate/notification_screen.dart';
import 'package:job_portal_app/screens/common/settings_screen.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/services/candidate_service.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/notification_service.dart';
import 'package:job_portal_app/services/recruiter_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/screens/candidate/home_screen.dart';
import 'package:job_portal_app/widgets/navigation/custom_bottom_nav_bar.dart';

class CandidateScreen extends StatefulWidget {
  const CandidateScreen({super.key});

  @override
  State<CandidateScreen> createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen> {
  Candidate? candidate;
  bool isLoading = true;
  int _currentIndex = 0;
  List<Widget> screens = [];
  List<Recruiter> recruiterList = [];
  List<Job> featuredJobList = [];
  List<Job> latestJobList = [];
  late int totalSaved = 0;
  List<Job> savedJobs = [];
  late int totalApplied = 0;
  List<Application> appliedJobs = [];
  int unreadNotifications = 0;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchCandidate();
    super.initState();
  }

  void fetchCandidate() async {
    final userId = UserSession.userId;
    final role = UserSession.role;

    if (userId != null && role != null) {
      final result = await CandidateService().getCandidate(userId);
      final resRecruiterList = await RecruiterService().getAllRecruiters();
      final resFeaturedJobList = await JobService().getFeaturedJobs(userId);
      final resLatestJobList = await JobService().getLatestJob();
      final resSavedJob = await JobService().getSavedJobs(userId);
      final resAppliedJob = await ApplicationService().getAppliedJobs(userId);
      final resNotifications = await NotificationService().getNotificationList(
        userId,
      );

      if (result['success']) {
        setState(() {
          candidate = Candidate.fromJson(result['data']);
          recruiterList = resRecruiterList;
          featuredJobList = resFeaturedJobList['data'];
          latestJobList = resLatestJobList['data'];
          totalSaved = resSavedJob['total_saved'];
          savedJobs = (resSavedJob['saved_jobs'] as List)
              .map((jobJson) => Job.fromJson(jobJson))
              .toList();
          totalApplied = resAppliedJob['total_applied'];
          appliedJobs = (resAppliedJob['applied_jobs'] as List)
              .map((jobJson) => Application.fromJson(jobJson))
              .toList();

          if (resNotifications['success'] &&
              resNotifications['notifications'] != null) {
            notifications = List<Map<String, dynamic>>.from(
              resNotifications['notifications'] ?? [],
            );
            unreadNotifications = notifications
                .where((notif) => notif['is_read'] == 0)
                .length;
          }

          buildScreen();
          isLoading = false;
        });
      }
    }
  }

  void buildScreen() {
    screens = [
      HomeScreen(
        avatarUrl: candidate!.avatarUrl,
        name: candidate!.fullName,
        recruiterList: recruiterList,
        featuredJobList: featuredJobList,
        latestJobList: latestJobList,
        onProfileUpdated: fetchCandidate,
      ),
      SearchScreen(onProfileUpdated: fetchCandidate),
      ActivityScreen(
        totalSaved: totalSaved,
        savedJobs: savedJobs,
        totalApplied: totalApplied,
        appliedJobs: appliedJobs,
        onProfileUpdated: fetchCandidate,
      ),
      SettingsScreen(
        avatarUrl: candidate!.avatarUrl,
        name: candidate!.fullName,
        onProfileUpdated: fetchCandidate,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Icon(
                Icons.align_vertical_center_rounded,
                color: AppColors.primary,
              ),
              SizedBox(width: 6),
              Text('My Logo', style: Theme.of(context).textTheme.displaySmall),
              Spacer(),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_outlined),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationScreen(
                            initialNotifications: notifications,
                            onNotificationsUpdated: fetchCandidate,
                          ),
                        ),
                      );

                      if (result) {
                        setState(() {
                          fetchCandidate();
                          _currentIndex = 2;
                        });
                      }
                    },
                  ),
                  if (unreadNotifications > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          unreadNotifications > 99
                              ? '99+'
                              : unreadNotifications.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        role: UserSession.role,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AIChatScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.smart_toy, color: AppColors.surface),
      ),
    );
  }
}
