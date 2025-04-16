import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../views/login_screen.dart';
import '../views/home_screen.dart';
import '../views/teacher_screen.dart';
import '../views/admin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthViewModel _authViewModel = AuthViewModel();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    bool isLoggedIn = await _authViewModel.isUserLoggedIn();
    if (isLoggedIn) {
      User? user = _authViewModel.auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _authViewModel.firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
          if (data != null) {
            String role = data['role'];
            String userId = userDoc.id;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => _getScreenByRole(role, userId),
              ),
            );
          }
        }
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Widget _getScreenByRole(String role, String userId) {
    switch (role) {
      case 'user':
        return HomeScreen(userId: userId);
      case 'teacher':
        return TeacherScreen(userId: userId);
      case 'admin':
        return AdminScreen();
      default:
        return HomeScreen(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 200, height: 200), // Убедитесь, что картинка добавлена в assets
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Авторизоваться'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}