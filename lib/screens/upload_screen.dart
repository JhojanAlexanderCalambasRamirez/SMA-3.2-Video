import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/video_controls.dart';
import 'package:flutter_application_1/utils/video_downloader.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  late VideoPlayerController _controller;
  bool isFullScreen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/Escena1.mp4');

    await _controller.initialize();
    setState(() {
      _isLoading = false;
    });
    _controller.play();
    _controller.addListener(_checkEnd);
  }

  void _checkEnd() {
    if (_controller.value.position >= _controller.value.duration && mounted) {
      _controller.removeListener(_checkEnd);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
      );
    }
  }

  void _saveVideoLocally() async {
    await VideoDownloader.copyVideoToLocal();
  }

  void _seekVideo(bool forward) async {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    Duration newPosition = forward
        ? position + const Duration(seconds: 10)
        : position - const Duration(seconds: 10);

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > duration) newPosition = duration;

    await _controller.seekTo(newPosition);
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });

    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen ? null : AppBar(title: const Text('Ver Video')),
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : AspectRatio(
                    aspectRatio: isFullScreen
                        ? MediaQuery.of(context).size.aspectRatio
                        : _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: videoControls(
              controller: _controller,
              onRewind: () => _seekVideo(false),
              onPlayPause: _togglePlayPause,
              onForward: () => _seekVideo(true),
              onFullScreen: _toggleFullScreen,
              onSaveVideo: _saveVideoLocally,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_checkEnd);
    _controller.dispose();
    super.dispose();
  }
}
