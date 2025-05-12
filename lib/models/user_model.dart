// user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  final List<String> completedLessons; // Список ID пройденных уроков
  final int completedLessonsCount;     // Количество пройденных уроков
  final DateTime createdAt;             // Дата регистрации (из Firestore)

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.completedLessons,
    required this.completedLessonsCount,
    required this.createdAt,
  });

  // Преобразуем модель в Map для сохранения в Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'completedLessons': completedLessons,
      'completedLessonsCount': completedLessonsCount,
      'createdAt': createdAt, // Firebase автоматически сохранит как Timestamp
    };
  }

  // Создаём модель из данных Firestore
  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    // Парсим список завершённых уроков
    final List<dynamic>? rawList = data['completedLessons'] as List?;
    final List<String> lessons = rawList?.map((item) => item.toString()).toList() ?? [];

    // Считаем количество пройденных уроков
    final int count = data['completedLessonsCount'] ?? lessons.length;

    // Парсим дату регистрации
    DateTime createdAt = DateTime.now();
    if (data['createdAt'] != null) {
      if (data['createdAt'] is Timestamp) {
        createdAt = (data['createdAt'] as Timestamp).toDate(); // <-- Firestore Timestamp
      } else if (data['createdAt'] is DateTime) {
        createdAt = data['createdAt']; // если это уже DateTime
      }
    }

    return UserModel(
      uid: uid,
      email: data['email'],
      role: data['role'],
      completedLessons: lessons,
      completedLessonsCount: count,
      createdAt: createdAt,
    );
  }
}