import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signIn(String email, String password, BuildContext context) async {
    try {
      // Аутентификация через Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Получение данных пользователя из Firestore
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.id, userDoc.data() as Map<String, dynamic>);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found in Firestore')),
        );
        return null;
      }
    } catch (e) {
      print("Error during sign in: $e");
      rethrow;
    }
  }

  Future<void> register(String email, String password, String role) async {
    try {
      // Регистрация нового пользователя
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Сохранение данных пользователя в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
        'completedLessons': [],
      });
    } catch (e) {
      print("Error during registration: $e");
      rethrow;
    }
  }

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
} 