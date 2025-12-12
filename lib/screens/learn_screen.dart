import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/word_service.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class LearnScreen extends StatefulWidget {
  final String language;

  const LearnScreen({super.key, required this.language});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  bool showOnlyNotLearned = true;

  late List<Word> allWords; // Originalliste für diese Sprache
  late List<Word> shuffledWords; // Gemischte Liste für die Session
  int currentIndex = 0; // Index im shuffledWords
  bool showTranslation = false;
  bool showTranslationFirst = true;

  @override
  void initState() {
    super.initState();
    _initLearning();
  }

  void _initLearning() {
    allWords = WordService.getWordsForLanguage(
      widget.language,
    ).where((w) => showOnlyNotLearned ? !w.learned : true).toList();

    // Shuffle einmal beim Start
    shuffledWords = List.from(allWords);
    shuffledWords.shuffle();
    currentIndex = 0;
  }

  void _next() {
    if (shuffledWords.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % shuffledWords.length;
      showTranslation = showTranslationFirst;
    });
  }

  void _previous() {
    if (shuffledWords.isEmpty) return;
    setState(() {
      currentIndex =
          (currentIndex - 1 + shuffledWords.length) % shuffledWords.length;
      showTranslation = showTranslationFirst;
    });
  }

  void _toggleLearned() {
    setState(() {
      final word = shuffledWords[currentIndex];
      word.learned = !word.learned;
      WordService.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    Word? currentWord = null;
    if (shuffledWords.isNotEmpty) {
      currentWord = shuffledWords[currentIndex];
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Lernen: ${widget.language}'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.grey),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),

                          Text(
                            "Show already learned?",
                            style: TextStyle(
                              fontSize: 20, // Größerer Text
                              fontWeight: FontWeight
                                  .bold, // Fett für bessere Lesbarkeit
                              color: Colors.black87, // Weicheres Schwarz
                              letterSpacing: 0.5, // Leichter Buchstabenabstand
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ), // Mehr Abstand zwischen Text und Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //show all words button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showOnlyNotLearned = false;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: showOnlyNotLearned == false
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    "yess",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              //only show new words button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showOnlyNotLearned = true;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: showOnlyNotLearned == true
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    "noo",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),

                          Text(
                            "Which language first?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //show home language first
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showTranslationFirst = true;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: showTranslationFirst == true
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    "home",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              //show foreign language first
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showTranslationFirst = false;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: showTranslationFirst == false
                                        ? Colors.green
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    "foreign",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),

      body: shuffledWords.isEmpty
          ? const Center(child: Text('Keine Wörter verfügbar.'))
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: LinearProgressBar(
                      maxSteps: 6,
                      progressType: LinearProgressBar
                          .progressTypeLinear, // Use Linear progress
                      currentStep: 1,
                      progressColor: Colors.red,
                      backgroundColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10), //  NEW
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      key: ValueKey(
                        showTranslation
                            ? currentWord!.translation
                            : currentWord!.word,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 100),
                        textStyle: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        elevation: 4,
                      ),
                      onPressed: () {
                        setState(() {
                          showTranslation = !showTranslation;
                        });
                      },
                      child: Text(
                        showTranslation
                            ? currentWord.translation
                            : currentWord.word,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 48),
                        onPressed: _previous,
                      ),
                      IconButton(
                        icon: Icon(
                          currentWord.learned ? Icons.star : Icons.star_border,
                          color: currentWord.learned
                              ? Colors.amber
                              : Colors.grey,
                          size: 48,
                        ),
                        onPressed: _toggleLearned,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward, size: 48),
                        onPressed: _next,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
