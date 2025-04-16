import 'package:flutter/material.dart';
import 'package:language_learner3000/views/completed_lessons_screen.dart';
import 'package:language_learner3000/views/lesson_detail_screen.dart';
import 'package:language_learner3000/views/profile_screen.dart';
import '../viewmodels/lesson_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../models/lesson_model.dart';
import '../widgets/lesson_card.dart';
import '../widgets/bottom_nav_bar.dart';

class LessonsScreen extends StatefulWidget {
  final String userId;

  const LessonsScreen({required this.userId});

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final LessonViewModel _lessonViewModel = LessonViewModel();
  final UserViewModel _userViewModel = UserViewModel();
  late Future<List<Lesson>> _lessonsFuture;
  late Future<List<String>> _completedLessonsFuture;

  @override
  void initState() {
    super.initState();
    _lessonsFuture = _lessonViewModel.getLessons();
    _completedLessonsFuture = _userViewModel.getCompletedLessons(widget.userId);
  }

 @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      // appBar: AppBar(title: Text('Уроки 🇺🇸'),
      // centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildLessonsList(),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CompletedLessonsScreen(
                  userId: widget.userId,
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userId: widget.userId,
                ),
              ),
            );
          }
        },
      ),
    ),
  );
}

Widget _buildLessonsList() {
  return FutureBuilder<List<Lesson>>(
    future: _lessonsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No lessons available.'));
      } else {
        List<Lesson> lessons = snapshot.data!;
        return _buildFilteredLessons(lessons);
      }
    },
  );
}

Widget _buildFilteredLessons(List<Lesson> lessons) {
  return FutureBuilder<List<String>>(
    future: _completedLessonsFuture,
    builder: (context, completedSnapshot) {
      if (completedSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (completedSnapshot.hasError) {
        return Center(child: Text('Error: ${completedSnapshot.error}'));
      } else {
        List<String> completedLessons = completedSnapshot.data ?? [];
        List<Lesson> filteredLessons = lessons
            .where((lesson) => !completedLessons.contains(lesson.id))
            .toList();
        return ListView.builder(
          itemCount: filteredLessons.length,
          itemBuilder: (context, index) {
            Lesson lesson = filteredLessons[index];
            return LessonCard(
              lesson: lesson,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonDetailsScreen(
                      lesson: lesson,
                      userId: widget.userId,
                    ),
                  ),
                );
              },
            );
          },
        );
      }
    },
  );
}
}