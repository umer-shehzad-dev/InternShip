import '../constants/glucose_ranges.dart';

class UnitConverter {
  static const mmolConversionFactor = 18.0182;

  static double mgDlToMmol(double mgDl) => mgDl / mmolConversionFactor;

  static double mmolToMgDl(double mmol) => mmol * mmolConversionFactor;

  static double displayValue(double valueMgDl, GlucoseUnit unit) {
    return unit == GlucoseUnit.mgDl ? valueMgDl : mgDlToMmol(valueMgDl);
  }

  static String formatValue(double valueMgDl, GlucoseUnit unit) {
    final value = displayValue(valueMgDl, unit);
    return unit == GlucoseUnit.mgDl
        ? value.round().toString()
        : value.toStringAsFixed(1);
  }

  static String unitLabel(GlucoseUnit unit) => unit.label;

  static double inputToMgDl(double input, GlucoseUnit unit) {
    return unit == GlucoseUnit.mgDl ? input : mmolToMgDl(input);
  }
}
