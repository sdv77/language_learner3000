import 'package:flutter/material.dart';

class TeacherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Home')),
      body: Center(child: Text('Welcome, Teacher!')),
    );
  }
}