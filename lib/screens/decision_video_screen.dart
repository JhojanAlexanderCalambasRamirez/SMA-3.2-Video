import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/utils/button_message_decision.dart'; // 👈 Importamos el nuevo archivo
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
  List<String> _buttonMessages = ['', '']; // 👈 Mensajes dinámicos

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoName = controller.currentNode.videoName;
    _buttonMessages = ButtonMessageDecision.getMessages(videoName); // 👈 Actualizamos mensajes

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

          // Botón salir
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

          // Panel inferior
          if (!_isLoading && !_showFeedback)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_showButtons)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                onPressed: () => _makeDecision(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  _buttonMessages[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ElevatedButton(
                                onPressed: () => _makeDecision(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  _buttonMessages[1],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/Botones/left.png', height: 30),
                          onPressed: () => _seekVideo(false),
                        ),
                        IconButton(
                          icon: Icon(
                            _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        IconButton(
                          icon: Image.asset('assets/Botones/right.png', height: 30),
                          onPressed: () => _seekVideo(true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white, size: 30),
                          onPressed: _toggleFullScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Feedback
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
