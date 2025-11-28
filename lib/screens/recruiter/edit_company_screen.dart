import 'dart:io';

import 'package:flutter/material.dart';
import 'package:job_portal_app/config/provinces.dart';
import 'package:job_portal_app/models/recruiter.dart';
import 'package:job_portal_app/services/recruiter_service.dart';
import 'package:job_portal_app/services/user_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/utils/image_picker_helper.dart';
import 'package:job_portal_app/widgets/common/dropdown_field.dart';
import 'package:job_portal_app/widgets/common/edit_profile_field.dart';

class EditCompanyScreen extends StatefulWidget {
  final Recruiter recruiter;

  const EditCompanyScreen({super.key, required this.recruiter});

  @override
  State<EditCompanyScreen> createState() => _EditCompanyScreenState();
}

class _EditCompanyScreenState extends State<EditCompanyScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  File? _selectedImage;
  List<String> provinces = vietnamProvinces;
  String? selectedLocation;
  bool isSaving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController.text = widget.recruiter.companyName;
    _emailController.text = UserSession.email ?? '';
    _phoneController.text = widget.recruiter.phone ?? '';
    if (provinces.contains(widget.recruiter.location)) {
      selectedLocation = widget.recruiter.location;
    } else {
      selectedLocation = null;
    }
    _websiteController.text = widget.recruiter.website ?? '';
    _sizeController.text = widget.recruiter.size ?? '';
    _industryController.text = widget.recruiter.industry ?? '';
    _descriptionController.text = widget.recruiter.description ?? '';
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

    String? logoUrl = widget.recruiter.logoUrl;
    if (_selectedImage != null) {
      final resUrl = await UserService().uploadAvatar(
        userId!,
        role!,
        _selectedImage!,
      );

      if (!mounted) return;

      if (resUrl['success']) {
        logoUrl = resUrl['url'];
      } else {
        setState(() => isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resUrl['message']),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    if (!mounted) return;

    final resRec = await RecruiterService().updateRecruiter({
      'user_id': userId,
      'company_name': _nameController.text,
      'description': _descriptionController.text,
      'phone': _phoneController.text,
      'location': selectedLocation,
      'website': _websiteController.text,
      'size': _sizeController.text,
      'industry': _industryController.text,
      'logo_url': logoUrl,
    });

    if (!mounted) return;

    setState(() => isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resRec['message']),
        backgroundColor: resRec['success']
            ? AppColors.success
            : AppColors.error,
      ),
    );

    if (resRec['success']) {
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
                                    : (widget.recruiter.logoUrl != null &&
                                              widget
                                                  .recruiter
                                                  .logoUrl!
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              widget.recruiter.logoUrl!,
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
                        label: "Company Name",
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

                      Text("Location", style: textTheme.titleLarge),
                      DropdownField(
                        hint: 'Select a location',
                        items: provinces,
                        selectedValue: selectedLocation,
                        onChanged: (value) {
                          setState(
                            () => selectedLocation = (selectedLocation == value)
                                ? null
                                : value,
                          );
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select province';
                          }
                          return null;
                        },
                      ),
                      EditProfileField(
                        label: "Website",
                        controller: _websiteController,
                        keyboardType: TextInputType.text,
                      ),
                      EditProfileField(
                        label: "Size",
                        controller: _sizeController,
                        keyboardType: TextInputType.text,
                      ),
                      EditProfileField(
                        label: "Industry",
                        controller: _industryController,
                      ),
                      EditProfileField(
                        label: "Description",
                        controller: _descriptionController,
                        maxLines: 4,
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
