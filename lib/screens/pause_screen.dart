import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class PauseScreen extends StatelessWidget {
  final VideoPlayerController videoController;

  const PauseScreen({super.key, required this.videoController});

  Future<void> _playSound(String soundPath) async {
    final player = AudioPlayer();
    try {
      await player.play(AssetSource(soundPath.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint('Error al reproducir sonido: $e');
    }
  }

  void _resumeGame(BuildContext context) async {
    await _playSound('assets/Sounds/ButonReaunudar.mp3');
    Navigator.pop(context); // Volver al video
  }

  void _exitToHome(BuildContext context) async {
    await _playSound('assets/Sounds/ButonSalir.mp3');
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

          // Capa de oscurecimiento
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Contenido del menú
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/Textos/TituloApp.png',
                  width: 220,
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => _resumeGame(context),
                  child: Image.asset('assets/Botones/Reaunudar_Pausa.png', width: 200),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _exitToHome(context),
                  child: Image.asset('assets/Botones/Salir_Pausa.png', width: 200),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
