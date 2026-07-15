import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/unit_converter.dart';
import '../models/blood_sugar_reading.dart';
import '../providers/settings_provider.dart';
import '../widgets/tag_selector.dart';

class AddReadingScreen extends StatefulWidget {
  const AddReadingScreen({super.key, this.reading});

  final BloodSugarReading? reading;

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _valueController = TextEditingController();
  late DateTime _selectedDateTime;
  List<String> _selectedConditions = [];
  List<String> _selectedNotes = [];
  bool _isSaving = false;

  bool get _isEditing => widget.reading != null;

  @override
  void initState() {
    super.initState();
    final reading = widget.reading;
    final settings = context.read<SettingsProvider>();

    _selectedDateTime = reading?.recordedAt ?? DateTime.now();
    _selectedConditions = List.from(reading?.conditions ?? []);
    _selectedNotes = List.from(reading?.notes ?? []);

    if (reading != null) {
      _valueController.text = UnitConverter.formatValue(
        reading.valueMgDl,
        settings.unit,
      );
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _addCustomNote() async {
    final controller = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Note'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. cake, stress'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (note == null || note.trim().isEmpty || !mounted) return;
    await context.read<SettingsProvider>().addCustomNote(note);
    setState(() {
      if (!_selectedNotes.contains(note.trim())) {
        _selectedNotes = [..._selectedNotes, note.trim()];
      }
    });
  }

  Future<void> _save() async {
    final settings = context.read<SettingsProvider>();
    final readings = context.read<ReadingsProvider>();
    final value = double.tryParse(_valueController.text.trim());

    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid glucose value')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final reading = BloodSugarReading(
      id: widget.reading?.id,
      valueMgDl: UnitConverter.inputToMgDl(value, settings.unit),
      recordedAt: _selectedDateTime,
      conditions: _selectedConditions,
      notes: _selectedNotes,
      createdAt: widget.reading?.createdAt,
    );

    if (_isEditing) {
      await readings.updateReading(reading);
    } else {
      await readings.addReading(reading);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final noteOptions = [
      ...GlucoseRanges.noteTags,
      ...settings.customNotes,
    ].toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Reading' : 'Add Reading'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _valueController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: 'Glucose Value',
              suffixText: settings.unit.label,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date & Time'),
            subtitle: Text(
              '${MaterialLocalizations.of(context).formatFullDate(_selectedDateTime)} • ${TimeOfDay.fromDateTime(_selectedDateTime).format(context)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickDateTime,
          ),
          const SizedBox(height: 24),
          TagSelector(
            title: 'Condition',
            options: GlucoseRanges.conditionTags,
            selected: _selectedConditions,
            onChanged: (value) => setState(() => _selectedConditions = value),
          ),
          const SizedBox(height: 24),
          TagSelector(
            title: 'Notes',
            options: noteOptions,
            selected: _selectedNotes,
            onChanged: (value) => setState(() => _selectedNotes = value),
            onAddCustom: _addCustomNote,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: _isSaving ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: AppColors.accent,
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? 'Update Reading' : 'Save Reading'),
          ),
        ],
      ),
    );
  }
}
