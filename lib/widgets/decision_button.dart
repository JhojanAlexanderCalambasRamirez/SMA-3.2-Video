import 'package:flutter/material.dart';

class DecisionButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const DecisionButton({super.key, required this.text, required this.onTap});

  @override
  State<DecisionButton> createState() => _DecisionButtonState();
}

class _DecisionButtonState extends State<DecisionButton> {
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
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}