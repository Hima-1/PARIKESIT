import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.prefixIcon,
    this.validator,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final void Function(T?)? onChanged;
  final Widget? prefixIcon;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.sogan,
      ),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppTheme.sogan.withValues(alpha: 0.5),
      ),
      decoration: InputDecoration(labelText: label, prefixIcon: prefixIcon),
    );
  }
}
