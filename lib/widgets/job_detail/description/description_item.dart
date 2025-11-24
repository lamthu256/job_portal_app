import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class DescriptionItem extends StatelessWidget {
  final String label;
  final String content;

  const DescriptionItem({super.key, required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black12,
          width: 1
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.headlineSmall,),
          SizedBox(height: 8,),
          Text(content, style: textTheme.bodyMedium,)
        ],
      ),
    );
  }
}
