import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../utils/storage_manager.dart';
import '../utils/video_downloader.dart';

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
        _initializeVideo("assets/videos/VideoEjemplo.mp4", isAsset: true);
      }
    } else {
      _initializeVideo("assets/videos/VideoEjemplo.mp4", isAsset: true);
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
      debugPrint("Error al inicializar el video: $error");
    });
  }

  void _seekVideo(bool forward) {
    final position = _controller.value.position;
    final newPosition = forward
        ? position + const Duration(seconds: 10)
        : position - const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Interactivo")),
      body: GestureDetector(
        onTapUp: (TapUpDetails details) {
          final double screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 2) {
            _seekVideo(false);
          } else {
            _seekVideo(true);
          }
        },
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
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
