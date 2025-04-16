import 'package:flutter/material.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/user_model.dart';
import '../views/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final UserViewModel _userViewModel = UserViewModel();
    final AuthViewModel _authViewModel = AuthViewModel();

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: FutureBuilder<UserModel?>(
        future: _userViewModel.getUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not found.'));
          } else {
            UserModel user = snapshot.data!;
            int completedLessonsCount = user.completedLessons.length;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Completed Lessons:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$completedLessonsCount',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await _authViewModel.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                        (route) => false, // Очищаем весь стек навигации
                      );
                    },
                    child: Text('Выйти из аккаунта'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}