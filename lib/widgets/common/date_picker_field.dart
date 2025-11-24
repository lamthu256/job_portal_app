import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final String label;
  final String? validText;
  final void Function(DateTime)? onDateChanged;

  const DatePickerField({
    super.key,
    this.initialDate,
    required this.label,
    this.validText,
    this.onDateChanged,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = TextEditingController(
      text: _selectedDate != null ? _formatDate(_selectedDate!) : '',
    );
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _formatDate(picked);
        widget.onDateChanged?.call(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: textTheme.titleLarge),
        const SizedBox(height: 6),
        TextFormField(
          controller: _controller,
          readOnly: true,
          onTap: _pickDate,
          decoration: InputDecoration(
            hintText: 'yyyy-MM-dd',
            hintStyle: textTheme.labelSmall,
            suffixIcon: Icon(
              Icons.calendar_today,
              size: 20,
              color: AppColors.hint,
            ),
          ),
          validator: (value) => value!.isEmpty ? widget.validText : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
