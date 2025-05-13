import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Color controlBackgroundColor = Color.fromARGB(116, 0, 0, 0);
const EdgeInsets controlPadding = EdgeInsets.symmetric(vertical: 14, horizontal: 50);
const double iconSize = 40.0;

Widget videoControls({
  required VideoPlayerController controller,
  required VoidCallback onRewind,
  required VoidCallback onPlayPause,
  required VoidCallback onForward,
  required bool isPlaying,
}) {
  return Container(
    width: double.infinity,
    height: 80,
    color: controlBackgroundColor,
    padding: controlPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Image.asset('assets/Botones/left.png', height: iconSize),
          onPressed: onRewind,
        ),
        IconButton(
          icon: Image.asset(
            isPlaying
                ? 'assets/Botones/Pause.png'
                : 'assets/Botones/Play.png',
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
