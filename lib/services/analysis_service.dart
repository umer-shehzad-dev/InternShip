import 'package:flutter/material.dart';

import '../core/constants/glucose_ranges.dart';
import '../core/theme/app_theme.dart';

class AnalysisService {
  static GlucoseStatus getStatus(
    double valueMgDl, {
    required double lowTarget,
    required double highTarget,
  }) {
    if (valueMgDl < lowTarget) return GlucoseStatus.low;
    if (valueMgDl > highTarget) return GlucoseStatus.high;
    return GlucoseStatus.normal;
  }

  static String getAdvice(GlucoseStatus status) {
    switch (status) {
      case GlucoseStatus.low:
        return 'Your reading is below target. Consider a fast-acting carbohydrate and monitor closely.';
      case GlucoseStatus.normal:
        return 'Your reading is within the target range. Keep up your current routine.';
      case GlucoseStatus.high:
        return 'Your reading is above target. Review recent meals, activity, and medication timing.';
    }
  }

  static Color colorForStatus(GlucoseStatus status) {
    switch (status) {
      case GlucoseStatus.low:
        return AppColors.low;
      case GlucoseStatus.normal:
        return AppColors.normal;
      case GlucoseStatus.high:
        return AppColors.high;
    }
  }
}
