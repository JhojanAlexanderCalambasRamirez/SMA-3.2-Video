import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/video_styles.dart';
import 'package:flutter_application_1/utils/storage_manager.dart';
import 'package:flutter_application_1/utils/video_downloader.dart';

class VideoScreen extends StatefulWidget {
  final String videoId;
  final String? videoUrl;

  const VideoScreen({super.key, required this.videoId, this.videoUrl});

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool _isLoading = true;
  bool isFullScreen = false;

  String? _localVideoPath;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    _localVideoPath = await StorageManager.getData(widget.videoId);

    if (_localVideoPath != null && File(_localVideoPath!).existsSync()) {
      _initializeVideo(File(_localVideoPath!).path);
    } else if (widget.videoUrl != null) {
      _localVideoPath = await VideoDownloader.downloadVideo(widget.videoUrl!);
      if (_localVideoPath != null) {
        await StorageManager.saveData(widget.videoId, _localVideoPath!);
        _initializeVideo(_localVideoPath!);
      } else {
        _initializeVideo('assets/videos/VideoEjemplo.mp4', isAsset: true);
      }
    } else {
      _initializeVideo('assets/videos/VideoEjemplo.mp4', isAsset: true);
    }
  }

  void _initializeVideo(String path, {bool isAsset = false}) {
    _controller = isAsset
        ? VideoPlayerController.asset(path)
        : VideoPlayerController.file(File(path));

    _controller.initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      debugPrint('Error al inicializar el video: $error');
    });
  }

  void _seekVideo(bool forward) {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    Duration newPosition = forward
        ? position + const Duration(seconds: 10)
        : position - const Duration(seconds: 10);

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > duration) newPosition = duration;

    _controller.seekTo(newPosition);
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
      appBar: isFullScreen ? null : AppBar(title: const Text('Video Interactivo')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  videoControls(
                    onRewind: () => _seekVideo(false),
                    onPlayPause: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                    onForward: () => _seekVideo(true),
                    onFullScreen: _toggleFullScreen,
                    isPlaying: _controller.value.isPlaying,
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
