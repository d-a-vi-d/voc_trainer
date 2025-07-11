class Word {
  String word;
  String translation;
  final String language;
  bool learned;

  Word({
    required this.word,
    required this.translation,
    required this.language,
    this.learned = false,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'translation': translation,
        'language': language,
        'learned': learned,
      };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        word: json['word'],
        translation: json['translation'],
        language: json['language'],
        learned: json['learned'] ?? false,
      );
}
