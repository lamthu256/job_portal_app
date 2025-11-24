import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class CompanyItem extends StatelessWidget {
  final String label;
  final Widget content;

  const CompanyItem({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black12,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.headlineSmall),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}
