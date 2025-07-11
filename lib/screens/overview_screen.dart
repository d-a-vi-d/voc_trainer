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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Neue Sprache',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addLanguage,
                  child: const Text('Hinzufügen'),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3,
              ),
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isDefaultLanguage = ['Englisch', 'Spanisch', 'Thai'].contains(language);
                
                return GestureDetector(
                  onLongPress: () {
                    if (!isDefaultLanguage) {
                      _showDeleteDialog(language);
                    }
                  },
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            language,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        if (!isDefaultLanguage)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
