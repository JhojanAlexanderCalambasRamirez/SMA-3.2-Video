import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';
import 'package:flutter_application_1/widgets/ImageButtonWithFeedback.dart';


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
      backgroundColor: const Color(0xFFFDF6FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/LogoAppIntro.png', width: 200),
            const SizedBox(height: 20),
            const Text(
              'CLOCK SPIRIT',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Lucha contra los Espíritus de la Miseria para salvar a sus amigos y tomar decisiones que impactarán sus destinos.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ImageButtonWithFeedback(
              imagePath: 'assets/Botones/Iniciar_Home.png',
              onTap: () => _startGame(context),
            ),
            const SizedBox(height: 20),
            ImageButtonWithFeedback(
              imagePath: 'assets/Botones/Salir_Home.png',
              onTap: () => SystemNavigator.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageButtonWithFeedback extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const ImageButtonWithFeedback({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<ImageButtonWithFeedback> createState() => _ImageButtonWithFeedbackState();
}

class _ImageButtonWithFeedbackState extends State<ImageButtonWithFeedback> {
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
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _pressed ? 0.6 : 1.0,
        child: Image.asset(widget.imagePath, width: 200),
      ),
    );
  }
}
