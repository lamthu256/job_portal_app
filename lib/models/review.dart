class Review {
  final int id;
  final int userId;
  final int jobId;
  final int rating;
  final String content;
  final String status;
  final String createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.jobId,
    required this.rating,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      jobId: int.parse(json['job_id'].toString()),
      rating: int.parse(json['rating'].toString()),
      content: json['content'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'job_id': jobId,
      'rating': rating,
      'content': content,
      'status': status,
      'created_at': createdAt,
    };
  }
}
