import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const double iconButtonSize = 60.0;

Widget videoControls({
  required VideoPlayerController controller,
  required VoidCallback onRewind,
  required VoidCallback onPlayPause,
  required VoidCallback onForward,
  required VoidCallback onFullScreen,
  required bool isPlaying,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildCircleButton(iconPath: 'assets/Botones/left.png', onPressed: onRewind),
      const SizedBox(width: 10),
      _buildCircleButton(
        icon: isPlaying ? Icons.pause : Icons.play_arrow,
        onPressed: onPlayPause,
      ),
      const SizedBox(width: 10),
      _buildCircleButton(iconPath: 'assets/Botones/right.png', onPressed: onForward),
      const SizedBox(width: 10),
      _buildCircleButton(
        icon: Icons.fullscreen,
        onPressed: onFullScreen,
      ),
    ],
  );
}

Widget _buildCircleButton({IconData? icon, String? iconPath, required VoidCallback onPressed}) {
  return Container(
    width: iconButtonSize,
    height: iconButtonSize,
    decoration: BoxDecoration(
      color: const Color(0xFF8BCFFF), // Azul clarito como en Figma
      shape: BoxShape.circle,
    ),
    child: IconButton(
      icon: iconPath != null
          ? Image.asset(iconPath, width: 30, height: 30)
          : Icon(icon, size: 30, color: Colors.white),
      onPressed: onPressed,
    ),
  );
}
