import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Home')),
      body: Center(child: Text('Welcome, Admin!')),
    );
  }
}