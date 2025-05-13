import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/Imagenes/Pantalla_Inicial.png', fit: BoxFit.cover),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/Textos/TituloApp.png', width: 220),
                const SizedBox(height: 16),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage('assets/Logo/LogoAppIntro.png'),
                      fit: BoxFit.contain,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Lucha contra los Espíritus de la Miseria para salvar a sus amigos y tomar decisiones que impactarán sus destinos.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                _ImageButton(
                  imagePath: 'assets/Botones/Iniciar_Home.png',
                  soundPath: 'assets/Sounds/ButonIniciarExperiencia.mp3',
                  onTap: () => _startGame(context),
                ),
                const SizedBox(height: 16),
                _ImageButton(
                  imagePath: 'assets/Botones/Salir_Home.png',
                  soundPath: 'assets/Sounds/ButonSalir.mp3',
                  onTap: () => SystemNavigator.pop(),
                ),
              ],
            ),
          ),

          // Firma del desarrollador (parte inferior)
          const Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Desarrollado - JACR',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageButton extends StatefulWidget {
  final String imagePath;
  final String soundPath;
  final VoidCallback onTap;

  const _ImageButton({
    required this.imagePath,
    required this.soundPath,
    required this.onTap,
  });

  @override
  State<_ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<_ImageButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _pressed = false;

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource(widget.soundPath.replaceFirst('assets/', '')));
    } catch (e) {
      debugPrint('Error al reproducir sonido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) async {
        setState(() => _pressed = false);
        await _playSound();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _pressed ? 0.6 : 1.0,
        child: Image.asset(widget.imagePath, width: 180),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
