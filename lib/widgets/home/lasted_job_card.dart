import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class LastedJobCard extends StatelessWidget {
  final ImageProvider logo;
  final String title;
  final double rating;
  final String location;
  final String jobType;
  final VoidCallback onTap;

  const LastedJobCard({
    super.key,
    required this.logo,
    required this.title,
    required this.rating,
    required this.location,
    required this.jobType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.only(right: 12),
        width: 170,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            Center(
              child: ClipOval(
                child: Image(
                  image: logo,
                  width: 70,
                  height: 70,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(height: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                  SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textPrimary,
                      ),
                      Text(
                        location,
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Job Type + Rating
                  Row(
                    children: [
                      Text(
                        jobType,
                        style: textTheme.bodySmall!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 2),
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

            // Job Info
          ],
        ),
      ),
    );
  }
}
