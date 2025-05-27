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

    Color fillColor;
    if (positiveCount >= 3) {
      fillColor = const Color(0xFFFFD600);
    } else if (negativeCount >= 3) {
      fillColor = const Color(0xFFE53935); 
    } else {
      fillColor = const Color(0xFF1E88E5);
    }

    return Positioned(
      top: 30,
      left: 10,
      child: SizedBox(
        width: 36,
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/Extras/Barra_Progreso.png',
              fit: BoxFit.fill,
              width: 36,
              height: 200,
            ),
            Positioned(
              bottom: 4, // margen interno inferior
              left: 7,   // alineación con borde blanco
              right: 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: (182 * progress).clamp(0, 182),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//NOTAS PARA MEJORAR LA UI

//Detalles clave:

//bottom: 4 y height: 182 aseguran que el borde inferior del progreso llegue hasta el borde blanco exacto.

//left/right: 8 centran el grosor de la barra en el canal blanco interior.

//Puedes ajustar a left: 7 o right: 9 si algún borde se ve ligeramente desplazado.