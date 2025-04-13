import 'package:flutter/material.dart';
import '../views/add_lesson_screen.dart';
import '../views/lessons_screen.dart';

class TeacherScreen extends StatelessWidget {
  final String userId;

  const TeacherScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teacher Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, Teacher!'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddLessonScreen()),
                );
              },
              child: Text('Add Lesson'),
            ),
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