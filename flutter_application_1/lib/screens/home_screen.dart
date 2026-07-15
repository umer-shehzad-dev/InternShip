import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/unit_converter.dart';
import '../models/blood_sugar_reading.dart';
import '../providers/settings_provider.dart';
import '../services/analysis_service.dart';
import '../widgets/reading_card.dart';
import '../widgets/status_badge.dart';
import 'add_reading_screen.dart';
import 'reading_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final readings = context.watch<ReadingsProvider>();
    final latest = readings.latestReading;

    return Scaffold(
      appBar: AppBar(title: const Text('Blood Sugar Tracker')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddReadingScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Reading'),
      ),
      body: readings.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: readings.loadReadings,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (latest == null)
                    _EmptyHome(onAdd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddReadingScreen(),
                        ),
                      );
                    })
                  else ...[
                    _LatestReadingCard(reading: latest),
                    const SizedBox(height: 20),
                    FutureBuilder(
                      future: Future.wait([
                        readings.getTodayStats(
                          lowTarget: settings.lowTarget,
                          highTarget: settings.highTarget,
                        ),
                        readings.getStatsForPeriod(
                          7,
                          lowTarget: settings.lowTarget,
                          highTarget: settings.highTarget,
                        ),
                      ]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final todayStats = snapshot.data![0];
                        final weekStats = snapshot.data![1];

                        return Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Today Avg',
                                value: todayStats.count == 0
                                    ? '--'
                                    : '${UnitConverter.formatValue(todayStats.average, settings.unit)} ${settings.unit.label}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: '7-Day Avg',
                                value: weekStats.count == 0
                                    ? '--'
                                    : '${UnitConverter.formatValue(weekStats.average, settings.unit)} ${settings.unit.label}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Total',
                                value: '${readings.readings.length}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Recent Readings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...readings.getRecentReadings(3).map(
                          (reading) => ReadingCard(
                            reading: reading,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReadingDetailScreen(
                                    readingId: reading.id!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _LatestReadingCard extends StatelessWidget {
  const _LatestReadingCard({required this.reading});

  final BloodSugarReading reading;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final status = AnalysisService.getStatus(
      reading.valueMgDl,
      lowTarget: settings.lowTarget,
      highTarget: settings.highTarget,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Latest Reading',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  UnitConverter.formatValue(reading.valueMgDl, settings.unit),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AnalysisService.colorForStatus(status),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    settings.unit.label,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AnalysisService.getAdvice(status),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(
              Icons.water_drop_outlined,
              size: 64,
              color: AppColors.accent,
            ),
            const SizedBox(height: 16),
            const Text(
              'No readings yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap Add Reading to log your first blood sugar value.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Reading'),
            ),
          ],
        ),
      ),
    );
  }
}
