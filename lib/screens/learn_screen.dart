import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voc_trainer/provider/settings_provider.dart';
import 'package:voc_trainer/provider/word_state_provider.dart';
import 'package:voc_trainer/widgets/menu_button.dart';
import '../models/word.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class LearnScreen extends ConsumerStatefulWidget {
  final String language;
  const LearnScreen({super.key, required this.language});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  List<Word> shuffledWords = [];
  int currentIndex = 0;

  late bool showHomeLanguage;

  //CurrentLanguageMode currentLanguageMode = SettingsService.currentLanguageMode;
  //bool showAlreadyLearned = SettingsService.showAlreadyLearned;

  @override
  void initState() {
    super.initState();
    _initLearning();
  }

  void _initLearning() async {
    // final showAlreadyLearned = ref.read(settingsProvider).value?.showAlreadyLearned ?? false;
    final settingsState = await ref.read(settingsProvider.future);
    final showAlreadyLearned = settingsState.showAlreadyLearned;

    _updateShowHomeLanguage();
    final words = ref
        .read(wordStateProvider)
        .requireValue
        .words
        .where((w) => w.language == widget.language)
        .where((w) => showAlreadyLearned ? !w.learned : true)
        .toList();

    setState(() {
      shuffledWords = List.from(words)..shuffle();
      currentIndex = 0;
    });
  }

  void _updateShowHomeLanguage() {
    final languageMode = ref.read(settingsProvider).value?.languageMode ?? LanguageMode.home;
    if (languageMode == LanguageMode.home) {
      showHomeLanguage = true;
    } else if (languageMode == LanguageMode.foreign) {
      showHomeLanguage = false;
    } else {
      showHomeLanguage = Random().nextBool();
    }
  }

  void _next() {
    if (shuffledWords.isEmpty) return;
    if (currentIndex == shuffledWords.length - 1) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
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

  void _previous() {
    if (shuffledWords.isEmpty || currentIndex == 0) return;
    setState(() => currentIndex = (currentIndex - 1) % shuffledWords.length);
  }

  void _toggleLearned() {
    final word = shuffledWords[currentIndex];
    ref.read(wordStateProvider.notifier).toggleLearned(word);
    // lokal updaten damit der Button sofort reagiert
    setState(() {
      shuffledWords[currentIndex] = Word(
        id: word.id,
        term: word.term,
        definition: word.definition,
        languageId: word.languageId,
        learned: !word.learned,
        languages: word.languages,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    if (settingsAsync.isLoading || !settingsAsync.hasValue)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (settingsAsync.hasError)
      return const Scaffold(body: Center(child: Text("Fehler beim Laden der Einstellungen")));

    final currentWord = shuffledWords.isNotEmpty ? shuffledWords[currentIndex] : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lernen: ${widget.language}'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Consumer(
                  builder: (context, ref, child) {
                    final settings = ref.watch(settingsProvider).requireValue;
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
                                  ref.read(settingsProvider.notifier).setShowAlreadyLearned(false);

                                  _initLearning();
                                },
                                selected: !settings.showAlreadyLearned,
                                text: "yesss",
                              ),
                              //only show new words button
                              MenuButton(
                                onTap: () {
                                  ref.read(settingsProvider.notifier).setShowAlreadyLearned(true);

                                  // showAlreadyLearned = true;
                                  _initLearning();
                                },
                                selected: settings.showAlreadyLearned,
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
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setLanguageMode(LanguageMode.home);

                                  // currentLanguageMode = CurrentLanguageMode.home;
                                  _initLearning(); //Liste neu aufbauen
                                },

                                selected: settings.languageMode == LanguageMode.home,
                                text: "home",
                              ),
                              //show foreign language first
                              MenuButton(
                                onTap: () {
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setLanguageMode(LanguageMode.foreign);

                                  _initLearning(); //Liste neu aufbauen
                                },

                                selected: settings.languageMode == LanguageMode.foreign,
                                text: "foreign",
                              ),
                              //random language first
                              MenuButton(
                                onTap: () {
                                  ref
                                      .read(settingsProvider.notifier)
                                      .setLanguageMode(LanguageMode.random);
                                  _initLearning(); //Liste neu aufbauen
                                },

                                selected: settings.languageMode == LanguageMode.random,
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
