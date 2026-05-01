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

  //crazy code für wörter löschen
  //dafür muss ich bei der quizlet funktion einfach words.remove machen

  // @override
  // bool operator ==(Object other) =>
  //     other is Word &&
  //     term == other.term &&
  //     definition == other.definition &&
  //     language == other.language;

  // int get hashCode => Object.hash(term, definition, language);
}
