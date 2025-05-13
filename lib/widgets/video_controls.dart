import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Color controlBackgroundColor = Colors.black54;
const EdgeInsets controlPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
const double iconSize = 40.0;

Widget videoControls({
  required VideoPlayerController controller,
  required VoidCallback onRewind,
  required VoidCallback onPlayPause,
  required VoidCallback onForward,
  required bool isPlaying,
}) {
  return Container(
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

class VideoControlsHelper {
  static void seek(VideoPlayerController controller, bool forward) {
    if (!controller.value.isInitialized) return;
    final pos = controller.value.position;
    final dur = controller.value.duration;
    var newPos = forward
        ? pos + const Duration(seconds: 10)
        : pos - const Duration(seconds: 10);
    if (newPos < Duration.zero) newPos = Duration.zero;
    if (newPos > dur) newPos = dur;
    controller.seekTo(newPos);
  }

  static void togglePlayPause(VideoPlayerController controller) {
    controller.value.isPlaying ? controller.pause() : controller.play();
  }
}
