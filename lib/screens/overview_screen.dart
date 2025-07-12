import 'package:flutter/material.dart';
import 'voc_screen.dart';
import '../services/word_service.dart';
import '../models/word.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WordService.loadWords();
  }

  void _addLanguage() {
    if (_controller.text.trim().isEmpty) return;
    final newLang = _controller.text.trim();
    setState(() {
      if (!_getLanguages().contains(newLang)) {
        // Add a dummy word for the new language
        WordService.words.add(
          Word(word: '', translation: '', language: newLang),
        );
        WordService.saveWords();
      }
      _controller.clear();
    });
  }

  void _showDeleteDialog(String language) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sprache löschen'),
          content: Text('Möchten Sie die Sprache "$language" und alle zugehörigen Wörter löschen?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                _deleteLanguage(language);
                Navigator.of(context).pop();
              },
              child: const Text('Löschen', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteLanguage(String language) {
    setState(() {
      WordService.words.removeWhere((w) => w.language == language);
      WordService.saveWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final languages = _getLanguages();
    return Scaffold(
      appBar: AppBar(title: const Text('Übersicht & Sprachen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ...languages.map((language) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: GestureDetector(
                    onLongPress: () => _showDeleteDialog(language),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VocScreen(language: language),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(double.infinity, 80),
                      ),
                      child: Text(
                        language,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Neue Sprache hinzufügen'),
                          content: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Sprache',
                            ),
                            autofocus: true,
                            onSubmitted: (_) {
                              Navigator.of(context).pop();
                              _addLanguage();
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Abbrechen'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                _addLanguage();
                              },
                              child: const Text('Hinzufügen'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(double.infinity, 80),
                    backgroundColor: Colors.green[400],
                  ),
                  child: const Text(
                    '+ Sprache hinzufügen',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )                                                
      ),
    );
  }

  List<String> _getLanguages() {
    final savedLangs = WordService.words.map((w) => w.language).where((l) => l.isNotEmpty).toSet();
    final allLangs = {'Englisch', 'Spanisch', 'Thai', ...savedLangs};
    final langsList = allLangs.toList();
    langsList.sort();
    return langsList;
  }
}
