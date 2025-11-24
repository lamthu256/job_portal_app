class Notification {
  final int id;
  final int userId;
  final Map<String, dynamic> message;
  final bool isRead;
  final String createdAt;

  Notification({
    required this.id,
    required this.userId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      message: json['message'],
      isRead: json['is_read'] == 1,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'is_read': isRead ? 1 : 0,
      'created_at': createdAt,
    };
  }
}
