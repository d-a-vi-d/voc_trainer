import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voc_trainer/widgets/menu_button.dart';
import '../models/word.dart';
import '../services/word_service.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

enum LanguageMode {
  HomeLanguageFirst,
  ForeignLanguageFirst,
  RandomLanguageFirst,
}

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
  bool showHomeLanguage = false;

  LanguageMode currentLanguageMode = LanguageMode.HomeLanguageFirst;
  //bool randomfirsttranslation = false

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
      if (currentLanguageMode == LanguageMode.HomeLanguageFirst) {
        showHomeLanguage = true;
      } else if (currentLanguageMode == LanguageMode.ForeignLanguageFirst) {
        showHomeLanguage = false;
      } else if (currentLanguageMode == LanguageMode.RandomLanguageFirst) {
        showHomeLanguage = Random().nextBool();
      }
    });
  }

  void _previous() {
    if (shuffledWords.isEmpty) return;
    setState(() {
      currentIndex =
          (currentIndex - 1 + shuffledWords.length) % shuffledWords.length;
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
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
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
                            height: 6,
                          ), // Mehr Abstand zwischen Text und Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //show all words button
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    showOnlyNotLearned = false;
                                    _initLearning();
                                  });
                                },
                                selected: !showOnlyNotLearned,
                                text: "yesss",
                              ),
                              //only show new words button
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    showOnlyNotLearned = true;
                                    _initLearning();
                                  });
                                },
                                selected: showOnlyNotLearned,
                                text: "nooo",
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
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //show home language first
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    currentLanguageMode =
                                        LanguageMode.HomeLanguageFirst;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                selected:
                                    LanguageMode ==
                                    LanguageMode.HomeLanguageFirst,
                                text: "home",
                              ),
                              //show foreign language first
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    currentLanguageMode =
                                        LanguageMode.ForeignLanguageFirst;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                selected:
                                    LanguageMode ==
                                    LanguageMode.ForeignLanguageFirst,
                                text: "foreign",
                              ),
                              //random language first
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    currentLanguageMode =
                                        LanguageMode.RandomLanguageFirst;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                selected:
                                    LanguageMode ==
                                    LanguageMode.RandomLanguageFirst,
                                text: "random",
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LinearProgressBar(
                      minHeight: 20,
                      maxSteps: WordService.getWordsForLanguage(
                        widget.language,
                      ).length,
                      progressType: LinearProgressBar
                          .progressTypeLinear, // Use Linear progress
                      currentStep: WordService.getWordsForLanguage(
                        widget.language,
                      ).where((w) => w.learned).length,
                      progressColor: Colors.green,
                      backgroundColor: const Color.fromARGB(255, 208, 208, 208),
                      borderRadius: BorderRadius.circular(50), //  NEW
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      key: ValueKey(
                        showHomeLanguage
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
                          showHomeLanguage = !showHomeLanguage;
                        });
                      },
                      child: Text(
                        showHomeLanguage
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
