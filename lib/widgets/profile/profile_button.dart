import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ProfileButton extends StatelessWidget {
  final String count;
  final String label;

  const ProfileButton({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count,
              style: textTheme.labelMedium!.copyWith(fontWeight: FontWeight.bold)
            ),
            SizedBox(width: 4),
            Text(label, style: textTheme.labelMedium,),
          ],
        ),
      ),
    );
  }
}
