import 'package:flutter/material.dart';

class NarrativeProgressBar extends StatelessWidget {
  final int positiveCount;
  final int negativeCount;

  const NarrativeProgressBar({
    super.key,
    required this.positiveCount,
    required this.negativeCount,
  });

  @override
  Widget build(BuildContext context) {
    int total = (positiveCount + negativeCount).clamp(0, 3);
    double progress = total / 3;

    Color fillColor;
    if (positiveCount >= 3) {
      fillColor = Colors.greenAccent;
    } else if (negativeCount >= 3) {
      fillColor = Colors.redAccent;
    } else {
      fillColor = Colors.blueAccent;
    }

    return Positioned(
      top: 40,
      left: 20,
      child: SizedBox(
        width: 25,
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/Extras/Barra_Progreso.png',
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: 4,
              left: 6,
              right: 6,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: (progress * 182).clamp(0, 182),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
