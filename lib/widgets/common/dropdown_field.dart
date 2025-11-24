import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class DropdownField extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const DropdownField({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        value: selectedValue,
        hint: Text(hint, style: textTheme.labelSmall),
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: textTheme.bodyLarge),
          );
        }).toList(),
        onChanged: onChanged,
        iconStyleData: IconStyleData(iconEnabledColor: AppColors.hint),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 250,
          width: MediaQuery.of(context).size.width - 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          offset: const Offset(0, -4),
        ),
        menuItemStyleData: MenuItemStyleData(
          selectedMenuItemBuilder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: child,
            );
          },
        ),
        validator: validator,
      ),
    );
  }
}
