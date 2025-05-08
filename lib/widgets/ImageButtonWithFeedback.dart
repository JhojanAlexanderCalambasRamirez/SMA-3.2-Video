import 'package:flutter/material.dart';

class ImageButtonWithFeedback extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final double width;

  const ImageButtonWithFeedback({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.width = 250,
  });

  @override
  State<ImageButtonWithFeedback> createState() => _ImageButtonWithFeedbackState();
}

class _ImageButtonWithFeedbackState extends State<ImageButtonWithFeedback> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails details) => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 100),
        opacity: _isPressed ? 0.7 : 1.0,
        child: Image.asset(
          widget.imagePath,
          width: widget.width,
        ),
      ),
    );
  }
}
