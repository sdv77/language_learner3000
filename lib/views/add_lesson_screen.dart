import 'package:flutter/material.dart';
import 'package:language_learner3000/models/lesson_model.dart';
import '../viewmodels/teacher_viewmodel.dart';

class AddLessonScreen extends StatefulWidget {
  @override
  _AddLessonScreenState createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final TeacherViewModel _teacherViewModel = TeacherViewModel();
  final TextEditingController _titleController = TextEditingController();
  final List<Map<String, String>> _pages = [];

  void _addPage() {
    setState(() {
      _pages.add({
        'imageUrl': '',
        'englishWord': '',
        'russianTranslation': '',
      });
    });
  }

  Future<void> _saveLesson() async {
    try {
      List<LessonPage> pages = _pages.map((page) {
        return LessonPage(
          imageUrl: page['imageUrl']!,
          englishWord: page['englishWord']!,
          russianTranslation: page['russianTranslation']!,
        );
      }).toList();

      await _teacherViewModel.addLesson(_titleController.text, pages);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lesson added successfully!')),
      );
      Navigator.pop(context); // Возвращаемся на экран учителя
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding lesson: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Lesson')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Lesson Title'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          _pages[index]['imageUrl'] = value;
                        },
                        decoration: InputDecoration(labelText: 'Image URL'),
                      ),
                      TextField(
                        onChanged: (value) {
                          _pages[index]['englishWord'] = value;
                        },
                        decoration: InputDecoration(labelText: 'English Word'),
                      ),
                      TextField(
                        onChanged: (value) {
                          _pages[index]['russianTranslation'] = value;
                        },
                        decoration: InputDecoration(labelText: 'Russian Translation'),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addPage,
              child: Text('Add Page'),
            ),
            ElevatedButton(
              onPressed: _saveLesson,
              child: Text('Save Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}