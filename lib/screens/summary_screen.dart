import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';

class SummaryScreen extends StatelessWidget {
  final controller = DecisionFlowController();

  SummaryScreen({super.key});

  String _getMessage() {
    if (controller.positiveCount >= 2) {
      return '¡Felicidades! Tomaste buenas decisiones que ayudaron a Timeron a fortalecerse.';
    } else if (controller.negativeCount >= 2) {
      return 'Timeron cayó bajo la influencia de los Espíritus de la Miseria.';
    } else {
      return 'Timeron tuvo altibajos, pero continúa su lucha con esperanza.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = _getMessage();

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
