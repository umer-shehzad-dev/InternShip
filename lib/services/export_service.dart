import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/utils/unit_converter.dart';
import '../models/blood_sugar_reading.dart';

class ExportService {
  Future<void> exportCsv({
    required List<BloodSugarReading> readings,
    required GlucoseUnit unit,
  }) async {
    final buffer = StringBuffer(
      'Date,Time,Value,Unit,Conditions,Notes\n',
    );
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    for (final reading in readings) {
      buffer.writeln([
        dateFormat.format(reading.recordedAt),
        timeFormat.format(reading.recordedAt),
        UnitConverter.formatValue(reading.valueMgDl, unit),
        unit.label,
        reading.conditions.join('; '),
        reading.notes.join('; '),
      ].map(_escapeCsv).join(','));
    }

    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'blood_sugar_report.csv'));
    await file.writeAsString(buffer.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'Blood Sugar Report');
  }

  Future<void> exportPdf({
    required List<BloodSugarReading> readings,
    required GlucoseUnit unit,
    required ReadingStats stats,
  }) async {
    final dateFormat = DateFormat('MMM d, yyyy HH:mm');
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Blood Sugar Report',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Generated: ${dateFormat.format(DateTime.now())}'),
          pw.SizedBox(height: 16),
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text('Total readings: ${stats.count}'),
          pw.Text(
            'Average: ${UnitConverter.formatValue(stats.average, unit)} ${unit.label}',
          ),
          pw.Text(
            'Lowest: ${UnitConverter.formatValue(stats.minimum, unit)} ${unit.label}',
          ),
          pw.Text(
            'Highest: ${UnitConverter.formatValue(stats.maximum, unit)} ${unit.label}',
          ),
          pw.Text('In range: ${stats.inRangePercent.toStringAsFixed(1)}%'),
          pw.SizedBox(height: 20),
          pw.Text(
            'Readings',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['Date', 'Value', 'Conditions', 'Notes'],
            data: readings.map((reading) {
              return [
                dateFormat.format(reading.recordedAt),
                '${UnitConverter.formatValue(reading.valueMgDl, unit)} ${unit.label}',
                reading.conditions.join(', '),
                reading.notes.join(', '),
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'Disclaimer: This app does not measure blood sugar. Values are manually entered for tracking purposes only.',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, 'blood_sugar_report.pdf'));
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)], text: 'Blood Sugar Report');
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
