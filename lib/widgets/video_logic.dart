import 'package:video_player/video_player.dart';

class VideoLogic {
  static Future<void> initializeVideo(
    String videoName,
    Function(VideoPlayerController) onInitialized,
  ) async {
    final controller = VideoPlayerController.asset('assets/videos/$videoName.mp4');
    await controller.initialize();
    onInitialized(controller);
    controller.play();
  }

  static bool isDecisionVideo(String name) =>
      ['Escena2', 'Escena3', 'Escena4'].contains(name);

  static bool isPathAfterDecision(String name) => [
        'Escena2_1', 'Escena2_2',
        'Escena3_1', 'Escena3_2',
        'Escena4_1', 'Escena4_2'
      ].contains(name);
}
