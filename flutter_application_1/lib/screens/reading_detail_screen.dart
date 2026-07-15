import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/unit_converter.dart';
import '../providers/settings_provider.dart';
import '../services/analysis_service.dart';
import '../widgets/status_badge.dart';
import 'add_reading_screen.dart';

class ReadingDetailScreen extends StatelessWidget {
  const ReadingDetailScreen({super.key, required this.readingId});

  final int readingId;

  @override
  Widget build(BuildContext context) {
    final readings = context.watch<ReadingsProvider>();
    final settings = context.watch<SettingsProvider>();
    final matches =
        readings.readings.where((item) => item.id == readingId).toList();

    if (matches.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reading Detail')),
        body: const Center(
          child: Text(
            'Reading not found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final reading = matches.first;

    final status = AnalysisService.getStatus(
      reading.valueMgDl,
      lowTarget: settings.lowTarget,
      highTarget: settings.highTarget,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddReadingScreen(reading: reading),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${UnitConverter.formatValue(reading.valueMgDl, settings.unit)} ${settings.unit.label}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AnalysisService.colorForStatus(status),
                        ),
                      ),
                      const Spacer(),
                      StatusBadge(status: status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    DateFormat('EEEE, MMM d, yyyy • HH:mm')
                        .format(reading.recordedAt),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AnalysisService.getAdvice(status),
                    style: const TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (reading.conditions.isNotEmpty) ...[
            const Text(
              'Conditions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: reading.conditions
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
          if (reading.notes.isNotEmpty) ...[
            const Text(
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  reading.notes.map((tag) => Chip(label: Text(tag))).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
