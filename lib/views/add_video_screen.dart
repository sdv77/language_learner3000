import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVideoScreen extends StatefulWidget {
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final TextEditingController _videoUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Список вопросов для теста
  final List<Map<String, dynamic>> _questions = [];

  // Метод для добавления нового вопроса
  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': '',
        'options': ['', '', ''],
        'correctAnswerIndex': -1, // Индекс правильного ответа (-1 означает "не выбрано")
      });
    });
  }

  // Метод для сохранения видео и тестов в Firestore
  Future<void> _saveVideo() async {
    if (_titleController.text.isEmpty || _videoUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    try {
      // Добавляем видео в Firestore
      final videoRef = await FirebaseFirestore.instance.collection('videos').add({
        'url': _videoUrlController.text,
        'title': _titleController.text,
        'description': _descriptionController.text,
      });

      // Добавляем вопросы теста в дочернюю коллекцию `tests`
      for (var question in _questions) {
        await FirebaseFirestore.instance.collection('videos/${videoRef.id}/tests').add({
          'question': question['question'],
          'options': question['options'],
          'correctAnswer': question['options'][question['correctAnswerIndex']],
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Видео и тест успешно добавлены!')),
      );
      Navigator.pop(context); // Возвращаемся на главный экран
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при добавлении видео: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить видео')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _videoUrlController,
              decoration: InputDecoration(labelText: 'Ссылка на видео'),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
              maxLines: 3,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionFields(index);
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Добавить вопрос'),
            ),
            ElevatedButton(
              onPressed: _saveVideo,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  // Метод для отображения полей каждого вопроса
  Widget _buildQuestionFields(int index) {
    final question = _questions[index];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => _questions[index]['question'] = value,
              decoration: InputDecoration(labelText: 'Вопрос'),
            ),
            ...List.generate(3, (optionIndex) => Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => _questions[index]['options'][optionIndex] = value,
                    decoration: InputDecoration(labelText: 'Вариант ${optionIndex + 1}'),
                  ),
                ),
                Checkbox(
                  value: question['correctAnswerIndex'] == optionIndex,
                  onChanged: (bool? isChecked) {
                    setState(() {
                      if (isChecked == true) {
                        _questions[index]['correctAnswerIndex'] = optionIndex;
                      } else if (question['correctAnswerIndex'] == optionIndex) {
                        _questions[index]['correctAnswerIndex'] = -1; // Снимаем выбор
                      }
                    });
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}