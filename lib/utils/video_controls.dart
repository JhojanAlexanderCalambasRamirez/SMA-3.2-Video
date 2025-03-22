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
}) {
  return Container(
    color: controlBackgroundColor,
    padding: controlPadding,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, size: iconSize, color: iconColor),
          onPressed: onRewind,
        ),
        IconButton(
          icon: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            size: iconSize,
            color: iconColor,
          ),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: const Icon(Icons.forward_10, size: iconSize, color: iconColor),
          onPressed: onForward,
        ),
        IconButton(
          icon: const Icon(Icons.fullscreen, size: iconSize, color: iconColor),
          onPressed: onFullScreen,
        ),
      ],
    ),
  );
}
