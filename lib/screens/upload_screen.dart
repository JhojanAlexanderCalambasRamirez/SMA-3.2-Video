import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/video_controls.dart';
import 'package:flutter_application_1/utils/video_downloader.dart';
import 'dart:io';

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
    String? localPath = await VideoDownloader.copyVideoToLocal();

    if (localPath != null && File(localPath).existsSync()) {
      _controller = VideoPlayerController.file(File(localPath));
    } else {
      debugPrint('⚠️ No se pudo encontrar el video local. Intentando cargar desde assets.');
      _controller = VideoPlayerController.asset('assets/videos/VideoEjemplo.mp4');
    }

    _controller.initialize().then((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      debugPrint('❌ Error al cargar el video: $error');
    });
  }

  void _saveVideoLocally() async {
    await VideoDownloader.copyVideoToLocal();
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
      appBar: isFullScreen ? null : AppBar(title: const Text('Ver Video')),
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
                    onSaveVideo: _saveVideoLocally, // ✅ Botón para guardar el video
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
