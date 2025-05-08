// lib/utils/FeedBackDecision.dart
import 'package:flutter/material.dart';

/// Widget que muestra el feedback (éxito o fracaso) a pantalla completa
/// y un botón “Continuar” en la parte inferior con efecto de opacidad al pulsar.
class FeedBackDecision extends StatefulWidget {
  /// Ruta de la imagen de fondo (éxito o fracaso).
  final String feedbackImage;
  /// Callback al pulsar el botón Continuar.
  final VoidCallback onContinue;

  const FeedBackDecision({
    Key? key,
    required this.feedbackImage,
    required this.onContinue,
  }) : super(key: key);

  @override
  State<FeedBackDecision> createState() => _FeedBackDecisionState();
}

class _FeedBackDecisionState extends State<FeedBackDecision> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Imagen de fondo
        Positioned.fill(
          child: Image.asset(
            widget.feedbackImage,
            fit: BoxFit.cover,
          ),
        ),

        // Botón “Continuar” abajo centrado
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) {
                setState(() => _pressed = false);
                widget.onContinue();
              },
              onTapCancel: () => setState(() => _pressed = false),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _pressed ? 0.6 : 1.0,
                child: Image.asset(
                  'assets/Botones/Continuar_Decision.png',
                  width: 200, // Ajusta al tamaño que prefieras
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
