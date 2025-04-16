import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(color: Colors.grey[600]), // Hint text color
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.grey[800]), // Input text color
    );
  }
}