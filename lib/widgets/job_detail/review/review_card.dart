import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/services/user_session.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ReviewCard extends StatelessWidget {
  final ImageProvider avatar;
  final String name;
  final int rating;
  final String content;
  final String status;
  final String createdAt;
  final Function()? onDelete;

  const ReviewCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.rating,
    required this.content,
    required this.createdAt,
    required this.status,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final role = UserSession.role;
    final DateFormat formatter = DateFormat('MMMM d, y');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name/Rating + Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundImage: avatar, radius: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        Text(formatter.format(DateTime.parse(createdAt)), style: textTheme.bodySmall),
                      ]
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Content
          Text(content, style: textTheme.bodyMedium),

          if (role == 'recruiter') ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: onDelete,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Delete',
                            style: TextStyle(color: AppColors.surface),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
      ),
    );
  }
}
