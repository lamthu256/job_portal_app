import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/models/job.dart';
import 'package:job_portal_app/screens/recruiter/company_profile_screen.dart';
import 'package:job_portal_app/screens/recruiter/create_job_screen.dart';
import 'package:job_portal_app/screens/recruiter/edit_job_screen.dart';
import 'package:job_portal_app/screens/recruiter/posted_job_detail_screen.dart';
import 'package:job_portal_app/services/job_service.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';
import 'package:job_portal_app/widgets/common/parse_location.dart';
import 'package:job_portal_app/widgets/jobs/posted_job_card.dart';

class JobsScreen extends StatefulWidget {
  final String? logoUrl;
  final String companyName;
  final VoidCallback onProfileUpdated;

  const JobsScreen({
    super.key,
    this.logoUrl,
    required this.companyName,
    required this.onProfileUpdated,
  });

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String selectedStatus = 'Open';
  late int countOpen = 0;
  late int countClosed = 0;
  List<Job> jobList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobList();
  }

  void fetchJobList() async {
    final userId = UserSession.userId;

    if (userId != null) {
      final resJobList = await JobService().getJobList(userId, selectedStatus);

      if (resJobList['success']) {
        setState(() {
          // Safely parse totals with type checking
          final total = resJobList['total'];
          if (total is Map) {
            countOpen = int.tryParse(total['Open']?.toString() ?? '0') ?? 0;
            countClosed = int.tryParse(total['Closed']?.toString() ?? '0') ?? 0;
          }
          jobList = (resJobList['job_list'] as List)
              .map((job) => Job.fromJson(job))
              .toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final List<String> statusList = ['Open', 'Closed'];
    final Map<String, int> jobCount = {
      'Open': countOpen,
      'Closed': countClosed,
    };
    final DateFormat formatter = DateFormat('MMMM d, y');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.textPrimary,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CompanyProfileScreen(
                            onProfileUpdated: widget.onProfileUpdated,
                          ),
                        ),
                      );
                      if (updated) {
                        widget.onProfileUpdated();
                      }
                    },
                    child: ClipOval(
                      child: Image(
                        image: widget.logoUrl != ""
                            ? NetworkImage(widget.logoUrl!)
                            : const AssetImage("assets/default_avatar.png")
                                  as ImageProvider,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Let\'s look for candidates!',
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(color: AppColors.surface),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.companyName,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.warning),
                          maxLines: 2
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14),
            Row(
              children: [
                DropdownButton2<String>(
                  value: selectedStatus,
                  underline: SizedBox.shrink(),
                  isExpanded: false,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatus = newValue!;
                      fetchJobList();
                    });
                  },
                  style: textTheme.bodyLarge,
                  customButton: Container(
                    height: 30,
                    width: 110,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(selectedStatus),
                        SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedStatus == 'Open'
                                ? AppColors.success
                                : AppColors.error,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${jobCount[selectedStatus]}',
                            style: TextStyle(
                              color: AppColors.surface,
                              fontSize: 12,
                              height: 1,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                      ],
                    ),
                  ),
                  items: statusList.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Text(value),
                          SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            height: 16,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: value == 'Open'
                                  ? AppColors.success
                                  : AppColors.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${jobCount[value]}',
                              style: const TextStyle(
                                color: AppColors.surface,
                                fontSize: 12,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  buttonStyleData: ButtonStyleData(
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    offset: const Offset(0, -4),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CreateJobScreen()),
                    );
                    if (updated) {
                      fetchJobList();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppColors.surface, size: 18),
                        SizedBox(width: 2),
                        Text(
                          'Add New Job',
                          style: TextStyle(color: AppColors.surface),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            if (jobList.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    "No jobs found?",
                    style: textTheme.bodyLarge!.copyWith(color: AppColors.hint),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: jobList.map((job) {
                    final result = parseLocation(job.workLocation!);

                    return PostedJobCard(
                      title: job.title,
                      createdAt: formatter.format(
                        DateTime.parse(job.createdAt),
                      ),
                      salary: job.salary!,
                      rating: job.avgRating!,
                      location: result['province']!,
                      workplaceType: job.workplaceType,
                      jobType: job.jobType,
                      candidate: job.totalApplicants!,
                      interview: job.interviewingCount!,
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PostedJobDetailScreen(jobId: job.id),
                          ),
                        );
                        if (updated) {
                          fetchJobList();
                        }
                      },
                      onEdit: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditJobScreen(
                              jobData: {
                                'job_id': job.id,
                                'title': job.title,
                                'salary': job.salary,
                                'job_type': job.jobType,
                                'workplace_type': job.workplaceType,
                                'experience': job.experience,
                                'vacancy_count': job.vacancyCount,
                                'field_id': job.fieldId,
                                'job_description': job.jobDescription,
                                'requirements': job.requirements,
                                'interest': job.interest,
                                'province': result['province'],
                                'address': result['address'],
                                'working_time': job.workingTime,
                                'deadline': job.deadline,
                                'job_status': job.jobStatus,
                              },
                            ),
                          ),
                        );
                        if (updated) {
                          fetchJobList();
                        }
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            title: Text("Confirm Delete"),
                            content: Text(
                              "Are you sure you want to delete this job?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(
                                  "Cancel",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                ),
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final result = await JobService().deleteJob(
                            job.id,
                            UserSession.userId!,
                          );

                          if (result['success']) {
                            fetchJobList();
                          }
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
