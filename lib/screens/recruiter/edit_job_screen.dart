import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_app/config/provinces.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/text_field_form.dart';
import 'package:job_portal_app/widgets/common/dropdown_field.dart';
import 'package:job_portal_app/widgets/common/date_picker_field.dart';
import 'package:job_portal_app/widgets/common/number_picker_field.dart';

class EditJobScreen extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const EditJobScreen({super.key, required this.jobData});

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _salaryController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _interestController = TextEditingController();
  final _addressDetailController = TextEditingController();
  final _workingTimeController = TextEditingController();

  int? jobId;
  String? selectedJobType;
  String? selectedWorkplaceType;
  int? vacancyCount;
  int? selectedJobField;
  String? selectedProvince;
  String? deadline;
  String? selectedStatus;

  List<String> jobTypes = [];
  List<String> workplaceTypes = [];
  List<Map<String, dynamic>> jobFields = [];
  List<String> jobStatus = [];
  List<String> provinces = vietnamProvinces;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobOptions();

    final job = widget.jobData;
    jobId = job['job_id'];
    _titleController.text = job['title'];
    _salaryController.text = job['salary'];
    selectedJobType = job['job_type'];
    selectedWorkplaceType = job['workplace_type'];
    _experienceController.text = job['experience'];
    vacancyCount = job['vacancy_count'];
    selectedJobField = job['field_id'];
    _descriptionController.text = job['job_description'];
    _requirementsController.text = job['requirements'];
    _interestController.text = job['interest'];
    selectedProvince = job['province'];
    _addressDetailController.text = job['address'];
    _workingTimeController.text = job['working_time'];
    deadline = job['deadline'];
    selectedStatus = job['job_status'];
  }

  void fetchJobOptions() async {
    final result = await JobService().getFilterOptions();
    final data = result['data'];
    if (data == null) return;

    setState(() {
      jobFields = (data['job_fields'] as List)
          .map(
            (e) => {
          'id': int.tryParse(e['id'].toString()) ?? 0,
          'name': e['name'].toString(),
        },
      )
          .toList();
      jobTypes = List<String>.from(data['job_types'] ?? []);
      workplaceTypes = List<String>.from(data['workplace_types'] ?? []);
      jobStatus = List<String>.from(data['job_status'] ?? []);
      isLoading = false;
    });
  }

  void updateJob() async {
    final recruiterId = UserSession.userId;

    if (recruiterId != null) {
      final result = await JobService().updateJob(
        jobId!,
        recruiterId,
        _titleController.text,
        _salaryController.text,
        selectedJobType!,
        selectedWorkplaceType!,
        _experienceController.text,
        vacancyCount!,
        selectedJobField!,
        _descriptionController.text,
        _requirementsController.text,
        _interestController.text,
        "$selectedProvince: ${_addressDetailController.text}",
        _workingTimeController.text,
        deadline!,
        selectedStatus!
      );

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Edit A Job", style: textTheme.headlineMedium),
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
                        controller: _titleController,
                        label: "Title",
                        hint: "Type here",
                        keyboardType: TextInputType.text,
                        validText: "Please enter title",
                      ),

                      TextFieldForm(
                        controller: _salaryController,
                        label: "Salary",
                        hint: "Type here",
                        keyboardType: TextInputType.number,
                        validText: "Please enter salary",
                      ),

                      Text("Job Type", style: textTheme.titleLarge),
                      DropdownField(
                        hint: 'Select a job type',
                        items: jobTypes,
                        selectedValue: selectedJobType,
                        onChanged: (value) {
                          setState(
                                () => selectedJobType = (selectedJobType == value)
                                ? null
                                : value,
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select job type';
                          }
                          return null;
                        },
                      ),

                      Text("Workplace Type", style: textTheme.titleLarge),
                      DropdownField(
                        hint: 'Select a workplace type',
                        items: workplaceTypes,
                        selectedValue: selectedWorkplaceType,
                        onChanged: (value) {
                          setState(
                                () => selectedWorkplaceType =
                            (selectedWorkplaceType == value) ? null : value,
                          );
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select workplace type';
                          }
                          return null;
                        },
                      ),

                      TextFieldForm(
                        controller: _experienceController,
                        label: "Experience",
                        hint: "Type here",
                        keyboardType: TextInputType.text,
                        validText: "Please enter experience",
                      ),

                      Text("Vacancy Count", style: textTheme.titleLarge),
                      NumberPickerField(
                        initialValue: vacancyCount!,
                        onChanged: (val) {
                          setState(() {
                            vacancyCount = val;
                          });
                        },
                      ),

                      Text("Job Field", style: textTheme.titleLarge),
                      Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 16),
                        child: DropdownButtonFormField2<int>(
                          isExpanded: true,
                          value: selectedJobField,
                          hint: Text(
                            'Select a job field',
                            style: textTheme.labelSmall,
                          ),
                          items: jobFields.map((item) {
                            return DropdownMenuItem<int>(
                              value: item['id'] as int,
                              child: Text(
                                item['name'],
                                style: textTheme.bodyLarge,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedJobField = (selectedJobField == value)
                                  ? null
                                  : value;
                            });
                          },
                          iconStyleData: IconStyleData(
                            iconEnabledColor: AppColors.hint,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 250,
                            width: MediaQuery.of(context).size.width - 48,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            offset: const Offset(0, -4),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            selectedMenuItemBuilder: (context, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                ),
                                child: child,
                              );
                            },
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select job field';
                            }
                            return null;
                          },
                        ),
                      ),

                      TextFieldForm(
                        controller: _descriptionController,
                        label: "Description",
                        hint: "Type here",
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        validText: "Please enter description",
                      ),

                      TextFieldForm(
                        controller: _requirementsController,
                        label: "Requirements",
                        hint: "Type here",
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        validText: "Please enter requirements",
                      ),

                      TextFieldForm(
                        controller: _interestController,
                        label: "Interest",
                        hint: "Type here",
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                        validText: "Please enter interest",
                      ),

                      Text("Work Location", style: textTheme.titleLarge),
                      DropdownField(
                        hint: 'Select a province',
                        items: provinces,
                        selectedValue: selectedProvince,
                        onChanged: (value) {
                          setState(
                                () => selectedProvince = (selectedProvince == value)
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
                      TextFieldForm(
                        controller: _addressDetailController,
                        hint: "Detailed address",
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                      ),

                      TextFieldForm(
                        controller: _workingTimeController,
                        label: "Working Time",
                        hint: "Type here",
                        keyboardType: TextInputType.text,
                        maxLines: 4,
                      ),

                      DatePickerField(
                        initialDate: DateTime.parse(deadline!),
                        label: 'Application Deadline',
                        validText: "Please select application deadline",
                        onDateChanged: (selectedDate) {
                          setState(() {
                            deadline = selectedDate.toString();
                          });
                        },
                      ),

                      Text("Status", style: textTheme.titleLarge),
                      DropdownField(
                        hint: 'Select a status',
                        items: jobStatus,
                        selectedValue: selectedStatus,
                        onChanged: (value) {
                          setState(
                                () => selectedStatus =
                            (selectedStatus == value) ? null : value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ), // Submit button
            Padding(
              padding: EdgeInsets.only(left: 24, top: 0, right: 24, bottom: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateJob();
                    }
                  },
                  child: Text("Update"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
