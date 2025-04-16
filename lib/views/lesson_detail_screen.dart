import 'package:flutter/material.dart';
import '../models/lesson_model.dart';
import '../views/test_screen.dart';
import '../views/pages_screen.dart';

class LessonDetailsScreen extends StatelessWidget {
  final Lesson lesson;
  final String userId;

  const LessonDetailsScreen({
    required this.lesson,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Image.network(
              lesson.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ratings and Best Seller
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text('4.569', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      Icon(Icons.star_border, size: 16, color: Colors.blue),
                      SizedBox(width: 4),
                      Text('4.9', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Best Seller',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Title
                  Text(
                    lesson.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  // Description
                  Text(
                    lesson.description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  // Lessons and Hours
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('24 Lessons (20 hours)',
                          style: TextStyle(fontSize: 16)),
                      Text('See all',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Individual Lessons
                  _buildLessonItem(context, 'Introduction to 3D', '20 mins'),
                ],
              ),
            ),
            // Enroll Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestScreen(
                            pages: lesson.pages,
                            userId: userId,
                            lessonId: lesson.id,
                          ),
                        ),
                      );
                    },
                child: Text('Enroll - \$24.99'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Individual Lesson Item Widget
  Widget _buildLessonItem(BuildContext context, String title, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(
                    'https://via.placeholder.com/50'), // Replace with actual image
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16)),
                Text(duration, style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.blue),
        ],
      ),
    );
  }

  Future<bool> _isLessonCompleted() async {
    return false;
  }
}