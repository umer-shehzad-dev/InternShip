import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

class TagSelector extends StatelessWidget {
  const TagSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.onAddCustom,
  });

  final String title;
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final VoidCallback? onAddCustom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (onAddCustom != null) ...[
              const Spacer(),
              TextButton.icon(
                onPressed: onAddCustom,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (value) {
                final updated = List<String>.from(selected);
                if (value) {
                  updated.add(option);
                } else {
                  updated.remove(option);
                }
                onChanged(updated);
              },
              selectedColor: AppColors.accent.withValues(alpha: 0.25),
              checkmarkColor: AppColors.accent,
            );
          }).toList(),
        ),
      ],
    );
  }
}
