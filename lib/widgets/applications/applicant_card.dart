import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ApplicationCard extends StatelessWidget {
  final String title;
  final String candidateName;
  final String appliedAt;
  final String status;
  final bool isBackground;
  final VoidCallback onTap;

  const ApplicationCard({
    super.key,
    required this.title,
    required this.candidateName,
    required this.appliedAt,
    required this.status,
    required this.isBackground,
    required this.onTap,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade100;
      case 'rejected':
        return Colors.red.shade100;
      case 'interviewing':
        return Colors.blue.shade100;
      case 'pending':
      default:
        return Colors.orange.shade100;
    }
  }

  Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade800;
      case 'rejected':
        return Colors.red.shade800;
      case 'interviewing':
        return Colors.blue.shade800;
      case 'pending':
      default:
        return Colors.orange.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isBackground
              ? AppColors.hint.withOpacity(0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: Title + Rating + Menu
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.headlineSmall!.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Icon(Icons.more_vert, size: 18),
              ],
            ),
            SizedBox(height: 8),
            // Row: Candidate + Code + Status
            Row(
              children: [
                Icon(Icons.account_circle, size: 18, color: Colors.grey),
                SizedBox(width: 4),
                Text(candidateName, style: textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 4),
            // Row: Date
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(appliedAt, style: textTheme.bodyMedium),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: textTheme.labelSmall!.copyWith(
                      color: getStatusTextColor(status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
