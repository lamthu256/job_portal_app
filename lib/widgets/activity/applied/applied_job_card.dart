import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class AppliedJobCard extends StatelessWidget {
  final ImageProvider logo;
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String salary;
  final List<ProgressStep> progressSteps;
  final VoidCallback onTap;

  const AppliedJobCard({
    super.key,
    required this.logo,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.salary,
    required this.progressSteps,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Info
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
              ],
            ),
            SizedBox(height: 10),
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
            const SizedBox(height: 16),

            // Progress title
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Progress",
                        style: textTheme.bodyLarge!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.expand_more, size: 20),
                    ],
                  ),
                  Divider(height: 20),

                  // Progress Steps
                  Column(
                    children: List.generate(progressSteps.length, (index) {
                      final step = progressSteps[index];
                      final isLast = index == progressSteps.length - 1;
                      return ProgressStepWidget(step: step, showLine: !isLast);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressStep {
  final String title;
  final String date;
  final bool completed;

  const ProgressStep({
    required this.title,
    required this.date,
    required this.completed,
  });
}

class ProgressStepWidget extends StatelessWidget {
  final ProgressStep step;
  final bool showLine;

  const ProgressStepWidget({
    super.key,
    required this.step,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: textTheme.bodyMedium),
                Text(
                  step.date,
                  style: textTheme.bodySmall!.copyWith(color: AppColors.hint),
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Icon(
              step.completed ? Icons.check_circle : Icons.cancel,
              color: step.completed ? Colors.green : Colors.red,
              size: 20,
            ),
            if (showLine)
              Container(width: 2, height: 32, color: Colors.grey.shade300),
          ],
        ),
      ],
    );
  }
}
