import 'dart:math';
import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class LearnModeScreen extends StatefulWidget {
  final String language;

  const LearnModeScreen({super.key, required this.language});

  @override
  State<LearnModeScreen> createState() => _LearnModeScreenState();
}

class _LearnModeScreenState extends State<LearnModeScreen> {
  bool showOnlyNotLearned = true;
  int currentIndex = 0;
  List<Word> learningList = [];

  @override
  void initState() {
    super.initState();
    _buildLearningList();
  }

  void _buildLearningList() {
    final allWords = WordService.getWordsForLanguage(widget.language);
    learningList = allWords.where((word) {
      if (showOnlyNotLearned) {
        return !word.learned;
      } else {
        return true;
      }
    }).toList();

    if (learningList.isNotEmpty) {
      learningList.shuffle();
      currentIndex = 0;
    } else {
      currentIndex = 0;
    }

    setState(() {});
  }

  void _next() {
    if (learningList.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % learningList.length;
    });
  }

  void _previous() {
    if (learningList.isEmpty) return;
    setState(() {
      currentIndex =
          (currentIndex - 1 + learningList.length) % learningList.length;
    });
  }

  void _toggleLearned() {
    setState(() {
      final word = learningList[currentIndex];
      word.learned = !word.learned;
      WordService.update(); // Speichern
      _buildLearningList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final word = learningList.isEmpty ? null : learningList[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lernen: ${widget.language}'),
        actions: [
          IconButton(
            icon: Icon(
              showOnlyNotLearned ? Icons.star_border : Icons.star,
              color: showOnlyNotLearned ? Colors.grey : Colors.amber,
            ),
            onPressed: () {
              setState(() {
                showOnlyNotLearned = !showOnlyNotLearned;
                _buildLearningList();
              });
            },
            tooltip: showOnlyNotLearned
                ? 'Zeige ALLE'
                : 'Zeige nur nicht-gelernte',
          )
        ],
      ),
      body: word == null
          ? const Center(child: Text('Keine Wörter verfügbar.'))
          : Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        word.word,
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        word.translation,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 32),
                      IconButton(
                        icon: Icon(
                          word.learned
                              ? Icons.star
                              : Icons.star_border,
                          color: word.learned ? Colors.amber : Colors.grey,
                          size: 48,
                        ),
                        onPressed: _toggleLearned,
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 48),
                    onPressed: _previous,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 48),
                    onPressed: _next,
                  ),
                ),
              ],
            ),
    );
  }
}
