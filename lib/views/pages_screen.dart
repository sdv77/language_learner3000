import 'package:flutter/material.dart';

class PagesScreen extends StatelessWidget {
  final List<dynamic> pages;

  const PagesScreen({required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lesson Pages')),
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          var page = pages[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.network(page.imageUrl),
                Text(page.englishWord, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(page.russianTranslation, style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TestPlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Placeholder')),
      body: Center(
        child: Text('This is a placeholder for the test screen.'),
      ),
    );
  }
}