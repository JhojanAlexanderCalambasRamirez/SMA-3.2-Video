import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_application_1/utils/decision_flow.dart';
import 'package:flutter_application_1/utils/button_message_decision.dart';
import 'package:flutter_application_1/utils/progress_bar.dart';
import 'package:flutter_application_1/screens/summary_screen.dart';
import 'package:flutter_application_1/screens/pause_screen.dart';
import 'package:flutter_application_1/utils/FeedBackDecision.dart';

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
  String _feedbackImage = '';
  bool _isLoading = true;
  List<String> _buttonMessages = ['', ''];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoName = controller.currentNode.videoName;
    _buttonMessages = ButtonMessageDecision.getMessages(videoName);

    _videoController = VideoPlayerController.asset('assets/videos/$videoName.mp4')
      ..initialize().then((_) {
        setState(() => _isLoading = false);
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

    if (_videoController.value.position >= _videoController.value.duration
        && !_showButtons
        && !_showFeedback) {
      _videoController.removeListener(_checkEnd);

      if (controller.currentNode.isFinal) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SummaryScreen()),
            );
          }
        });
      } else if (isDecisionVideo) {
        setState(() => _showButtons = true);
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
    setState(() => _showButtons = false);
    _videoController.removeListener(_checkEnd);
    _videoController.dispose();
    _initializeVideo();
  }

  void _continueAfterFeedback() {
    setState(() => _showFeedback = false);
    final nextNode = controller.currentNode.positiveDecision;
    if (nextNode != null) {
      controller.setCurrentNode(nextNode);
      _videoController.dispose();
      _initializeVideo();
    }
  }

  void _seekVideo(bool forward) {
    if (!_videoController.value.isInitialized) return;
    final pos = _videoController.value.position;
    final dur = _videoController.value.duration;
    var newPos = forward
        ? pos + const Duration(seconds: 10)
        : pos - const Duration(seconds: 10);
    if (newPos < Duration.zero) newPos = Duration.zero;
    if (newPos > dur) newPos = dur;
    _videoController.seekTo(newPos);
  }

  void _togglePlayPause() {
    setState(() {
      _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play();
    });
  }

  void _openPauseMenu() {
  _videoController.pause();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PauseScreen(videoController: _videoController),
    ),
  );
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
      body: Stack(children: [
        Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
        ),
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
        NarrativeProgressBar(
          positiveCount: controller.positiveCount,
          negativeCount: controller.negativeCount,
        ),
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
                      children: [
                        Expanded(
                          child: DecisionButton(
                            text: _buttonMessages[0],
                            onTap: () => _makeDecision(true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DecisionButton(
                            text: _buttonMessages[1],
                            onTap: () => _makeDecision(false),
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
                        icon: Image.asset(
                          _videoController.value.isPlaying
                              ? 'assets/Botones/Pause.png'
                              : 'assets/Botones/Play.png',
                          height: 30,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: Image.asset('assets/Botones/right.png', height: 30),
                        onPressed: () => _seekVideo(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (_showFeedback)
          Positioned.fill(
            child: FeedBackDecision(
              feedbackImage: _feedbackImage,
              onContinue: _continueAfterFeedback,
            ),
          ),
      ]),
    );
  }
}

class DecisionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const DecisionButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  State<DecisionButton> createState() => _DecisionButtonState();
}

class _DecisionButtonState extends State<DecisionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
