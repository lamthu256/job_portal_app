class Job {
  final int id;
  final int recruiterId;
  final String title;
  final String? salary;
  final String jobType;
  final String workplaceType;
  final String? experience;
  final int? vacancyCount;
  final int? fieldId;
  final String? jobDescription;
  final String? requirements;
  final String? interest;
  final String? workLocation;
  final String? workingTime;
  final String? deadline;
  final String jobStatus;

  // Recruiter
  final String createdAt;
  final String? companyName;
  final String? logoUrl;

  // Job Saved
  final bool isSaved;

  // Reviews
  final double? avgRating;

  // Applicants
  final int? totalApplicants;
  final int? interviewingCount;

  Job({
    required this.id,
    required this.recruiterId,
    required this.title,
    this.salary,
    required this.jobType,
    required this.workplaceType,
    this.experience,
    this.vacancyCount,
    this.fieldId,
    this.jobDescription,
    this.requirements,
    this.interest,
    this.workLocation,
    this.workingTime,
    this.deadline,
    required this.jobStatus,
    required this.createdAt,
    this.companyName,
    this.logoUrl,
    required this.isSaved,
    this.avgRating,
    this.totalApplicants,
    this.interviewingCount,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: int.parse(json['id'].toString()),
      recruiterId: int.parse(json['recruiter_id'].toString()),
      title: json['title'],
      salary: json['salary'] ?? '',
      jobType: json['job_type'],
      workplaceType: json['workplace_type'],
      experience: json['experience'] ?? '',
      vacancyCount: int.parse(json['vacancy_count'].toString()),
      fieldId: json['field_id'] != null
          ? int.tryParse(json['field_id'].toString())
          : null,
      jobDescription: json['job_description'] ?? '',
      requirements: json['requirements'] ?? '',
      interest: json['interest'] ?? '',
      workLocation: json['work_location'] ?? '',
      workingTime: json['working_time'],
      deadline: json['deadline'] ?? '',
      jobStatus: json['job_status'],
      createdAt: json['created_at'],
      companyName: json['company_name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      isSaved: json['isSaved'] == 1,
      avgRating: json['avg_rating'] != null
          ? double.tryParse(json['avg_rating'].toString())
          : 0.0,
      totalApplicants: json['total_applicants'] != null
          ? int.tryParse(json['total_applicants'].toString())
          : 0,
      interviewingCount: json['interviewing_count'] != null
          ? int.tryParse(json['interviewing_count'].toString())
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recruiter_id': recruiterId,
      'title': title,
      'salary': salary,
      'job_type': jobType,
      'workplace_type': workplaceType,
      'experience': experience,
      'vacancy_count': vacancyCount,
      'field_id': fieldId,
      'job_description': jobDescription,
      'requirements': requirements,
      'interest': interest,
      'work_location': workLocation,
      'working_time': workingTime,
      'deadline': deadline,
      'job_status': jobStatus,
      'created_at': createdAt,
      'avg_rating': avgRating
    };
  }
}
