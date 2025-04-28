import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Color controlBackgroundColor = Colors.black54;
const EdgeInsets controlPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
const double iconSize = 40.0;
const Color iconColor = Colors.white;

Widget videoControls({
  required VideoPlayerController controller,
  required VoidCallback onRewind,
  required VoidCallback onPlayPause,
  required VoidCallback onForward,
  required VoidCallback onFullScreen,
  required VoidCallback onSaveVideo,
  required bool isPlaying,
}) {
  return Container(
    color: Colors.black54,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Image.asset('assets/Botones/left.png', height: 40), // Ahora PNG
          onPressed: onRewind,
        ),
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 40,
            color: Colors.white,
          ),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: Image.asset('assets/Botones/right.png', height: 40), // Ahora PNG
          onPressed: onForward,
        ),
        IconButton(
          icon: const Icon(Icons.fullscreen, size: 40, color: Colors.white),
          onPressed: onFullScreen,
        ),
      ],
    ),
  );
}