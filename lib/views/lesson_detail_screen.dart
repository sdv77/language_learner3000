import 'package:flutter/material.dart';
import 'package:language_learner3000/views/pages_screen.dart';
import 'package:language_learner3000/views/test_screen.dart';
import '../models/lesson_model.dart';

class LessonDetailsScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailsScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
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
                      // Переход к страницам урока
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
                      // Открытие теста
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestScreen(pages: lesson.pages), // Передаем список LessonPage
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
}

