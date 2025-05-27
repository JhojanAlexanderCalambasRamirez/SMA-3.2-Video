import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'decision_button.dart';

const double iconSize = 40.0;

/// Widget principal de controles personalizados de video.
Widget videoControls({
  required VideoPlayerController controller,
  required VoidCallback onRewind,
  required VoidCallback onPlayPause,
  required VoidCallback onForward,
  required bool isPlaying,
}) {
  return Container(
    width: double.infinity,
    height: 90,
    padding: const EdgeInsets.symmetric(horizontal: 30),
    color: const Color.fromARGB(137, 0, 0, 0),
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

/// Panel con dos botones de decisión estilizados igual que el de controles.
Widget decisionButtonsPanel({
  required String leftText,
  required String rightText,
  required VoidCallback onLeftTap,
  required VoidCallback onRightTap,
}) {
  return Container(
    width: double.infinity,
    height: 90,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    color: const Color.fromARGB(137, 0, 0, 0),
    child: Row(
      children: [
        Expanded(
          child: DecisionButton(text: leftText, onTap: onLeftTap),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DecisionButton(text: rightText, onTap: onRightTap),
        ),
      ],
    ),
  );
}
