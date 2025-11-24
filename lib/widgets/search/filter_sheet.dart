import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/dropdown_field.dart';
import 'package:job_portal_app/widgets/search/job_search_chip.dart';

class FilterSheet extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  const FilterSheet({super.key, required this.initialValues});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  String? selectedCompany;
  String? selectedLocation;
  int? selectedJobField;
  String? selectedJobType;
  String? selectedWorkplaceType;

  List<String> companies = [];
  List<String> locations = [];
  List<Map<String, dynamic>> jobFields = [];
  List<String> jobTypes = [];
  List<String> workplaceTypes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFilterOptions();

    final init = widget.initialValues;
    selectedCompany = init['company_name'];
    selectedLocation = init['work_location'];
    selectedJobField = init['field_id'];
    selectedJobType = init['job_type'];
    selectedWorkplaceType = init['workplace_type'];
  }

  Future<void> fetchFilterOptions() async {
    final result = await JobService().getFilterOptions();
    final data = result['data'];
    if (data == null) return;

    setState(() {
      companies = List<String>.from(data['company_names'] ?? []);
      locations = List<String>.from(data['work_locations'] ?? []);
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
    });
  }

  void _returnFilters() {
    Navigator.pop(context, {
      'company_name': selectedCompany,
      'work_location': selectedLocation,
      'job_type': selectedJobType,
      'workplace_type': selectedWorkplaceType,
      'field_id': selectedJobField,
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Set Filters", style: textTheme.headlineMedium),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCompany = null;
                      selectedLocation = null;
                      selectedJobField = null;
                      selectedJobType = null;
                      selectedWorkplaceType = null;
                    });
                    _returnFilters();
                  },
                  child: Text(
                    "Clear all",
                    style: textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text("Company Name", style: textTheme.titleLarge),
            DropdownField(
              hint: 'Select a company name',
              items: companies,
              selectedValue: selectedCompany,
              onChanged: (value) {
                setState(
                  () => selectedCompany = (selectedCompany == value)
                      ? null
                      : value,
                );
              },
            ),

            Text("Location", style: textTheme.titleLarge),
            DropdownField(
              hint: 'Select a location',
              items: locations,
              selectedValue: selectedLocation,
              onChanged: (value) {
                setState(
                  () => selectedLocation = (selectedLocation == value)
                      ? null
                      : value,
                );
              },
            ),

            Text("Job Field", style: textTheme.titleLarge),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 16),
              child: DropdownButtonFormField2<int>(
                isExpanded: true,
                value: selectedJobField,
                hint: Text('Select a job field', style: textTheme.labelSmall),
                items: jobFields.map((item) {
                  return DropdownMenuItem<int>(
                    value: item['id'] as int,
                    child: Text(item['name'], style: textTheme.bodyLarge),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedJobField = (selectedJobField == value)
                        ? null
                        : value;
                  });
                },
                iconStyleData: IconStyleData(iconEnabledColor: AppColors.hint),
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
              ),
            ),

            Text("Job Type", style: textTheme.titleLarge),
            SizedBox(height: 6),
            GridView.count(
              padding: EdgeInsets.only(bottom: 16),
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: jobTypes.map((type) {
                return JobSearchChip(
                  label: type,
                  selected: selectedJobType == type,
                  opTap: () {
                    setState(() {
                      selectedJobType = (selectedJobType == type) ? null : type;
                    });
                  },
                );
              }).toList(),
            ),

            Text("Workplace Type", style: textTheme.titleLarge),
            SizedBox(height: 6),
            GridView.count(
              padding: EdgeInsets.only(bottom: 16),
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: workplaceTypes.map((workplace) {
                return JobSearchChip(
                  label: workplace,
                  selected: selectedWorkplaceType == workplace,
                  opTap: () {
                    setState(() {
                      selectedWorkplaceType =
                          (selectedWorkplaceType == workplace)
                          ? null
                          : workplace;
                    });
                  },
                );
              }).toList(),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _returnFilters();
                },
                child: const Text("Apply Filters"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

