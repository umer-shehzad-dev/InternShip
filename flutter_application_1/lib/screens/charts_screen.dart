import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/unit_converter.dart';
import '../providers/settings_provider.dart';
import '../widgets/glucose_chart.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  ChartPeriod _period = ChartPeriod.days7;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final readingsProvider = context.watch<ReadingsProvider>();
    final periodReadings =
        readingsProvider.getReadingsForPeriod(_period.days);

    return Scaffold(
      appBar: AppBar(title: const Text('Charts & Stats')),
      body: RefreshIndicator(
        onRefresh: readingsProvider.loadReadings,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SegmentedButton<ChartPeriod>(
              segments: ChartPeriod.values
                  .map(
                    (period) => ButtonSegment(
                      value: period,
                      label: Text(period.label),
                    ),
                  )
                  .toList(),
              selected: {_period},
              onSelectionChanged: (value) {
                setState(() => _period = value.first);
              },
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GlucoseChart(
                  readings: periodReadings,
                  period: _period,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder(
              future: readingsProvider.getStatsForPeriod(
                _period.days,
                lowTarget: settings.lowTarget,
                highTarget: settings.highTarget,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final stats = snapshot.data!;
                if (stats.count == 0) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Add readings to see statistics.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Average',
                            value:
                                '${UnitConverter.formatValue(stats.average, settings.unit)} ${settings.unit.label}',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'In Range',
                            value: '${stats.inRangePercent.toStringAsFixed(0)}%',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            label: 'Lowest',
                            value:
                                '${UnitConverter.formatValue(stats.minimum, settings.unit)} ${settings.unit.label}',
                            color: AppColors.low,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            label: 'Highest',
                            value:
                                '${UnitConverter.formatValue(stats.maximum, settings.unit)} ${settings.unit.label}',
                            color: AppColors.high,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

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
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
