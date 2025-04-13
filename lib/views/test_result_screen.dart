import 'package:flutter/material.dart';
import 'package:language_learner3000/models/model_test.dart';
import '../viewmodels/user_viewmodel.dart';

class TestResultsScreen extends StatelessWidget {
  final int total;
  final int correct;
  final int incorrect;
  final List<TestWord> incorrectWords;
  final String userId;
  final String lessonId;

  const TestResultsScreen({
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.incorrectWords,
    required this.userId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    final UserViewModel _userViewModel = UserViewModel();

    void _markLessonAsCompleted() async {
      await _userViewModel.addCompletedLesson(userId, lessonId);
      Navigator.pop(context); // Возвращаемся на экран уроков
    }

    return Scaffold(
      appBar: AppBar(title: Text('Test Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total words: $total', style: TextStyle(fontSize: 18)),
            Text('Correct answers: $correct', style: TextStyle(fontSize: 18, color: Colors.green)),
            Text('Incorrect answers: $incorrect', style: TextStyle(fontSize: 18, color: Colors.red)),
            SizedBox(height: 20),
            if (incorrect > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Incorrect words:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ...incorrectWords.map((word) {
                    return Text(
                      '${word.englishWord} - ${word.correctTranslation}',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    );
                  }).toList(),
                ],
              ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (incorrect == 0) {
                  _markLessonAsCompleted(); // Добавляем урок в завершенные
                } else {
                  Navigator.pop(context); // Возвращаемся на экран уроков
                }
              },
              child: Text(incorrect == 0 ? 'Mark as Completed' : 'Return to Lessons'),
            ),
          ],
        ),
      ),
    );
  }
}