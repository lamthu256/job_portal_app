import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class PostedJobCard extends StatelessWidget {
  final String title;
  final String createdAt;
  final String salary;
  final double rating;
  final String location;
  final String jobType;
  final String workplaceType;
  final int candidate;
  final int interview;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isBackground;

  const PostedJobCard({
    super.key,
    required this.title,
    required this.createdAt,
    required this.salary,
    required this.rating,
    required this.location,
    required this.jobType,
    required this.workplaceType,
    required this.candidate,
    required this.interview,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.isBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.45,
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              icon: Icons.edit,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              icon: Icons.delete,
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isBackground ? AppColors.surface : AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  decoration: BoxDecoration(
                    color: isBackground ? AppColors.background : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.headlineSmall!.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.more_vert,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textPrimary,
                          ),
                          Text(
                            location,
                            style: textTheme.bodySmall!.copyWith(height: 1),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppColors.textPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            createdAt,
                            style: textTheme.bodySmall!.copyWith(height: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildTag(context, salary),
                          _buildTag(context, jobType),
                          _buildTag(context, workplaceType),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$candidate Candidate",
                            style: textTheme.bodyMedium!.copyWith(
                              color: AppColors.hint,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 3,
                            height: 3,
                            decoration: const BoxDecoration(
                              color: AppColors.hint,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            "$interview Interviewed",
                            style: textTheme.bodyMedium!.copyWith(
                              color: AppColors.hint,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: isBackground ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(text, style: textTheme.bodySmall),
    );
  }
}
