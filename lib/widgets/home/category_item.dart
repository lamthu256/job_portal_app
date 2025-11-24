import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/job_search');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            SizedBox(height: 8),
            Text(label, style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
