import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/utils/progress_bar.dart';
import 'package:flutter_application_1/screens/summary_screen.dart';
import 'package:flutter_application_1/screens/pause_screen.dart';

class DecisionVideoScreen extends StatefulWidget {
  const DecisionVideoScreen({super.key});

  @override
  State<DecisionVideoScreen> createState() => _DecisionVideoScreenState();
}

class _DecisionVideoScreenState extends State<DecisionVideoScreen> {
  final controller = DecisionFlowController();
  late VideoPlayerController _videoController;
  bool _showButtons = false;
  bool _isFullScreen = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoName = controller.currentNode.videoName;
    debugPrint('Inicializando video: $videoName');
    _videoController = VideoPlayerController.asset('assets/videos/$videoName.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        debugPrint('Reproduciendo video: $videoName');
        _videoController.addListener(_checkEnd);
      });
  }

  void _checkEnd() {
    final currentVideo = controller.currentNode.videoName;
    final requiresDecision = ['Escena3', 'Escena4', 'Escena5'].contains(currentVideo);

    if (_videoController.value.position >= _videoController.value.duration && !_showButtons) {
      _videoController.removeListener(_checkEnd);

      if (currentVideo == 'Escena5') {
        setState(() {
          _showButtons = true;
        });
        return;
      }

      if (controller.currentNode.isFinal) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SummaryScreen()),
            );
          }
        });
      } else if (requiresDecision) {
        setState(() {
          _showButtons = true;
        });
      } else {
        final nextNode = controller.currentNode.positiveDecision;
        if (nextNode != null) {
          controller.setCurrentNode(nextNode);
          _videoController.dispose();
          _initializeVideo();
        }
      }
    }
  }

  void _makeDecision(bool isPositive) {
    controller.makeDecision(isPositive);
    setState(() {
      _showButtons = false;
    });
    _videoController.removeListener(_checkEnd);
    _videoController.dispose();
    _initializeVideo();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }

  void _seekVideo(bool forward) async {
    if (!_videoController.value.isInitialized) return;

    final position = _videoController.value.position;
    final duration = _videoController.value.duration;

    Duration newPosition = forward
        ? position + const Duration(seconds: 10)
        : position - const Duration(seconds: 10);

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > duration) newPosition = duration;

    await _videoController.seekTo(newPosition);
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController.value.isPlaying) {
        _videoController.pause();
      } else {
        _videoController.play();
      }
    });
  }

  void _saveVideoLocally() async {
    // Implementar lógica para guardar el video localmente si es necesario.
  }

  void _pause() {
    setState(() {
      _isPaused = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PauseScreen()),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  // Video Controls UI
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
            icon: const Icon(Icons.replay_10, size: 40, color: Colors.white),
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
            icon: const Icon(Icons.forward_10, size: 40, color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : const CircularProgressIndicator(),
          ),
          narrativeProgressBar(
            positiveCount: controller.positiveCount,
            negativeCount: controller.negativeCount,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _pause,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: videoControls(
              controller: _videoController,
              onRewind: () => _seekVideo(false),
              onPlayPause: _togglePlayPause,
              onForward: () => _seekVideo(true),
              onFullScreen: _toggleFullScreen,
              onSaveVideo: _saveVideoLocally,
              isPlaying: _videoController.value.isPlaying,
            ),
          ),
          if (_showButtons)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.thumb_up),
                      label: const Text('Arrebatarle el teléfono y mostrarle la realidad.'),
                      onPressed: () => _makeDecision(true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.thumb_down),
                      label: const Text('Dejarlo, quizás no es tan grave.'),
                      onPressed: () => _makeDecision(false),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
