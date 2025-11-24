import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class NumberPickerField extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int>? onChanged;

  const NumberPickerField({super.key, this.initialValue = 1, this.onChanged});

  @override
  State<NumberPickerField> createState() => _NumberPickerFieldState();
}

class _NumberPickerFieldState extends State<NumberPickerField> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue < 1 ? 1 : widget.initialValue;
  }

  void _update(int newValue) {
    if (newValue < 1) return;
    setState(() => value = newValue);
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 48,
      margin: EdgeInsets.only(top: 6, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text('$value', style: textTheme.bodyLarge),
          const Spacer(),
          _button(Icons.remove, () => _update(value - 1)),
          _divider(),
          _button(Icons.add, () => _update(value + 1)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 20,
    color: AppColors.hint,
    margin: const EdgeInsets.symmetric(horizontal: 8),
  );

  Widget _button(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 32,
      height: 32,
      child: Icon(icon, size: 20, color: AppColors.hint),
    ),
  );
}

