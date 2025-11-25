import 'package:flutter/material.dart';

class EditProfileField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;
  final bool isRequired;

  const EditProfileField({
    super.key,
    required this.label,
    this.hint = "",
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.titleLarge),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.labelLarge,
          ),
          maxLines: maxLines,
          keyboardType: keyboardType,
          controller: controller,
          enabled: enabled,
          validator: isRequired
              ? (value) => (value == null || value.isEmpty)
                    ? "Please enter $label"
                    : null
              : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
