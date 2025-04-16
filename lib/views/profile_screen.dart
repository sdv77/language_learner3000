import 'package:flutter/material.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/user_model.dart';
import '../views/splash_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import 'completed_lessons_screen.dart';
import 'lessons_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final UserViewModel _userViewModel = UserViewModel();
    final AuthViewModel _authViewModel = AuthViewModel();

    return Scaffold(
      appBar: AppBar(title: Text('👤 Profile')),
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
                crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                children: [
                  // Smiley Avatar
                  Text(
                    '😊', // You can replace this with a more elaborate smiley
                    style: TextStyle(fontSize: 80),
                  ),
                  SizedBox(height: 20),
                  // User Email
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Completed Lessons
                  Text(
                    'Completed Lessons: $completedLessonsCount',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(), // Push the logout button to the bottom
                  // Logout Button
                  ElevatedButton(
                    onPressed: () async {
                      await _authViewModel.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SplashScreen()),
                        (route) => false,
                      );
                    },
                    child: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonsScreen(
                  userId: userId,
                ),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedLessonsScreen(
                  userId: userId,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}