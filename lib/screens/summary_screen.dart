import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';

class SummaryScreen extends StatelessWidget {
  final controller = DecisionFlowController();

  SummaryScreen({super.key});

  String _getMessage() {
    final lastVideo = controller.currentNode.videoName;
    debugPrint('Último video reproducido: $lastVideo');

    String message;
    switch (lastVideo) {
      case 'FinalBueno':
        message = '¡Felicidades! Tomaste buenas decisiones que ayudaron a Timeron a fortalecerse.';
        debugPrint('Mensaje generado: $message');
        break;
      case 'FinalMalo':
        message = 'Timeron cayó bajo la influencia de los Espíritus de la Miseria.';
        debugPrint('Mensaje generado: $message');
        break;
      case 'FinalNeutro':
        message = 'Timeron tuvo altibajos, pero continúa su lucha con esperanza.';
        debugPrint('Mensaje generado: $message');
        break;
      default:
        message = 'Gracias por participar en la historia de Timeron.';
        debugPrint('Mensaje generado: $message');
        break;
    }

    return message;
  }

  @override
  Widget build(BuildContext context) {
    final message = _getMessage();
    debugPrint('Generando la pantalla de resumen con el mensaje: $message');

    return Scaffold(
      appBar: AppBar(title: const Text('Resumen Final')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.replay),
              label: const Text('Reiniciar Historia'),
              onPressed: () {
                debugPrint('Reiniciando la historia...');
                controller.reset();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
