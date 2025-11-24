import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class TextFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;
  final String? validText;

  const TextFieldForm({
    super.key,
    required this.controller,
    this.label = '',
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.validText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != '' ? Text(label, style: textTheme.titleLarge) : SizedBox(),
        label != '' ? SizedBox(height: 6) : SizedBox(),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.labelSmall,
            filled: true,
            fillColor: AppColors.surface,
          ),
          enabled: enabled,
          validator: (value) =>
          value!.isEmpty ? validText : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
