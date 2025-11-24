class Application {
  final int id;
  final int jobId;
  final int candidateId;
  final String? resumeUrl;
  final String? introduction;
  final String? status;
  final String? appliedAt;
  final String? viewedAt;
  final String? interviewingAt;
  final String? acceptedAt;
  final String? rejectedAt;

  // Job
  final String title;
  final String? salary;
  final String? jobType;
  final String? workLocation;

  // Recruiter
  final int? recruiterId;
  final String? companyName;
  final String? logoUrl;

  // Candidate
  final String? fullName;
  final String? avatarUrl;

  Application({
    required this.id,
    required this.jobId,
    required this.candidateId,
    required this.resumeUrl,
    this.introduction,
    required this.status,
    required this.appliedAt,
    this.viewedAt,
    this.interviewingAt,
    this.acceptedAt,
    this.rejectedAt,
    required this.title,
    this.salary,
    required this.jobType,
    this.workLocation,
    this.recruiterId,
    this.companyName,
    this.logoUrl,
    this.fullName,
    this.avatarUrl,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: int.parse(json['id'].toString()),
      jobId: int.parse(json['job_id'].toString()),
      candidateId: int.parse(json['candidate_id'].toString()),
      resumeUrl: json['resume_url'] ?? '',
      introduction: json['introduction'] ?? '',
      status: json['status'] ?? '',
      appliedAt: json['applied_at'] ?? '',
      viewedAt: json['viewed_at'] ?? '',
      interviewingAt: json['interviewing_at'] ?? '',
      acceptedAt: json['accepted_at'] ?? '',
      rejectedAt: json['rejected_at'] ?? '',
      title: json['title'],
      salary: json['salary'] ?? '',
      jobType: json['job_type'] ?? '',
      workLocation: json['work_location'] ?? '',
      recruiterId: json['recruiter_id'] != null
          ? int.tryParse(json['recruiter_id'].toString())
          : null,
      companyName: json['company_name'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': jobId,
      'candidate_id': candidateId,
      'resume_url': resumeUrl,
      'introduction': introduction,
      'status': status,
      'applied_at': appliedAt,
      'viewed_at': viewedAt,
      'interviewing_at': interviewingAt,
      'accepted_at': acceptedAt,
      'rejected_at': rejectedAt,
      'title': title,
      'salary': salary,
      'job_type': jobType,
      'work_location': workLocation,
      'company_name': companyName,
      'recruiter_id': recruiterId,
      'logo_url': logoUrl,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }
}
