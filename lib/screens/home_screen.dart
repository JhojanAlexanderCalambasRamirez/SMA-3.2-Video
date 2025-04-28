import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/decision_video_screen.dart'; // ✅ Importar

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]); // ✅ Forzar horizontal

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DecisionVideoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/LogoAppIntro.png', width: 200), // ✅ Ruta corregida en minúsculas
            const SizedBox(height: 20),
            const Text(
              'CLOCK SPIRIT',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lucha contra los Espíritus de la Miseria para salvar a sus amigos y tomar decisiones que impactarán sus destinos.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _startGame(context), // ✅ Cambiado
              child: const Text('Iniciar'),
            ),
            ElevatedButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
