class GlucoseRanges {
  static const defaultLowTargetMgDl = 70.0;
  static const defaultHighTargetMgDl = 180.0;

  static const conditionTags = [
    'Fasting',
    'Before meal',
    'After meal',
    'Before bed',
    'Waking',
  ];

  static const noteTags = [
    'Insulin',
    'Medication',
    'Exercise',
    'Mood',
  ];
}

enum GlucoseUnit {
  mgDl('mg/dL'),
  mmolL('mmol/L');

  const GlucoseUnit(this.label);
  final String label;
}

enum GlucoseStatus {
  low('Low', 'Below target range'),
  normal('Normal', 'Within target range'),
  high('High', 'Above target range');

  const GlucoseStatus(this.label, this.description);
  final String label;
  final String description;
}

enum ChartPeriod {
  days7(7, '7 Days'),
  days30(30, '30 Days'),
  days90(90, '90 Days');

  const ChartPeriod(this.days, this.label);
  final int days;
  final String label;
}
