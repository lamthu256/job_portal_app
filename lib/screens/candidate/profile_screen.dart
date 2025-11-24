import 'package:flutter/material.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/models/skill.dart';
import 'package:job_portal_app/screens/candidate/edit_profile_screen.dart';
import 'package:job_portal_app/services/candidate_service.dart';
import 'package:job_portal_app/services/skill_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/profile/skill_chip.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const ProfileScreen({super.key, this.onProfileUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Candidate candidate;
  late List<Skill> skillList;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final userId = UserSession.userId;

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final resCan = await CandidateService().getCandidate(userId);
    final resSkills = await SkillService().getUserSkills(userId);

    if (resCan['success']) {
      setState(() {
        candidate = Candidate.fromJson(resCan['data']);
        skillList = resSkills;
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
                    Navigator.pop(context, true);
                  },
                  child: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
                ),
                SizedBox(width: 8),
                Text("Profile", style: textTheme.headlineMedium),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                          candidate: candidate,
                          skillList: skillList,
                        ),
                      ),
                    );

                    if (updated) {
                      await fetchProfile();
                      widget.onProfileUpdated!();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mode_edit_outline,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "Edit",
                        style: textTheme.headlineSmall!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      children: [
                        if ((candidate.jobTitle ?? "").isNotEmpty) ...[
                          Text(
                            candidate.jobTitle ?? '',
                            style: textTheme.headlineLarge!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                        CircleAvatar(
                          backgroundImage: candidate.avatarUrl != ""
                              ? NetworkImage(candidate.avatarUrl!)
                              : AssetImage("assets/default_avatar.png"),
                          radius: 40,
                        ),
                        SizedBox(height: 20),
                        Text(
                          candidate.fullName,
                          style: textTheme.headlineLarge,
                        ),
                        SizedBox(height: 4),
                        Text(
                          UserSession.email ?? '',
                          style: textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (candidate.summary != '') ...[
                        // Introduce
                        Text("About me", style: textTheme.headlineMedium),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if ((candidate.phone ?? '').isNotEmpty) ...[
                              Icon(
                                Icons.phone_outlined,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 2),
                              Text(
                                candidate.phone ?? '',
                                style: textTheme.bodySmall!.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                            if (candidate.location != '') ...[
                              Icon(
                                Icons.location_on,
                                size: 13,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 2),
                              Text(
                                candidate.location ?? '',
                                style: textTheme.bodySmall!.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          candidate.summary ?? '',
                          style: textTheme.bodyMedium,
                        ),
                        SizedBox(height: 24),
                      ],

                      // Work Experience
                      if (candidate.experience != '') ...[
                        Text(
                          "Work experience",
                          style: textTheme.headlineMedium,
                        ),
                        SizedBox(height: 8),
                        Text(
                          candidate.experience ?? '',
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
