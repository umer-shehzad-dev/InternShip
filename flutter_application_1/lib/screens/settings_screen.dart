import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/utils/unit_converter.dart';
import '../providers/settings_provider.dart';
import '../services/export_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _exportService = ExportService();
  bool _isExporting = false;

  Future<void> _export({
    required bool asPdf,
  }) async {
    final settings = context.read<SettingsProvider>();
    final readings = context.read<ReadingsProvider>();

    if (readings.readings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No readings to export')),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      if (asPdf) {
        final stats = await readings.getStatsForPeriod(
          90,
          lowTarget: settings.lowTarget,
          highTarget: settings.highTarget,
        );
        await _exportService.exportPdf(
          readings: readings.readings,
          unit: settings.unit,
          stats: stats,
        );
      } else {
        await _exportService.exportCsv(
          readings: readings.readings,
          unit: settings.unit,
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _editTarget({
    required String title,
    required double currentValue,
    required Future<void> Function(double value) onSave,
  }) async {
    final settings = context.read<SettingsProvider>();
    final controller = TextEditingController(
      text: UnitConverter.formatValue(currentValue, settings.unit),
    );

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(suffixText: settings.unit.label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved != true) return;
    final value = double.tryParse(controller.text.trim());
    if (value == null) return;
    await onSave(UnitConverter.inputToMgDl(value, settings.unit));
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Units',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SegmentedButton<GlucoseUnit>(
            segments: GlucoseUnit.values
                .map(
                  (unit) => ButtonSegment(
                    value: unit,
                    label: Text(unit.label),
                  ),
                )
                .toList(),
            selected: {settings.unit},
            onSelectionChanged: (value) {
              settings.setUnit(value.first);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Target Ranges',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Low target'),
                  subtitle: Text(
                    '${UnitConverter.formatValue(settings.lowTarget, settings.unit)} ${settings.unit.label}',
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _editTarget(
                    title: 'Low Target',
                    currentValue: settings.lowTarget,
                    onSave: settings.setLowTarget,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('High target'),
                  subtitle: Text(
                    '${UnitConverter.formatValue(settings.highTarget, settings.unit)} ${settings.unit.label}',
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => _editTarget(
                    title: 'High Target',
                    currentValue: settings.highTarget,
                    onSave: settings.setHighTarget,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Export',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: const Text('Export PDF report'),
                  subtitle: const Text('Share with your doctor'),
                  onTap: _isExporting ? null : () => _export(asPdf: true),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.table_chart_outlined),
                  title: const Text('Export CSV'),
                  subtitle: const Text('Spreadsheet-friendly format'),
                  onTap: _isExporting ? null : () => _export(asPdf: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Disclaimer'),
              subtitle: const Text(
                'This app does not measure blood sugar. It only helps you track manually entered values.',
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Disclaimer'),
                    content: const Text(
                      'This app does not measure your blood sugar. It is intended only as a tracking aid to help you monitor manually entered glucose readings and manage diabetes with your healthcare provider.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
