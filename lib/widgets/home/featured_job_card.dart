import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class FeaturedJobCard extends StatelessWidget {
  final ImageProvider logo;
  final String title;
  final String company;
  final double rating;
  final String location;
  final String jobType;
  final String salary;
  final bool isSaved;
  final VoidCallback onTap;

  const FeaturedJobCard({
    super.key,
    required this.logo,
    required this.title,
    required this.company,
    required this.rating,
    required this.location,
    required this.jobType,
    required this.salary,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
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
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  size: 26,
                  color: isSaved ? Colors.amber : AppColors.textPrimary,
                ),
              ],
            ),
            SizedBox(height: 10),

            // Location + Job Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textPrimary,
                    ),Text(
                      location,
                      style: textTheme.bodySmall,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      jobType,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    salary,
                    style: textTheme.titleMedium!.copyWith(
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.right,
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
