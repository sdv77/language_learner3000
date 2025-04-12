import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AdminViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение всех пользователей (исключая администраторов)
  Future<List<UserModel>> getUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .where((doc) => doc.data() != null && (doc.data() as Map<String, dynamic>)['role'] != 'admin')
          .map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching users: $e");
      rethrow;
    }
  }

  // Поиск пользователей по email (исключая администраторов)
 Future<List<UserModel>> searchUsers(String query) async {
  try {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('email', isLessThan: '${query.toLowerCase()}z')
        .get();

    // Логируем данные из Firestore
    print("Firestore query results:");
    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }

    return querySnapshot.docs
        .where((doc) => doc.data() != null && (doc.data() as Map<String, dynamic>)['role'] != 'admin')
        .map((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error searching users: $e");
    rethrow;
  }
}

  // Обновление роли пользователя
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': newRole,
      });
    } catch (e) {
      print("Error updating user role: $e");
      rethrow;
    }
  }
}