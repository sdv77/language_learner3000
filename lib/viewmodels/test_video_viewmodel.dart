import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:language_learner3000/models/question.dart';

class TestVideoViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  bool _isLoading = true; // Флаг загрузки

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get correctAnswers => _correctAnswers;
  bool get isLoading => _isLoading;

  Future<void> loadQuestions(String videoId) async {
    try {
      final querySnapshot =
          await _firestore.collection('videos/$videoId/tests').get();
      _questions = querySnapshot.docs.map((doc) => Question.fromMap(doc.data())).toList();
    } catch (e) {
      print('Ошибка при загрузке тестов: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void answerQuestion(String selectedAnswer) {
    if (_currentQuestionIndex < _questions.length &&
        selectedAnswer == _questions[_currentQuestionIndex].correctAnswer) {
      _correctAnswers++;
    }
    _currentQuestionIndex++;
    notifyListeners();
  }

  void resetTest() {
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    notifyListeners();
  }
}