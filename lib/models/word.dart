class Word {
  String term;
  String definition;
  String language;
  bool learned;

  Word({
    required this.term,
    required this.definition,
    required this.language,
    this.learned = false,
  });

  Map<String, dynamic> toJson() => {
    'term': term,
    'definition': definition,
    'language': language,
    'learned': learned,
  };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    term: json['term'],
    definition: json['definition'],
    language: json['language'],
    learned: json['learned'] ?? false,
  );
}
