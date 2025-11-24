import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class JobSearchCard extends StatelessWidget {
  final Color background;
  final ImageProvider logo;
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String salary;
  final bool? isSaved;
  final VoidCallback onTap;

  const JobSearchCard({
    super.key,
    this.background = AppColors.surface,
    required this.logo,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.salary,
    this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo + Job Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image(
                    image: logo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.headlineSmall,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      SizedBox(height: 4),
                      Text(
                        company,
                        style: textTheme.labelSmall,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
                if (isSaved != null) ...[
                  Icon(
                    isSaved! ? Icons.bookmark : Icons.bookmark_outline,
                    size: 26,
                    color: isSaved! ? Colors.amber : AppColors.textPrimary,
                  ),
                ],
              ],
            ),
            SizedBox(height: 10),

            // Location + Job Type
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: AppColors.textPrimary,
                ),
                Text(location, style: textTheme.bodySmall),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(jobType, style: textTheme.bodySmall),
                Spacer(),
                Text(
                  salary,
                  style: textTheme.titleMedium!.copyWith(
                    color: AppColors.primary,
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
