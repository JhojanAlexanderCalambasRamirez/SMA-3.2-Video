import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Logo/Logo.png'), // Cambia con la ruta de tu logo
            const SizedBox(height: 20),
            const Text(
              'CLOCK SPIRIT',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Lucha contra los Espíritus de la Miseria para salvar a sus amigos y tomar decisiones que impactarán sus destinos.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/upload'); // Navega a la pantalla de carga de video
              },
              child: const Text('Iniciar'),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop(); // Cierra la aplicación
              },
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}
