import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;
  final bool? isPrimary;

  const DetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.text,
    this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.hint, size: 20),
          SizedBox(width: 6),
          Text(label, style: textTheme.labelSmall),
          Spacer(),
          Text(
            text,
            style: textTheme.titleMedium!.copyWith(
              color: (isPrimary == true)
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
