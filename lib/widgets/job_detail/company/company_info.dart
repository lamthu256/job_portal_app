import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class CompanyInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const CompanyInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.hint),
          SizedBox(width: 4),
          Text(
            label,
            style: textTheme.bodySmall!.copyWith(color: AppColors.hint),
          ),
          SizedBox(width: 4),
          Text(text, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
