import 'package:flutter/material.dart';
import 'package:language_learner3000/models/lesson_model.dart';
import 'package:language_learner3000/models/model_test.dart';
import 'package:language_learner3000/views/test_result_screen.dart';
import '../viewmodels/test_viewmodel.dart';

class TestScreen extends StatefulWidget {
  final List<LessonPage> pages; // Изменено на List<LessonPage>

  const TestScreen({required this.pages});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late List<TestWord> _testWords;
  final TestViewModel _testViewModel = TestViewModel();
  int _currentIndex = 0;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _testWords = _testViewModel.generateTestWords(widget.pages);
  }

  void _submitAnswer() {
    if (_answerController.text.isNotEmpty) {
      setState(() {
        _testWords[_currentIndex].userTranslation = _answerController.text;
        _answerController.clear();
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _testWords.length) {
      // Переход к результатам теста
      final results = _testViewModel.calculateResults(_testWords);
      return TestResultsScreen(
        total: results['total'],
        correct: results['correct'],
        incorrect: results['incorrect'],
        incorrectWords: results['incorrectWords'],
      );
    }

    TestWord currentWord = _testWords[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWord.englishWord,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Enter translation'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: Text('Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }
}