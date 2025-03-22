import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/video_controls.dart';
import 'package:flutter_application_1/utils/storage_manager.dart';
import 'package:flutter_application_1/utils/video_downloader.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoId;
  final String? videoUrl;
  final String? assetPath;

  const VideoPlayerScreen({super.key, this.videoId, this.videoUrl, this.assetPath});

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
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
    if (widget.videoId != null) {
      _localVideoPath = await StorageManager.getData(widget.videoId!);
    }

    if (_localVideoPath != null && File(_localVideoPath!).existsSync()) {
      _initializeVideo(File(_localVideoPath!).path);
    } else if (widget.videoUrl != null) {
      _localVideoPath = await VideoDownloader.downloadVideo(widget.videoUrl!);
      if (_localVideoPath != null) {
        await StorageManager.saveData(widget.videoId!, _localVideoPath!);
        _initializeVideo(_localVideoPath!);
      } else {
        _initializeVideo(widget.assetPath ?? 'assets/videos/VideoEjemplo.mp4', isAsset: true);
      }
    } else {
      _initializeVideo(widget.assetPath ?? 'assets/videos/VideoEjemplo.mp4', isAsset: true);
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
      debugPrint('❌ Error al inicializar el video: $error');
    });
  }

  void _seekVideo(bool forward) {
    if (!_controller.value.isInitialized) return;

    final position = _controller.value.position;
    final duration = _controller.value.duration;

    if (duration.inSeconds == 0) {
      debugPrint('⚠️ No se puede adelantar/retroceder, duración 0.');
      return;
    }

    Duration newPosition = forward
        ? position + const Duration(seconds: 10)
        : position - const Duration(seconds: 10);

    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > duration) newPosition = duration;

    _controller.seekTo(newPosition).then((_) {
      debugPrint('✅ Video en ${_controller.value.position.inSeconds} segundos.');
      _controller.play();
    }).catchError((error) {
      debugPrint('❌ Error al cambiar posición: $error');
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
      appBar: isFullScreen ? null : AppBar(title: const Text('Reproductor de Video')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: isFullScreen
                          ? MediaQuery.of(context).size.aspectRatio
                          : _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  videoControls(
                    controller: _controller,
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
