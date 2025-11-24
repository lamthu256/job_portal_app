class Recruiter {
  final int userId;
  final String companyName;
  final String? description;
  final String? phone;
  final String location;
  final String? website;
  final String? size;
  final String? industry;
  final String? logoUrl;

  Recruiter({
    required this.userId,
    required this.companyName,
    this.description,
    this.phone,
    required this.location,
    this.website,
    this.size,
    this.industry,
    this.logoUrl,
  });

  factory Recruiter.fromJson(Map<String, dynamic> json) {
    return Recruiter(
      userId: int.parse(json['user_id'].toString()),
      companyName: json['company_name'] ?? '',
      description: json['description'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      website: json['website'] ?? '',
      size: json['size'] ?? '',
      industry: json['industry'] ?? '',
      logoUrl: json['logo_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'company_name': companyName,
      'description': description,
      'phone': phone,
      'location': location,
      'website': website,
      'size': size,
      'industry': industry,
      'logo_url': logoUrl,
    };
  }
}
