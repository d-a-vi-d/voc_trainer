import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voc_trainer/services/settings_service.dart';
import 'package:voc_trainer/widgets/menu_button.dart';
import '../models/word.dart';
import '../services/word_service.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

//enum LanguageMode { HomeLanguageFirst, ForeignLanguageFirst, RandomLanguageFirst }

class LearnScreen extends StatefulWidget {
  final String language;

  const LearnScreen({super.key, required this.language});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late List<Word> allWords; // Originalliste für diese Sprache
  late List<Word> shuffledWords; // Gemischte Liste für die Session
  int currentIndex = 0; // Index im shuffledWords
  //todo baustelle weil es muss auf das setting zugreifen

  CurrentLanguageMode currentLanguageMode = SettingsService.currentLanguageMode;
  bool showAlreadyLearned = SettingsService.showAlreadyLearned;

  @override
  void initState() {
    super.initState();
    _initLearning();
  }

  void _initLearning() {
    allWords = WordService.getWordsForLanguage(
      widget.language,
    ).where((w) => showAlreadyLearned ? !w.learned : true).toList();

    // Shuffle einmal beim Start
    setState(() {
      _updateShowHomeLanguage();
      shuffledWords = List.from(allWords);
      shuffledWords.shuffle();
      currentIndex = 0;
    });
  }

  void _next() {
    if (shuffledWords.isEmpty) return;
    if (currentIndex == shuffledWords.length - 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: const Text('Ende der Liste'),
          content: const Text(
            'Du hast das Ende der Liste erreicht! Möchtest du von vorne beginnen oder zur Übersicht wechseln?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Übersicht'),
            ),
            TextButton(
              onPressed: () {
                _initLearning();
                Navigator.pop(context);
              },
              child: const Text('Neu starten'),
            ),
          ],
        ),
      );
    }
    setState(() {
      currentIndex = (currentIndex + 1) % shuffledWords.length;
      _updateShowHomeLanguage();
    });
  }

  void _updateShowHomeLanguage() {
    if (currentLanguageMode == CurrentLanguageMode.home) {
      showHomeLanguage = true;
    } else if (currentLanguageMode == CurrentLanguageMode.foreign) {
      showHomeLanguage = false;
    } else {
      showHomeLanguage = Random().nextBool();
    }
  }

  void _previous() {
    if (shuffledWords.isEmpty) return;
    if (currentIndex == 0) return;
    setState(() {
      currentIndex = (currentIndex - 1) % shuffledWords.length;
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
                              fontWeight: FontWeight.bold, // Fett für bessere Lesbarkeit
                              color: Colors.black87, // Weicheres Schwarz
                              letterSpacing: 0.5, // Leichter Buchstabenabstand
                            ),
                          ),
                          const SizedBox(height: 6), // Mehr Abstand zwischen Text und Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //show all words button
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    //todo
                                    showAlreadyLearned = false;
                                    _initLearning();
                                  });
                                },
                                selected: !showAlreadyLearned,
                                text: "yesss",
                              ),
                              //only show new words button
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    showAlreadyLearned = true;
                                    _initLearning();
                                  });
                                },
                                selected: showAlreadyLearned,
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
                                    currentLanguageMode = CurrentLanguageMode.home;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                //todo
                                selected: currentLanguageMode == CurrentLanguageMode.home,
                                text: "home",
                              ),
                              //show foreign language first
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    currentLanguageMode = CurrentLanguageMode.foreign;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                //todo
                                selected: currentLanguageMode == CurrentLanguageMode.foreign,
                                text: "foreign",
                              ),
                              //random language first
                              MenuButton(
                                onTap: () {
                                  setState(() {
                                    currentLanguageMode = CurrentLanguageMode.random;
                                    _initLearning(); //Liste neu aufbauen
                                  });
                                },
                                //todo
                                selected: currentLanguageMode == CurrentLanguageMode.random,
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
                      maxSteps: shuffledWords.length,
                      progressType: LinearProgressBar.progressTypeLinear, // Use Linear progress
                      currentStep: currentIndex,
                      progressColor: Colors.green,
                      backgroundColor: const Color.fromARGB(255, 208, 208, 208),
                      borderRadius: BorderRadius.circular(50), //  NEW
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ElevatedButton(
                      key: ValueKey(showHomeLanguage ? currentWord!.definition : currentWord!.term),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 100),
                        textStyle: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        elevation: 4,
                      ),
                      onPressed: () {
                        setState(() {
                          //todo
                          showHomeLanguage = !showHomeLanguage;
                        });
                      },
                      child: Text(showHomeLanguage ? currentWord.definition : currentWord.term),
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
                          currentWord.learned ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: currentWord.learned ? Colors.green : Colors.grey,
                          size: 48,
                        ),
                        onPressed: _toggleLearned,
                      ),
                      IconButton(icon: const Icon(Icons.arrow_forward, size: 48), onPressed: _next),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
