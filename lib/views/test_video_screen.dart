import 'package:flutter/material.dart';
import 'package:language_learner3000/models/question.dart';
import 'package:language_learner3000/viewmodels/test_video_viewmodel.dart';
import 'package:provider/provider.dart';

class TestVideoScreen extends StatelessWidget {
  final String videoId;

  TestVideoScreen({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TestVideoViewModel()..loadQuestions(videoId),
      child: Consumer<TestVideoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (viewModel.questions.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: Text('Тест')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Для этого видео нет тестов.'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Вернуться к видео
                      },
                      child: Text('Вернуться к видео'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewModel.currentQuestionIndex >= viewModel.questions.length) {
            return _buildResultScreen(viewModel, context);
          }

          final question = viewModel.questions[viewModel.currentQuestionIndex];
          return _buildQuestionScreen(question, viewModel);
        },
      ),
    );
  }

  Widget _buildQuestionScreen(Question question, TestVideoViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text('Тест')),
      body: Column(
        children: [
          Text(question.question),
          ...question.options.map((option) => ElevatedButton(
            onPressed: () => viewModel.answerQuestion(option),
            child: Text(option),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildResultScreen(TestVideoViewModel viewModel, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Результат')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Правильных ответов: ${viewModel.correctAnswers} из ${viewModel.questions.length}'),
            ElevatedButton(
              onPressed: () {
                viewModel.resetTest();
                Navigator.pop(context);
              },
              child: Text('Вернуться к видео'),
            ),
          ],
        ),
      ),
    );
  }
}