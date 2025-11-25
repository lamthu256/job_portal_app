import 'package:flutter/material.dart';
import 'package:job_portal_app/models/application.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/models/skill.dart';
import 'package:job_portal_app/screens/recruiter/application_detail_screen.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/services/candidate_service.dart';
import 'package:job_portal_app/services/skill_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/applications/applicant_card.dart';
import 'package:job_portal_app/widgets/profile/skill_chip.dart';

class CandidateDetailScreen extends StatefulWidget {
  final int candidateId;

  const CandidateDetailScreen({super.key, required this.candidateId});

  @override
  State<CandidateDetailScreen> createState() => _CandidateDetailScreenState();
}

class _CandidateDetailScreenState extends State<CandidateDetailScreen> {
  late Candidate candidate;
  late List<Skill> skillList;
  late List<Application> applicationList;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCandidateDetail();
  }

  void fetchCandidateDetail() async {
    final recruiterId = UserSession.userId;

    if (recruiterId == null) {
      setState(() => isLoading = false);
      return;
    }

    final resCan = await CandidateService().getCandidate(widget.candidateId);
    final resSkills = await SkillService().getUserSkills(widget.candidateId);
    final resApp = await ApplicationService().getCandidateApplications(
      recruiterId,
      widget.candidateId,
    );

    if (resCan['success']) {
      setState(() {
        candidate = Candidate.fromJson(resCan['data']);
        skillList = resSkills;
        applicationList = (resApp['application_list'] as List)
            .map((app) => Application.fromJson(app))
            .toList();
        isLoading = false;
      });
    } else {
      // Xử lý lỗi nếu cần
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
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
                ),
                SizedBox(width: 8),
                Text("Candidate Detail", style: textTheme.headlineMedium),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
              Container(
                padding: EdgeInsets.fromLTRB(24, 6, 24, 24),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: candidate.avatarUrl != ""
                          ? NetworkImage(candidate.avatarUrl!)
                          : AssetImage("assets/default_avatar.png"),
                      radius: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      candidate.fullName,
                      style: textTheme.headlineLarge,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (candidate.jobTitle != "")
                          Text(
                            "${candidate.jobTitle} • ",
                            style: textTheme.bodyMedium!.copyWith(
                              color: AppColors.hint,
                            ),
                          ),
                        Icon(
                          Icons.location_on,
                          size: 13,
                          color: AppColors.hint,
                        ),
                        SizedBox(width: 2),
                        Text(
                          candidate.location != ''
                              ? candidate.location!
                              : "Unknown",
                          style: textTheme.bodyMedium!.copyWith(
                            color: AppColors.hint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 18, 24, 24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduce
                      Text("About me", style: textTheme.headlineMedium),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.mail_outline,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            candidate.email!,
                            style: textTheme.bodyMedium!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 10),
                          if (candidate.phone != "") ...[
                            Icon(
                              Icons.phone_outlined,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4),
                            Text(
                              candidate.phone!,
                              style: textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 8),

                      if (candidate.summary != "") ...[
                        Text(candidate.summary!, style: textTheme.bodyMedium),
                        SizedBox(height: 24),
                      ],

                      // Work Experience
                      if (candidate.experience != "") ...[
                        Text(
                          "Work experience",
                          style: textTheme.headlineMedium,
                        ),
                        SizedBox(height: 12),
                        Text(
                          candidate.experience!,
                          style: textTheme.bodyMedium,
                        ),
                        SizedBox(height: 24),
                      ],

                      // Skills
                      if (skillList.isNotEmpty) ...[
                        Text("Skills", style: textTheme.headlineMedium),
                        SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: skillList.map((skill) {
                            return SkillChip(skill.name);
                          }).toList(),
                        ),
                      ],

                      Text("Applications", style: textTheme.headlineMedium),
                      SizedBox(height: 12),
                      ...applicationList.map((app) {
                        return ApplicationCard(
                          title: app.title,
                          candidateName: app.fullName!,
                          appliedAt: app.appliedAt!,
                          status:
                              (app.status! == "Applied" ||
                                  app.status! == "Viewed")
                              ? "Pending"
                              : app.status!,
                          isBackground: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ApplicationDetailScreen(
                                  applicationId: app.id,
                                ),
                              ),
                            );
                          },
                        );
                      }),
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
