import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/word_service.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  // Vorläufig statisch, später dynamisch laden
  final List<String> languages = ['Englisch', 'Spanisch', 'Thai'];

  void _showAddWordDialog(String language) {
    final wordController = TextEditingController();
    final translationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Neues Wort auf $language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                decoration: const InputDecoration(labelText: 'Wort'),
              ),
              TextField(
                controller: translationController,
                decoration: const InputDecoration(labelText: 'Übersetzung'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                String word = wordController.text.trim();
                String translation = translationController.text.trim();
                if (word.isNotEmpty && translation.isNotEmpty) {
                  WordService.addWord(Word(
                    word: word,
                    translation: translation,
                    language: language,
                  ));
                  Navigator.of(context).pop();
                  setState(() {}); // optional, um Buttons neu zu rendern
                }
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wort hinzufügen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: languages.map((language) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 24, // zwei nebeneinander
                child: 
                ElevatedButton(
                  onPressed: () => _showAddWordDialog(language),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(double.infinity, 80),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 24), // hier das + Symbol
                        const SizedBox(height: 4),
                        Text(
                          language,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),                      
                        ),                      
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
