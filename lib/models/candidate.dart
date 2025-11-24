class Candidate {
  final int userId;
  final String fullName;
  final String? phone;
  final String? location;
  final String? jobTitle;
  final String? summary;
  final String? experience;
  final String? avatarUrl;
  final String? email;
  final int? totalApplication;

  Candidate({
    required this.userId,
    required this.fullName,
    this.phone,
    this.location,
    this.jobTitle,
    this.summary,
    this.experience,
    this.avatarUrl,
    this.email,
    this.totalApplication,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      userId: int.parse(json['user_id'].toString()),
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      jobTitle: json['job_title'] ?? '',
      summary: json['summary'] ?? '',
      experience: json['experience'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      email: json['email'] ?? '',
      totalApplication: json['total_application'] != null
          ? int.parse(json['total_application'].toString())
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'location': location,
      'job_title': jobTitle,
      'summary': summary,
      'experience': experience,
      'avatar_url': avatarUrl,
    };
  }
}
