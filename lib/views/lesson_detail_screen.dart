import 'package:flutter/material.dart';
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
                      // Заглушка для теста
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestPlaceholderScreen(),
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

class PagesScreen extends StatelessWidget {
  final List<dynamic> pages;

  const PagesScreen({required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson Pages')),
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          var page = pages[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(page.imageUrl),
                Text(page.englishWord, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(page.russianTranslation, style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TestPlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Placeholder')),
      body: Center(
        child: Text('This is a placeholder for the test screen.'),
      ),
    );
  }
}