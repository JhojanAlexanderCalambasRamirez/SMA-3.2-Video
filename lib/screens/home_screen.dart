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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo completa
          Image.asset(
            'assets/Imagenes/Pantalla_Inicial.png',
            fit: BoxFit.cover,
          ),

          // Contenido sobre el fondo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Logo/LogoAppIntro.png', width: 200),
                const SizedBox(height: 20),
                const Text(
                  'CLOCK SPIRIT',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Mejor visibilidad sobre fondo oscuro
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Lucha contra los Espíritus de la Miseria para salvar a sus amigos y tomar decisiones que impactarán sus destinos.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
        ],
      ),
    );
  }
}
