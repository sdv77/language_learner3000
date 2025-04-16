import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Публичный геттер для _auth
  FirebaseAuth get auth => _auth;

  // Публичный геттер для _firestore
  FirebaseFirestore get firestore => _firestore;

  Future<UserModel?> signIn(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.id, userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error during sign in: $e");
      rethrow;
    }
  }

  Future<void> register(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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

  Future<bool> isUserLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
      rethrow;
    }
  }
}