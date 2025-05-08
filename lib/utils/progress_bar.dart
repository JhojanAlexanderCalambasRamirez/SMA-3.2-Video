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
    final int total = (positiveCount + negativeCount).clamp(0, 3);
    final double progress = total / 3;

    // Color de progreso según las decisiones
    Color fillColor;
    if (positiveCount >= 3) {
      fillColor = const Color(0xFFFFD600); // Amarillo
    } else if (negativeCount >= 3) {
      fillColor = const Color(0xFFE53935); // Rojo
    } else {
      fillColor = const Color(0xFF1E88E5); // Azul
    }

    return Positioned(
      top: 30,
      left: 10,
      child: SizedBox(
        width: 36,
        height: 200,
        child: Stack(
          children: [
            Image.asset(
              'assets/Extras/Barra_Progreso.png',
              width: 36,
              height: 200,
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: 15, // margen interno inferior (espacio negro)
              left: 12,   // margen horizontal ajustado al borde blanco
              right: 12,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: (170 * progress).clamp(0, 170), // área entre bordes blancos
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
