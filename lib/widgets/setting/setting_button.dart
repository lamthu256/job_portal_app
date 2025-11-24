import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class SettingButton extends StatelessWidget {
  final IconData? leadingIcon;
  final String label;
  final IconData trailingIcon;
  final VoidCallback? onPressed;

  const SettingButton({
    super.key,
    required this.leadingIcon,
    required this.label,
    required this.trailingIcon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            if (leadingIcon != null)
              Icon(leadingIcon, color: AppColors.primary, size: 20),
            if (leadingIcon != null) const SizedBox(width: 12),
            Text(label, style: textTheme.bodyLarge),
            Spacer(),
            Icon(trailingIcon, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
