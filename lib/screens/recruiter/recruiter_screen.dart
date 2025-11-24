import 'package:flutter/material.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/screens/common/settings_screen.dart';
import 'package:job_portal_app/screens/recruiter/application_list_screen.dart';
import 'package:job_portal_app/screens/recruiter/candidate_list_screen.dart';
import 'package:job_portal_app/screens/recruiter/jobs_screen.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/services/candidate_service.dart';
import 'package:job_portal_app/services/recruiter_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/navigation/custom_bottom_nav_bar.dart';

class RecruiterScreen extends StatefulWidget {
  const RecruiterScreen({super.key});

  @override
  State<RecruiterScreen> createState() => _RecruiterScreenState();
}

class _RecruiterScreenState extends State<RecruiterScreen> {
  Recruiter? recruiter;
  bool isLoading = true;
  int _currentIndex = 0;
  List<Widget> screens = [];
  String jobStatus = 'Open';
  late int countOpen;
  late int countClosed;
  late int totalApplied = 0;
  List<Application> applicationList = [];
  late int totalCandidate = 0;
  List<Candidate> candidateList = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchRecruiter();
    super.initState();
  }

  void fetchRecruiter() async {
    final userId = UserSession.userId;

    if (userId != null) {
      final result = await RecruiterService().getRecruiter(userId);
      final resApp = await ApplicationService().getApplicationList(userId);
      final resCan = await CandidateService().getCandidateList(userId);

      if (result['success']) {
        setState(() {
          recruiter = Recruiter.fromJson(result['data']);
          totalApplied = resApp['total_applied'];
          applicationList = (resApp['application_list'] as List)
              .map((app) => Application.fromJson(app))
              .toList();
          totalCandidate = resCan['total_candidate'];
          candidateList = (resCan['candidate_list'] as List)
              .map((can) => Candidate.fromJson(can))
              .toList();
          buildScreen();
          isLoading = false;
        });
      }
    }
  }

  void buildScreen() {
    screens = [
      JobsScreen(
        logoUrl: recruiter!.logoUrl,
        companyName: recruiter!.companyName,
        onProfileUpdated: fetchRecruiter,
      ),
      ApplicationListScreen(
        totalApplied: totalApplied,
        applicationList: applicationList,
        onDataUpdated: fetchRecruiter,
      ),
      CandidateListScreen(
        totalCandidate: totalCandidate,
        candidateList: candidateList,
        onDataUpdated: fetchRecruiter,
      ),
      SettingsScreen(
        avatarUrl: recruiter!.logoUrl,
        name: recruiter!.companyName,
        onProfileUpdated: fetchRecruiter,
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
    );
  }
}
