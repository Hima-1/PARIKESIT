import 'package:flutter/material.dart';
import 'package:parikesit/core/theme/app_spacing.dart';
import 'package:parikesit/core/theme/app_theme.dart';
import 'package:parikesit/core/widgets/ethno_button.dart';

class DynamicAspectFields extends StatelessWidget {
  const DynamicAspectFields({
    super.key,
    required this.controllers,
    required this.onAdd,
    required this.onRemove,
  });

  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...controllers.asMap().entries.map(
          (entry) => _AspectFieldRow(
            key: ValueKey(entry.value),
            index: entry.key,
            controller: entry.value,
            canRemove: controllers.length > 1,
            onRemove: () => onRemove(entry.key),
          ),
        ),
        AppSpacing.gapH8,
        EthnoButton(
          onPressed: onAdd,
          icon: Icons.add,
          label: 'Tambah Aspek',
          style: EthnoButtonStyle.outlined,
        ),
      ],
    );
  }
}

class _AspectFieldRow extends StatelessWidget {
  const _AspectFieldRow({
    super.key,
    required this.index,
    required this.controller,
    required this.canRemove,
    required this.onRemove,
  });

  final int index;
  final TextEditingController controller;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nama Aspek ${index + 1}',
                hintText: 'Masukkan nama aspek',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.neutral),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.sogan, width: 2),
                ),
              ),
            ),
          ),
          if (canRemove)
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: AppTheme.error,
              ),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
