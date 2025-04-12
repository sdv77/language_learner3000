import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/lesson_model.dart';

class LessonViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Lesson>> getLessons() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('lessons').get();
      return querySnapshot.docs.map((doc) {
        return Lesson.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching lessons: $e");
      rethrow;
    }
  }
}