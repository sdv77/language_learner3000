import 'package:flutter/material.dart';
import 'package:language_learner3000/views/lesson_detail_screen.dart';
import '../viewmodels/lesson_viewmodel.dart';
import '../viewmodels/user_viewmodel.dart';
import '../models/lesson_model.dart';

class CompletedLessonsScreen extends StatefulWidget {
  final String userId;

  const CompletedLessonsScreen({required this.userId});

  @override
  _CompletedLessonsScreenState createState() => _CompletedLessonsScreenState();
}

class _CompletedLessonsScreenState extends State<CompletedLessonsScreen> {
  final LessonViewModel _lessonViewModel = LessonViewModel();
  final UserViewModel _userViewModel = UserViewModel();
  late Future<List<Lesson>> _completedLessonsFuture;

  @override
  void initState() {
    super.initState();
    _completedLessonsFuture = _fetchCompletedLessons();
  }

  Future<List<Lesson>> _fetchCompletedLessons() async {
    List<String> completedLessonIds = await _userViewModel.getCompletedLessons(widget.userId);
    List<Lesson> allLessons = await _lessonViewModel.getLessons();
    return allLessons.where((lesson) => completedLessonIds.contains(lesson.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Lessons')),
      body: FutureBuilder<List<Lesson>>(
        future: _completedLessonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No completed lessons.'));
          } else {
            List<Lesson> lessons = snapshot.data!;
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                Lesson lesson = lessons[index];
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
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}