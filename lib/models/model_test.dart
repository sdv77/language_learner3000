class TestWord {
  final String englishWord;
  final String correctTranslation;
  String? userTranslation;

  TestWord({
    required this.englishWord,
    required this.correctTranslation,
    this.userTranslation,
  });

  bool get isCorrect => userTranslation?.trim().toLowerCase() == correctTranslation.trim().toLowerCase();
}