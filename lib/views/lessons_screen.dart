import 'package:flutter/material.dart';
import 'package:language_learner3000/views/completed_lessons_screen.dart';
import 'package:language_learner3000/views/lesson_detail_screen.dart';
import '../viewmodels/lesson_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../models/lesson_model.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
        actions: [
          IconButton(
            icon: Icon(Icons.checklist_rtl),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CompletedLessonsScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Lesson>>(
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
            return FutureBuilder<List<String>>(
              future: _completedLessonsFuture,
              builder: (context, completedSnapshot) {
                if (completedSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (completedSnapshot.hasError) {
                  return Center(child: Text('Error: ${completedSnapshot.error}'));
                } else {
                  List<String> completedLessons = completedSnapshot.data ?? [];
                  // Фильтруем уроки, исключая завершенные
                  List<Lesson> filteredLessons = lessons
                      .where((lesson) => !completedLessons.contains(lesson.id))
                      .toList();
                  return ListView.builder(
                    itemCount: filteredLessons.length,
                    itemBuilder: (context, index) {
                      Lesson lesson = filteredLessons[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.network(lesson.imageUrl),
                          title: Text(lesson.title),
                          subtitle: Text(lesson.description),
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
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}