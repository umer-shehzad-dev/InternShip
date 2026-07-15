import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/unit_converter.dart';
import '../models/blood_sugar_reading.dart';
import '../providers/settings_provider.dart';
import '../services/analysis_service.dart';
import 'status_badge.dart';

class ReadingCard extends StatelessWidget {
  const ReadingCard({
    super.key,
    required this.reading,
    this.onTap,
    this.onDelete,
  });

  final BloodSugarReading reading;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final status = AnalysisService.getStatus(
      reading.valueMgDl,
      lowTarget: settings.lowTarget,
      highTarget: settings.highTarget,
    );
    final statusColor = AnalysisService.colorForStatus(status);
    final tags = [...reading.conditions, ...reading.notes];

    return Dismissible(
      key: ValueKey(reading.id),
      direction: onDelete != null ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.high.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.high),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${UnitConverter.formatValue(reading.valueMgDl, settings.unit)} ${settings.unit.label}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          StatusBadge(status: status),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('MMM d, yyyy • HH:mm').format(reading.recordedAt),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          tags.join(' • '),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
