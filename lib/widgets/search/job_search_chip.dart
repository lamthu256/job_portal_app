import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class JobSearchChip extends StatelessWidget {
  final String label;
  final bool selected;
  final double margin;
  final VoidCallback opTap;

  const JobSearchChip({
    super.key,
    required this.label,
    this.selected = false,
    this.margin = 0.0,
    required this.opTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: opTap,
      child: Container(
        margin: EdgeInsets.only(right: margin),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.titleSmall!.copyWith(
              color: selected ? AppColors.surface : AppColors.hint,
            ),
          ),
        ),
      ),
    );
  }
}
