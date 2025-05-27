import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../utils/decision_flow.dart';
import '../utils/button_message_decision.dart';
import '../utils/progress_bar.dart';
import '../screens/pause_screen.dart';
import '../utils/FeedBackDecision.dart';
import '../widgets/video_logic.dart';
import '../widgets/video_state_handler.dart';
import '../widgets/video_controls.dart';

class DecisionVideoScreen extends StatefulWidget {
  const DecisionVideoScreen({super.key});

  @override
  State<DecisionVideoScreen> createState() => _DecisionVideoScreenState();
}

class _DecisionVideoScreenState extends State<DecisionVideoScreen> {
  final controller = DecisionFlowController();
  late VideoPlayerController _videoController;
  final _audioPlayer = AudioPlayer();
  bool _showButtons = false;
  bool _showFeedback = false;
  bool _isLoading = true;
  bool _isFinalVideo = false;
  bool _finalFeedbackDisplayed = false;
  String _feedbackImage = '';
  List<String> _buttonMessages = ['', ''];
  late VideoStateHandler _stateHandler;

  @override
  void initState() {
    super.initState();
    _stateHandler = VideoStateHandler(controller);
    _initializeVideo();
  }

  void _initializeVideo() {
    final videoName = controller.currentNode.videoName;
    _buttonMessages = ButtonMessageDecision.getMessages(videoName);
    _isFinalVideo = videoName.startsWith('Final');
    _finalFeedbackDisplayed = false;

    VideoLogic.initializeVideo(videoName, (initializedController) {
      _videoController = initializedController;
      _videoController.addListener(_checkEnd);
      _videoController.addListener(() {
        if (mounted) setState(() {});
      });
      setState(() => _isLoading = false);
    });
  }

  void _checkEnd() {
    final name = controller.currentNode.videoName;
    final finished =
        _videoController.value.position >= _videoController.value.duration;
    if (!finished || _showButtons || _showFeedback) return;

    _videoController.removeListener(_checkEnd);

    if (_isFinalVideo && !_finalFeedbackDisplayed) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showFeedback = true;
            _finalFeedbackDisplayed = true;
            _feedbackImage = _stateHandler.getFinalFeedbackImage();
          });
        }
      });
    } else if (controller.currentNode.isFinal) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          controller.setCurrentNode(
            DecisionNode(videoName: controller.getFinal().videoName),
          );
          _videoController.dispose();
          _initializeVideo();
        }
      });
    } else if (VideoLogic.isDecisionVideo(name)) {
      setState(() => _showButtons = true);
    } else if (VideoLogic.isPathAfterDecision(name)) {
      if (!_isFinalVideo) {
        setState(() {
          _showFeedback = true;
          _feedbackImage = name.endsWith('_2')
              ? 'assets/FeedBack/exito.png'
              : 'assets/FeedBack/fracaso.png';
        });
      }
    } else {
      final next = controller.currentNode.positiveDecision;
      if (next != null) {
        controller.setCurrentNode(next);
        _videoController.dispose();
        _initializeVideo();
      }
    }
  }

  void _makeDecision(bool isPositive) {
    _stateHandler.makeDecision(isPositive);
    setState(() => _showButtons = false);
    _videoController.removeListener(_checkEnd);
    _videoController.dispose();
    _initializeVideo();
  }

  void _continueAfterFeedback() {
    final isGood = _feedbackImage.contains('exito');
    _playSound(isGood
        ? 'assets/Sounds/FeedBackDecisionBuena.mp3'
        : 'assets/Sounds/FeedBackDecisionMala.mp3');

    setState(() => _showFeedback = false);
    final nextNode = controller.currentNode.positiveDecision;
    if (nextNode != null) {
      controller.setCurrentNode(nextNode);
      _videoController.dispose();
      _initializeVideo();
    }
  }

  void _playSound(String path) async =>
      await _audioPlayer.play(AssetSource(path));

  void _openPauseMenu() {
    _playSound('assets/Sounds/ButonSalir.mp3');
    _videoController.pause();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PauseScreen(videoController: _videoController),
      ),
    );
  }

  void _resetExperience() {
    _stateHandler.resetFlow();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
    );
  }

  @override
  void dispose() {
    _videoController.removeListener(_checkEnd);
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _seek(bool forward) {
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
    _videoController.value.isPlaying
        ? _videoController.pause()
        : _videoController.play();
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
        if (!_isLoading && _showFeedback && _isFinalVideo)
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      _feedbackImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    child: ElevatedButton(
                      onPressed: _resetExperience,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Reiniciar Historia'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (!_isLoading && !_isFinalVideo)
          Positioned(
            top: 30,
            right: 20,
            child: IconButton(
              icon:
                  Image.asset('assets/Botones/exit.png', width: 44, height: 44),
              onPressed: _openPauseMenu,
            ),
          ),
        NarrativeProgressBar(
          positiveCount: controller.positiveCount,
          negativeCount: controller.negativeCount,
        ),
        if (!_isLoading && !_showFeedback && !_isFinalVideo)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _showButtons
                  ? decisionButtonsPanel(
                      leftText: _buttonMessages[0],
                      rightText: _buttonMessages[1],
                      onLeftTap: () => _makeDecision(true),
                      onRightTap: () => _makeDecision(false),
                    )
                  : videoControls(
                      controller: _videoController,
                      onRewind: () => _seek(false),
                      onPlayPause: _togglePlayPause,
                      onForward: () => _seek(true),
                      isPlaying: _videoController.value.isPlaying,
                    )),
        if (_showFeedback && !_isFinalVideo)
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
