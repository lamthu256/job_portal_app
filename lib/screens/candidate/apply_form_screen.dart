import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_app/models/candidate.dart';
import 'package:job_portal_app/services/application_service.dart';
import 'package:job_portal_app/services/candidate_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/text_field_form.dart';

class ApplyFormScreen extends StatefulWidget {
  final int jobId;

  const ApplyFormScreen({super.key, required this.jobId});

  @override
  State<ApplyFormScreen> createState() => _ApplyFormScreenState();
}

class _ApplyFormScreenState extends State<ApplyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _introductionController = TextEditingController();

  Candidate? candidate;
  bool isLoading = true;
  bool isSubmitting = false;
  File? selectedFile;
  String? fileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInfoCandidate();
  }

  void fetchInfoCandidate() async {
    final userId = UserSession.userId;

    if (userId != null) {
      final result = await CandidateService().getCandidate(userId);

      if (result['success']) {
        setState(() {
          candidate = Candidate.fromJson(result['data']);
          _nameController.text = candidate!.fullName;
          _emailController.text = UserSession.email!;
          _phoneController.text = candidate!.phone!;
          isLoading = false;
        });
      }
    }
  }

  void postApplication() async {
    setState(() => isSubmitting = true);

    final candidateId = UserSession.userId;

    if (selectedFile != null) {
      final result = await ApplicationService().postApplication(
        widget.jobId,
        candidateId!,
        selectedFile!,
        _introductionController.text,
      );

      if (!mounted) return;

      setState(() => isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success']
              ? AppColors.success
              : AppColors.error,
        ),
      );

      if (result['success']) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
      body: Column(
        children: [
          // Title
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Apply For A Position", style: textTheme.headlineMedium),
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldForm(
                      controller: _nameController,
                      label: "Name",
                      hint: "Type here",
                      enabled: false,
                    ),
                    TextFieldForm(
                      controller: _emailController,
                      label: "Email",
                      hint: "Type here",
                      enabled: false,
                    ),
                    TextFieldForm(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "",
                      enabled: false,
                    ),
                    SizedBox(height: 10),

                    // Upload CV placeholder
                    Text("Upload CV", style: textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf', 'doc', 'docx'],
                            );

                        if (result != null &&
                            result.files.single.path != null) {
                          setState(() {
                            selectedFile = File(result.files.single.path!);
                            fileName = result.files.single.name;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(14),
                          color: AppColors.surface,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.upload_file, color: AppColors.primary),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                fileName ??
                                    "Select your CV (.pdf, .doc, .docx)",
                                style: textTheme.bodyMedium!.copyWith(
                                  color: fileName != null
                                      ? AppColors.textPrimary
                                      : AppColors.hint,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (fileName != null) ...[
                              SizedBox(width: 8),
                              Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFieldForm(
                      controller: _introductionController,
                      label: "Introduction",
                      hint: "Type here",
                      maxLines: 4,
                    ),
                    SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  if (selectedFile == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please upload your CV."),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );
                                    return;
                                  }
                                  postApplication();
                                }
                              },
                        child: isSubmitting
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
                            : Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
