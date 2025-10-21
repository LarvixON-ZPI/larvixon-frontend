import 'dart:ui';
import 'package:flutter/material.dart' show Colors;

extension ColorGradientExtension on Color {
  static Color gradient({
    required double score,
    Color? minColor = Colors.red,
    Color? middleColor = Colors.orange,
    Color? maxColor = Colors.green,
  }) {
    if (middleColor == null) {
      return Color.lerp(minColor, maxColor, score)!;
    }

    if (score < 0.5) {
      return Color.lerp(minColor, middleColor, score / 0.5)!;
    } else {
      return Color.lerp(middleColor, maxColor, (score - 0.5) / 0.5)!;
    }
  }
}
