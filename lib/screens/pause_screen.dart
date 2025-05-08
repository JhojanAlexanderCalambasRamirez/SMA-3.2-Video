import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart';
import 'package:flutter_application_1/widgets/ImageButtonWithFeedback.dart';


class PauseScreen extends StatelessWidget {
  const PauseScreen({super.key});

  void _resumeGame(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
    );
  }

  void _exitToHome(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            const Text(
              'Pausa',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ImageButtonWithFeedback(
              imagePath: 'assets/Botones/Reaunudar_Pausa.png',
              onTap: () => _resumeGame(context),
            ),
            const SizedBox(height: 20),
            ImageButtonWithFeedback(
              imagePath: 'assets/Botones/Salir_Pausa.png',
              onTap: () => _exitToHome(context),
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
