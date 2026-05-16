import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      icon: Icon(
        LucideIcons.chevronDown,
        color: scheme.onSurface.withValues(alpha: 0.5),
      ),
      decoration: InputDecoration(labelText: label, prefixIcon: prefixIcon),
    );
  }
}
