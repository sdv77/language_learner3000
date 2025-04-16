import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const AuthButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  _AuthButtonState createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}