import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../views/test_screen.dart';
import '../views/pages_screen.dart';

class LessonDetailsScreen extends StatelessWidget {
  final Lesson lesson;
  final String userId;

  const LessonDetailsScreen({
    required this.lesson,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          FutureBuilder<bool>(
            future: _isLessonCompleted(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              } else if (snapshot.hasError) {
                return Icon(Icons.error, color: Colors.red);
              } else {
                bool isCompleted = snapshot.data ?? false;
                return isCompleted
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(lesson.imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PagesScreen(pages: lesson.pages),
                        ),
                      );
                    },
                    child: Text('Study'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestScreen(
                            pages: lesson.pages,
                            userId: userId,
                            lessonId: lesson.id,
                          ),
                        ),
                      );
                    },
                    child: Text('Take Test'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _isLessonCompleted() async {
    // Логика проверки завершения урока
    // Например, используя UserViewModel
    return false; // Замените на реальную проверку
  }
}