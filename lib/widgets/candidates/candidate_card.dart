import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class CandidateCard extends StatelessWidget {
  final ImageProvider avatar;
  final applyCount;
  final String name, position, location;
  final VoidCallback? onTap;

  const CandidateCard({
    super.key,
    required this.avatar,
    required this.name,
    required this.position,
    required this.location,
    required this.applyCount,
    this.onTap,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(backgroundImage: avatar),
                SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + More icon
                      Row(
                        children: [
                          Text(
                            name,
                            style: textTheme.headlineSmall!.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        position,
                        style: textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        softWrap: false,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 13,
                            color: AppColors.textPrimary,
                          ),
                          Text(
                            location != '' ? location : "Unknown",
                            style: textTheme.bodySmall!.copyWith(
                              height: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "$applyCount Applies",
                      style: textTheme.bodySmall!.copyWith(
                        height: 1,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
