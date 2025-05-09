import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';

class SummaryScreen extends StatelessWidget {
  final controller = DecisionFlowController();

  SummaryScreen({super.key});

  String _getImagePath() {
    final lastVideo = controller.currentNode.videoName;
    switch (lastVideo) {
      case 'FinalBueno':
        return 'assets/Imagenes/Final_Positivo.png';
      case 'FinalMalo':
        return 'assets/Imagenes/Final_Negativo.png';
      case 'FinalNeutro':
      default:
        return 'assets/Imagenes/Final_Neutral.png';
    }
  }

  void _restartStory(BuildContext context) {
    controller.reset();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _getImagePath();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                ),
                onPressed: () => _restartStory(context),
                icon: const Icon(Icons.replay, color: Colors.white),
                label: const Text(
                  'Reiniciar Historia',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
