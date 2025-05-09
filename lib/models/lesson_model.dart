class LessonPage {
  final String imageUrl;
  final String englishWord;
  final String russianTranslation;

  LessonPage({
    required this.imageUrl,
    required this.englishWord,
    required this.russianTranslation,
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'englishWord': englishWord,
      'russianTranslation': russianTranslation,
    };
  }

  factory LessonPage.fromMap(Map<String, dynamic> data) {
    return LessonPage(
      imageUrl: data['imageUrl'],
      englishWord: data['englishWord'],
      russianTranslation: data['russianTranslation'],
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<LessonPage> pages;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.pages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'pages': pages.map((page) => page.toMap()).toList(),
    };
  }

  factory Lesson.fromMap(String id, Map<String, dynamic> data) {
    return Lesson(
      id: id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      pages: (data['pages'] as List)
          .map((page) => LessonPage.fromMap(page))
          .toList(),
    );
  }
}