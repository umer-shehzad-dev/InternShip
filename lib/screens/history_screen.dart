import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../models/blood_sugar_reading.dart';
import '../providers/settings_provider.dart';
import '../widgets/reading_card.dart';
import 'reading_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final readings = context.watch<ReadingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: readings.isLoading
          ? const Center(child: CircularProgressIndicator())
          : readings.readings.isEmpty
              ? const Center(
                  child: Text(
                    'No readings recorded yet',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: readings.loadReadings,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: _buildGroupedList(context, readings),
                  ),
                ),
    );
  }

  List<Widget> _buildGroupedList(
    BuildContext context,
    ReadingsProvider provider,
  ) {
    final grouped = <String, List<BloodSugarReading>>{};
    final now = DateTime.now();

    for (final reading in provider.readings) {
      final key = _groupLabel(reading.recordedAt, now);
      grouped.putIfAbsent(key, () => []).add(reading);
    }

    final widgets = <Widget>[];
    grouped.forEach((label, items) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.teal,
            ),
          ),
        ),
      );
      widgets.addAll(
        items.map(
          (reading) => ReadingCard(
            reading: reading,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReadingDetailScreen(readingId: reading.id!),
                ),
              );
            },
            onDelete: () async {
              await provider.deleteReading(reading.id!);
            },
          ),
        ),
      );
    });
    return widgets;
  }

  String _groupLabel(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final readingDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(readingDay).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(date);
  }
}
