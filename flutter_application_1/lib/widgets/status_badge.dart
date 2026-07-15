import 'package:flutter/material.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final GlucoseStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      GlucoseStatus.low => AppColors.low,
      GlucoseStatus.normal => AppColors.normal,
      GlucoseStatus.high => AppColors.high,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
