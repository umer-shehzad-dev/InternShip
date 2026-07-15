import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/unit_converter.dart';
import '../models/blood_sugar_reading.dart';
import '../providers/settings_provider.dart';

class GlucoseChart extends StatelessWidget {
  const GlucoseChart({
    super.key,
    required this.readings,
    required this.period,
  });

  final List<BloodSugarReading> readings;
  final ChartPeriod period;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    if (readings.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Text(
            'No data for this period',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final spots = readings.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        UnitConverter.displayValue(entry.value.valueMgDl, settings.unit),
      );
    }).toList();

    final values = spots.map((spot) => spot.y).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final lowLine = UnitConverter.displayValue(settings.lowTarget, settings.unit);
    final highLine =
        UnitConverter.displayValue(settings.highTarget, settings.unit);

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: (minY - 10).clamp(0, double.infinity),
          maxY: maxY + 20,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.border,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(settings.unit == GlucoseUnit.mgDl ? 0 : 1),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: (readings.length / 4).clamp(1, 999).toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= readings.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('M/d').format(readings[index].recordedAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: lowLine,
                color: AppColors.low.withValues(alpha: 0.6),
                strokeWidth: 1,
                dashArray: [6, 4],
              ),
              HorizontalLine(
                y: highLine,
                color: AppColors.high.withValues(alpha: 0.6),
                strokeWidth: 1,
                dashArray: [6, 4],
              ),
            ],
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.teal,
              barWidth: 3,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, bar, index) {
                  final valueMgDl = readings[index].valueMgDl;
                  final color = valueMgDl < settings.lowTarget
                      ? AppColors.low
                      : valueMgDl > settings.highTarget
                          ? AppColors.high
                          : AppColors.normal;
                  return FlDotCirclePainter(
                    radius: 4,
                    color: color,
                    strokeWidth: 1,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.teal.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
