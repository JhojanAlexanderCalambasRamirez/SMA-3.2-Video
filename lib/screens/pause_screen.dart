import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/widgets/ImageButtonWithFeedback.dart';
import 'package:video_player/video_player.dart';

import 'decision_video_screen.dart';

class PauseScreen extends StatelessWidget {
  final VideoPlayerController videoController;

  const PauseScreen({super.key, required this.videoController});

  void _resumeGame(BuildContext context) {
    Navigator.pop(context); // Volver al video
  }

  void _exitToHome(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Frame pausado del video
          AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          ),

          // Capa de contraste oscura
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Contenido central
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título visual
                Image.asset(
                  'assets/Textos/TituloApp.png',
                  width: 220,
                ),
                const SizedBox(height: 40),
                ImageButtonWithFeedback(
                  imagePath: 'assets/Botones/Reaunudar_Pausa.png',
                  onTap: () => _resumeGame(context),
                ),
                const SizedBox(height: 20),
                ImageButtonWithFeedback(
                  imagePath: 'assets/Botones/Salir_Pausa.png',
                  onTap: () => _exitToHome(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
