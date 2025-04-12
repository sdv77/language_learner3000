import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class TeacherViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLesson(String title, List<LessonPage> pages) async {
    try {
      await _firestore.collection('lessons').add({
        'title': title,
        'pages': pages.map((page) => page.toMap()).toList(),
      });
    } catch (e) {
      print("Error adding lesson: $e");
      rethrow;
    }
  }
}