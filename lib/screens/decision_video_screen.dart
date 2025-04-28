import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/utils/progress_bar.dart';
import 'package:flutter_application_1/utils/video_controls.dart';
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
  bool _showFeedback = false;
  bool _isFullScreen = false;
  String _feedbackImage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoName = controller.currentNode.videoName;
    _videoController = VideoPlayerController.asset('assets/videos/$videoName.mp4')
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _videoController.play();
        _videoController.addListener(_checkEnd);
      });
  }

  void _checkEnd() {
    final currentVideo = controller.currentNode.videoName;
    final isDecisionVideo = ['Escena3', 'Escena4', 'Escena5'].contains(currentVideo);
    final isPathAfterDecision = [
      'Escena3_1', 'Escena3_2',
      'Escena4_1', 'Escena4_2',
      'Escena5_1', 'Escena5_2'
    ].contains(currentVideo);

    if (_videoController.value.position >= _videoController.value.duration && !_showButtons && !_showFeedback) {
      _videoController.removeListener(_checkEnd);

      if (controller.currentNode.isFinal) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SummaryScreen()));
          }
        });
      } else if (isDecisionVideo) {
        setState(() {
          _showButtons = true;
        });
      } else if (isPathAfterDecision) {
        setState(() {
          _showFeedback = true;
          _feedbackImage = currentVideo.endsWith('_2')
              ? 'assets/FeedBack/exito.png'
              : 'assets/FeedBack/fracaso.png';
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

  void _continueAfterFeedback() {
    setState(() {
      _showFeedback = false;
    });
    final nextNode = controller.currentNode.positiveDecision;
    if (nextNode != null) {
      controller.setCurrentNode(nextNode);
      _videoController.dispose();
      _initializeVideo();
    }
  }

  void _seekVideo(bool forward) {
    if (!_videoController.value.isInitialized) return;
    final position = _videoController.value.position;
    final duration = _videoController.value.duration;
    Duration newPosition = forward
        ? position + const Duration(seconds: 10)
        : position - const Duration(seconds: 10);

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > duration) newPosition = duration;

    _videoController.seekTo(newPosition);
  }

  void _togglePlayPause() {
    setState(() {
      _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play();
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  void _openPauseMenu() {
    _videoController.pause();
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PauseScreen()));
  }

  @override
  void dispose() {
    _videoController.removeListener(_checkEnd);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
          ),

          // Barra de progreso vertical (reemplazo del narrativeProgressBar)
          if (!_isLoading)
            Positioned(
              top: 100,
              left: 10,
              bottom: 100,
              child: Container(
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: (controller.positiveCount + controller.negativeCount).clamp(0, 3) / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.positiveCount >= 3
                            ? Colors.green
                            : controller.negativeCount >= 3
                                ? Colors.red
                                : Colors.yellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Botón de salir (exit.png)
          if (!_isLoading)
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: Image.asset(
                  'assets/Botones/exit.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                ),
                onPressed: _openPauseMenu,
              ),
            ),

          // Controles de video (solo retroceder, play, adelantar, fullscreen)
          if (!_isLoading && !_showFeedback)
            Positioned(
              bottom: 20,
              right: 20,
              child: videoControls(
                controller: _videoController,
                onRewind: () => _seekVideo(false),
                onPlayPause: _togglePlayPause,
                onForward: () => _seekVideo(true),
                onFullScreen: _toggleFullScreen,
                onSaveVideo: () {},
                isPlaying: _videoController.value.isPlaying,
              ),
            ),

          // Botones de decisión cuando toque decidir
          if (_showButtons && !_showFeedback)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () => _makeDecision(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Arrebatarle el teléfono y mostrarle la realidad.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () => _makeDecision(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Dejarlo, quizás no es tan grave.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Feedback de éxito o fracaso
          if (_showFeedback)
            Positioned.fill(
              child: Stack(
                children: [
                  Image.asset(
                    _feedbackImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: _continueAfterFeedback,
                      child: const Text('Continuar'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
