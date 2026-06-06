class Questionnaire {
  final int? id;
  final int childId;
  final List<Question> questions;

  // wird ausgeführt bei init, also bei Questionnaire()
  Questionnaire({this.id, required this.childId, List<Question>? questions})
    // Funtktionscode (nur Zuweisungen) der durchgeführt wird BEI Erstellung
    // "??" heißt nimm das davor außer es ist null dann das danach
    : questions = questions ?? [] {
    // Funktionscode der durchgeführt wird NACH Erstellung (spießt sich mit final, umgehbar mit late final)
    //print("new Questionnaire created");
  }
  // was eigentlich (intern) durchgeführt wird
  /*void init(id, childId, questions) {
    this.id = id;
    this.childId = childId;
    this.questions = questions;

    if (questions == null) {
      this.questions = [];
    } else {
      this.questions = questions;
    }
    this.createdAt = Date.now();
  }*/
}

class Question {
  final int? id;
  final int minimumAge;
  final int maximumAge;
  final int questionnaireIndex;
  final String content;
  final List<String>? options;
  List<Answer> answers;

  Question({
    this.id,
    required this.minimumAge,
    required this.maximumAge,
    required this.questionnaireIndex,
    required this.content,
    this.options,
    List<Answer>? answers,
  }) : answers = answers ?? [];
}

class Answer {
  final int? id;
  final int userId;
  final String value;
  Answer({this.id, required this.userId, required this.value});
}

// ein Fragebogen hat: ID, Kind ID, Questions
// eine question hat: ID, geeignetes Alter, Index im Fragebogen, Inhalt, Answer
// eine Answer hat: ID, von wem, welche Antwort
// Alter x - y hat: ID, Questi

//"Es ist okay, wenn unser Kind in der Wut mit Dingen wirft",
//"Wenn das Kind ins Wohnzimmer kommt machen wir den Fernseher aus",
