import 'package:flutter/material.dart';
import '../views/lessons_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, User!'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonsScreen(userId: userId),
                  ),
                );
              },
              child: Text('View Lessons'),
            ),
          ],
        ),
      ),
    );
  }
}