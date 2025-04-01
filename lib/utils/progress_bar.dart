import 'package:flutter/material.dart';

Widget narrativeProgressBar({
  required int positiveCount,
  required int negativeCount,
}) {
  // Solo consideramos decisiones tomadas en Escena3, Escena4 y Escena5
  int relevantTotal = (positiveCount + negativeCount).clamp(0, 3);
  double progress = relevantTotal == 0 ? 0.0 : (positiveCount.clamp(0, 3) / 3);

  Color color;
  if (positiveCount >= 3) {
    color = Colors.yellow;
  } else if (negativeCount >= 3) {
    color = Colors.red;
  } else {
    color = Colors.blue;
  }

  return Positioned(
    top: 40,
    left: 20,
    right: 20,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: 10,
        backgroundColor: Colors.grey.shade800,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    ),
  );
}
