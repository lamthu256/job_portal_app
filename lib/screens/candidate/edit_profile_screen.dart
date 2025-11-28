import 'dart:io';
import 'package:flutter/material.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/models/skill.dart';
import 'package:job_portal_app/services/candidate_service.dart';
import 'package:job_portal_app/services/skill_service.dart';
import 'package:job_portal_app/services/user_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/utils/image_picker_helper.dart';
import 'package:job_portal_app/widgets/common/edit_profile_field.dart';

class EditProfileScreen extends StatefulWidget {
  final Candidate candidate;
  final List<Skill> skillList;

  const EditProfileScreen({
    super.key,
    required this.candidate,
    required this.skillList,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  List<String> userSkills = [];
  String? selectedSkill;
  File? _selectedImage;
  bool isSaving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.candidate.fullName;
    _emailController.text = UserSession.email ?? '';
    _phoneController.text = widget.candidate.phone ?? '';
    _locationController.text = widget.candidate.location ?? '';
    _jobTitleController.text = widget.candidate.jobTitle ?? '';
    _summaryController.text = widget.candidate.summary ?? '';
    _experienceController.text = widget.candidate.experience ?? '';

    userSkills = widget.skillList.map((e) => e.name).toList();
  }

  Future<void> pickImage() async {
    final image = await ImagePickerHelper.pickImageWithOptions(context);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final userId = UserSession.userId;
    final role = UserSession.role;

    String? avatarUrl = widget.candidate.avatarUrl;
    if (_selectedImage != null) {
      final resAvatar = await UserService().uploadAvatar(
        userId!,
        role!,
        _selectedImage!,
      );

      if (!mounted) return;

      if (resAvatar['success']) {
        avatarUrl = resAvatar['url'];
      } else {
        setState(() => isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resAvatar['message']),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    final resSkills = await SkillService().updateUserSkills(
      userId!,
      userSkills,
    );

    if (!mounted) return;

    if (!resSkills['success']) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resSkills['message']),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final resCan = await CandidateService().updateCandidate({
      'user_id': userId,
      'full_name': _nameController.text,
      'phone': _phoneController.text,
      'location': _locationController.text,
      'job_title': _jobTitleController.text,
      'summary': _summaryController.text,
      'experience': _experienceController.text,
      'avatar_url': avatarUrl,
    });

    if (!mounted) return;

    setState(() => isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resCan['message']),
        backgroundColor: resCan['success']
            ? AppColors.success
            : AppColors.error,
      ),
    );

    if (resCan['success']) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                Text(
                  'My Logo',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Title
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit Profile", style: textTheme.headlineMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      "Cancel",
                      style: textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Apply Job Form
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 14),
                        child: Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : (widget.candidate.avatarUrl != null &&
                                              widget
                                                  .candidate
                                                  .avatarUrl!
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              widget.candidate.avatarUrl!,
                                            )
                                          : AssetImage(
                                              'assets/default_avatar.png',
                                            )),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: pickImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: AppColors.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      EditProfileField(
                        label: "Name",
                        controller: _nameController,
                        isRequired: true,
                      ),
                      EditProfileField(
                        label: "Email",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: false,
                      ),
                      EditProfileField(
                        label: "Phone Number",
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      EditProfileField(
                        label: "Location",
                        controller: _locationController,
                        keyboardType: TextInputType.text,
                      ),
                      EditProfileField(
                        label: "Job Title",
                        controller: _jobTitleController,
                        keyboardType: TextInputType.text,
                      ),
                      EditProfileField(
                        label: "Summary",
                        controller: _summaryController,
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                      ),
                      EditProfileField(
                        label: "Work Experience",
                        controller: _experienceController,
                        maxLines: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: EditProfileField(
                              label: "Skill",
                              hint: "Enter a skill",
                              controller: _skillController,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              final skill = _skillController.text.trim();
                              if (skill.isNotEmpty &&
                                  !userSkills.contains(skill)) {
                                setState(() {
                                  userSkills.add(skill);
                                  _skillController.clear();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: userSkills.map((skill) {
                          return Chip(
                            label: Text(skill, style: textTheme.bodyMedium),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() => userSkills.remove(skill));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: AppColors.hint,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : updateUser,
                          child: isSaving
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.surface,
                                    ),
                                  ),
                                )
                              : Text("Save"),
                        ),
                      ),
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
