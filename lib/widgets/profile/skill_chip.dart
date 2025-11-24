import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
          child: Text(label, style: textTheme.titleSmall)),
    );
  }
}
