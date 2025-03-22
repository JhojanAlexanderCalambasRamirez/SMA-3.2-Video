import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/video_controls.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  late VideoPlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📂 Inicializando video...');

    _controller = VideoPlayerController.asset('assets/videos/VideoEjemplo.mp4')
  ..initialize().then((_) {
    final duration = _controller.value.duration;
    debugPrint('✅ Video inicializado con duración: ${duration.inSeconds} segundos.');
    if (duration.inSeconds == 0) {
      debugPrint('⚠️ Advertencia: La duración del video es 0, posible error al cargar.');
    }
    setState(() {});
  }).catchError((error) {
    debugPrint('❌ Error al cargar el video: $error');
  });
  }

  void _seekVideo(bool forward) {
  if (!_controller.value.isInitialized) {
    debugPrint('⚠️ Intento de mover el video pero aún no está inicializado.');
    return;
  }

  final position = _controller.value.position;
  final duration = _controller.value.duration;

  if (duration.inSeconds == 0) {
    debugPrint('⚠️ No se puede adelantar/retroceder, la duración del video es 0.');
    return;
  }

  Duration newPosition = forward
      ? position + const Duration(seconds: 10)
      : position - const Duration(seconds: 10);

  if (newPosition < Duration.zero) newPosition = Duration.zero;
  if (newPosition > duration) newPosition = duration;

  debugPrint('🔄 Moviendo video: ${position.inSeconds} → ${newPosition.inSeconds}');
  
  _controller.seekTo(newPosition).then((_) {
    debugPrint('✅ Posición del video actualizada a ${_controller.value.position.inSeconds} segundos.');
    _controller.play();  // Asegurar que el video siga reproduciéndose después de adelantar/retroceder.
  }).catchError((error) {
    debugPrint('❌ Error al cambiar la posición del video: $error');
  });
}



  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });

    if (isFullScreen) {
      debugPrint('🖥️ Activando pantalla completa.');
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]);
    } else {
      debugPrint('📱 Saliendo de pantalla completa.');
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
      appBar: isFullScreen ? null : AppBar(title: const Text('Subir Video')),
      body: Center(
        child: _controller.value.isInitialized
            ? Column(
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
                    onRewind: () {
                      debugPrint('⏪ Retrocediendo...');
                      _seekVideo(false);
                    },
                    onPlayPause: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          debugPrint('⏸️ Pausando en ${_controller.value.position.inSeconds} segundos.');
                          _controller.pause();
                        } else {
                          debugPrint('▶️ Reproduciendo desde ${_controller.value.position.inSeconds} segundos.');
                          _controller.play();
                        }
                      });
                    },
                    onForward: () {
                      debugPrint('⏩ Adelantando...');
                      _seekVideo(true);
                    },
                    onFullScreen: _toggleFullScreen,
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🛑 Liberando recursos del video.');
    _controller.dispose();
    super.dispose();
  }
}
