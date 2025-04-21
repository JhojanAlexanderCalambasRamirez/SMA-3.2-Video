import 'package:flutter/material.dart';

Widget narrativeProgressBar({
  required int positiveCount,
  required int negativeCount,
}) {
  int totalDecisions = (positiveCount + negativeCount).clamp(0, 3);
  double progress = totalDecisions / 3;

  Color color;
  if (positiveCount >= 3) {
    color = Colors.green;
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
        value: progress,
        minHeight: 10,
        backgroundColor: Colors.grey.shade800,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    ),
  );
}
