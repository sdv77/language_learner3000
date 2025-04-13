import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:language_learner3000/models/user_model.dart';

class UserViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.id, userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      rethrow;
    }
  }

  Future<void> addCompletedLesson(String userId, String lessonId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'completedLessons': FieldValue.arrayUnion([lessonId]),
      });
    } catch (e) {
      print("Error adding completed lesson: $e");
      rethrow;
    }
  }

  Future<List<String>> getCompletedLessons(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          return List<String>.from((userDoc.data() as Map<String, dynamic>)['completedLessons'] ?? []);
        }
      return [];
    } catch (e) {
      print("Error fetching completed lessons: $e");
      rethrow;
    }
  }
}