import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const double iconSize = 40.0;

/// Widget principal de controles personalizados de video.
/// Este será el ÚNICO que debe usarse y mantenerse en el proyecto.
Widget videoControls({
  required VideoPlayerController controller,
  required VoidCallback onRewind,
  required VoidCallback onPlayPause,
  required VoidCallback onForward,
  required bool isPlaying,
}) {
  return Container(
    width: double.infinity, // Se extiende en todo el ancho
    height: 90, // Altura del panel
    padding: const EdgeInsets.symmetric(horizontal: 30),
    color: const Color.fromARGB(137, 0, 0, 0), // Fondo semitransparente
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Image.asset('assets/Botones/left.png', height: iconSize),
          onPressed: onRewind,
        ),
        IconButton(
          icon: Image.asset(
            isPlaying ? 'assets/Botones/Pause.png' : 'assets/Botones/Play.png',
            height: iconSize,
          ),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: Image.asset('assets/Botones/right.png', height: iconSize),
          onPressed: onForward,
        ),
      ],
    ),
  );
}
