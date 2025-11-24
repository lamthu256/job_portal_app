import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // gradient: const LinearGradient(
        //   colors: [AppColors.primary, AppColors.secondary],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        color: AppColors.textPrimary
      ),
      child: Row(
        children: [
          Icon(Icons.tips_and_updates, size: 48, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Interview Tips',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Get ready with top interview tips for tech jobs.',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
