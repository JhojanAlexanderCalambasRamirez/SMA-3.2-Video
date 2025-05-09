import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/home_screen.dart';

class FinalFeedbackScreen extends StatelessWidget {
  final String imagePath;

  const FinalFeedbackScreen({super.key, required this.imagePath});

  void _returnToHome(BuildContext context) async {
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => _returnToHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Volver al Inicio',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
