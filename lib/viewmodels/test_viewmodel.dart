import 'package:language_learner3000/models/lesson_model.dart';
import 'package:language_learner3000/models/model_test.dart';

class TestViewModel {
  // Генерация случайного порядка слов
  List<TestWord> generateTestWords(List<LessonPage> pages) {
    return pages.map((page) {
      return TestWord(
        englishWord: page.englishWord,
        correctTranslation: page.russianTranslation,
      );
    }).toList()..shuffle();
  }

  // Подсчет результатов теста
  Map<String, dynamic> calculateResults(List<TestWord> words) {
    int total = words.length;
    int correct = words.where((word) => word.isCorrect).length;
    int incorrect = total - correct;

    return {
      'total': total,
      'correct': correct,
      'incorrect': incorrect,
      'incorrectWords': words.where((word) => !word.isCorrect).toList(),
    };
  }
}