import 'package:flutter/material.dart';
import 'package:job_portal_app/config/global_event.dart';
import 'package:job_portal_app/screens/candidate/job_detail_screen.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/search/filter_sheet.dart';
import 'package:job_portal_app/widgets/search/job_search_card.dart';
import 'package:job_portal_app/widgets/search/job_search_chip.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const SearchScreen({super.key, required this.onProfileUpdated});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int? selectedJobField;
  List<Map<String, dynamic>> jobFields = [];

  String keyword = '';
  Map<String, dynamic> filters = {};
  List<dynamic> jobs = [];

  bool hasFilter = false;

  @override
  void initState() {
    super.initState();
    selectedJobField = null;
    filters['field_id'] = null;
    _searchJobs();

    eventBus.on<JobUpdatedEvent>().listen((event) {
      _searchJobs();
    });

    _fetchJobFields();
  }

  void _fetchJobFields() async {
    final result = await JobService().getFilterOptions();
    final data = result['data'];
    if (data == null) return;

    if (mounted) {
      setState(() {
        jobFields = (data['job_fields'] as List)
            .map(
              (e) => {
                'id': int.tryParse(e['id'].toString()) ?? 0,
                'name': e['name'].toString(),
              },
            )
            .toList();
      });
    }
  }

  void _searchJobs() async {
    final result = await JobService().searchJobs(
      userId: UserSession.userId!,
      keyword: keyword,
      companyName: filters['company_name'],
      location: filters['work_location'],
      fieldId: filters['field_id'],
      jobType: filters['job_type'],
      workplaceType: filters['workplace_type'],
    );

    if (result['success'] && mounted) {
      setState(() {
        jobs = result['data'];
        hasFilter = filters.entries.any(
          (entry) => entry.value != null && entry.value.toString().isNotEmpty,
        );
      });
    }
  }

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      backgroundColor: AppColors.background,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => FilterSheet(initialValues: filters),
    );

    if (result != null) {
      setState(() {
        filters = result;
        selectedJobField = result['field_id'];
      });
      _searchJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: ((value) {
                    setState(() {
                      keyword = value;
                    });
                  }),
                  onSubmitted: (_) => _searchJobs(),
                  decoration: InputDecoration(
                    hintText: "Type to search",
                    hintStyle: textTheme.labelSmall,
                    suffixIcon: Icon(Icons.search, color: AppColors.primary),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: hasFilter ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: _openFilterSheet,
                  icon: Icon(
                    Icons.tune,
                    size: 24,
                    color: hasFilter ? AppColors.surface : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                JobSearchChip(
                  label: 'All Job',
                  selected: selectedJobField == null,
                  margin: 8,
                  opTap: () {
                    setState(() {
                      selectedJobField = null;
                      filters['field_id'] = selectedJobField;
                    });
                    _searchJobs();
                  },
                ),
                ...jobFields.take(10).map((field) {
                  return JobSearchChip(
                    label: field['name'],
                    selected: selectedJobField == field['id'],
                    margin: 8,
                    opTap: () {
                      setState(() {
                        selectedJobField = (selectedJobField == field['id'])
                            ? null
                            : field['id'];
                        filters['field_id'] = selectedJobField;
                      });
                      _searchJobs();
                    },
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 24),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _searchJobs();
                await Future.delayed(Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    if (jobs.isEmpty)
                      Center(
                        child: Text("No job found", style: textTheme.bodyLarge),
                      )
                    else
                      ...jobs.map(
                        (job) => JobSearchCard(
                          logo: job['logo_url'] != null
                              ? NetworkImage(job['logo_url'])
                              : AssetImage("assets/default_avatar.png"),
                          title: job['title'],
                          company: job['company_name'],
                          location: parseLocation(
                            job['work_location'],
                          )['province']!,
                          jobType: job['job_type'],
                          salary: job['salary'],
                          isSaved: job['isSaved'],
                          onTap: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JobDetailScreen(
                                  jobId: job['id'],
                                  recruiterId: job['recruiter_id'],
                                ),
                              ),
                            );
                            if (updated) {
                              widget.onProfileUpdated();
                              _searchJobs();
                            }
                          },
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
