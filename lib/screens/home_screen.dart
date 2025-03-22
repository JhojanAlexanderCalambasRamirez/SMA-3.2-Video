import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🎬 Sistemas Multimedia Audiovisuales',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                '📌 Definición del Proyecto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              const Text(
                'Incentivar a los estudiantes de últimos semestres de la UAO a reflexionar sobre los efectos de la procrastinación y adoptar estrategias efectivas para superarla.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/upload'),
                  child: const Text('Ver Video Interactivo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
