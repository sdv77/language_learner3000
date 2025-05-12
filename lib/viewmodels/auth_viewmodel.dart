// auth_viewmodel.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Публичный геттер для _auth
  FirebaseAuth get auth => _auth;

  // Публичный геттер для _firestore
  FirebaseFirestore get firestore => _firestore;

  /// Вход пользователя по email и паролю
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromMap(
            userDoc.id, userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error during sign in: $e");
      rethrow;
    }
  }

  /// Регистрация нового пользователя
  Future<void> register(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Сохраняем данные пользователя в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
        'completedLessons': [],
        'completedLessonsCount': 0,
        'createdAt': FieldValue.serverTimestamp(), // ← добавили серверное время
      });
    } catch (e) {
      print("Error during registration: $e");
      rethrow;
    }
  }

  /// Отправка письма с подтверждением
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print("Error sending email verification: $e");
      rethrow;
    }
  }

  /// Проверка, вошёл ли пользователь
  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  /// Выход пользователя
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }
}